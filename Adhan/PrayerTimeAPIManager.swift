//
//  PrayerTimeAPIManager.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import Foundation
import CoreLocation

// MARK: - API Response Models

struct PrayerTimesResponse: Codable {
    let code: Int
    let status: String
    let data: PrayerDayData
}

struct PrayerDayData: Codable {
    let timings: PrayerTimings
    let date: PrayerDate
    let meta: PrayerMeta?  // Made optional in case some methods don't include meta
}

struct PrayerTimings: Codable {
    let Fajr: String
    let Sunrise: String?     // Made optional - some methods might not include
    let Dhuhr: String
    let Asr: String
    let Sunset: String?      // Made optional - some methods might not include
    let Maghrib: String
    let Isha: String
    let Imsak: String?       // Made optional - often not included
    let Midnight: String?    // Made optional - often not included
    let Firstthird: String?  // Made optional - often not included
    let Lastthird: String?   // Made optional - often not included
    
    // Handle potential different field names
    enum CodingKeys: String, CodingKey {
        case Fajr, Dhuhr, Asr, Maghrib, Isha
        case Sunrise, Sunset, Imsak, Midnight
        case Firstthird = "Firstthird"
        case Lastthird = "Lastthird"
    }
}

struct PrayerDate: Codable {
    let readable: String?
    let timestamp: String?
    let hijri: HijriDate?
    let gregorian: GregorianDate?
}

struct HijriDate: Codable {
    let date: String?
    let format: String?
    let day: String?
    let weekday: HijriWeekday?
    let month: HijriMonth?
    let year: String?
    let designation: Designation?
    let holidays: [String]?
}

struct GregorianDate: Codable {
    let date: String?
    let format: String?
    let day: String?
    let weekday: GregorianWeekday?
    let month: GregorianMonth?
    let year: String?
    let designation: Designation?
}

struct HijriWeekday: Codable {
    let en: String?
    let ar: String?
}

struct GregorianWeekday: Codable {
    let en: String?
}

struct HijriMonth: Codable {
    let number: Int?
    let en: String?
    let ar: String?
}

struct GregorianMonth: Codable {
    let number: Int?
    let en: String?
}

struct Designation: Codable {
    let abbreviated: String?
    let expanded: String?
}

struct PrayerMeta: Codable {
    let latitude: Double?
    let longitude: Double?
    let timezone: String?
    let method: PrayerMethod?
    let latitudeAdjustmentMethod: String?
    let midnightMode: String?
    let school: String?
    let offset: [String: Int]?
}

struct PrayerMethod: Codable {
    let id: Int?
    let name: String?
    let params: PrayerMethodParams?
}

struct PrayerMethodParams: Codable {
    let Fajr: Double?
    let Isha: Double?
    
    // Handle potential variations in parameter names
    enum CodingKeys: String, CodingKey {
        case Fajr, Isha
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode as Double, but also handle potential String values
        if let fajrDouble = try? container.decode(Double.self, forKey: .Fajr) {
            Fajr = fajrDouble
        } else if let fajrString = try? container.decode(String.self, forKey: .Fajr),
                  let fajrDouble = Double(fajrString) {
            Fajr = fajrDouble
        } else {
            Fajr = nil
        }
        
        if let ishaDouble = try? container.decode(Double.self, forKey: .Isha) {
            Isha = ishaDouble
        } else if let ishaString = try? container.decode(String.self, forKey: .Isha),
                  let ishaDouble = Double(ishaString) {
            Isha = ishaDouble
        } else {
            Isha = nil
        }
    }
}

// MARK: - API Manager

@MainActor
class PrayerTimeAPIManager: ObservableObject {
    static let shared = PrayerTimeAPIManager()
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentPrayerTimes: PrayerTimes?
    
    private let baseURL = "https://api.aladhan.com/v1"
    private let session = URLSession.shared
    
    private init() {}
    
    func fetchPrayerTimes(
        latitude: Double,
        longitude: Double,
        method: Int = 4, // Default to Umm al-Qura
        school: Int = 0  // 0 = Shafi, 1 = Hanafi
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let timestamp = Int(Date().timeIntervalSince1970)
            let urlString = "\(baseURL)/timings/\(timestamp)?latitude=\(latitude)&longitude=\(longitude)&method=\(method)&school=\(school)"
            
            print("🌐 API URL: \(urlString)")
            
            guard let url = URL(string: urlString) else {
                throw APIError.invalidURL
            }
            
            let (data, response) = try await session.data(from: url)
            
            // Debug: Print raw response
            if let rawJSON = String(data: data, encoding: .utf8) {
                print("📥 Raw JSON Response: \(rawJSON)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.serverError
            }
            
            print("📡 HTTP Status Code: \(httpResponse.statusCode)")
            
            guard httpResponse.statusCode == 200 else {
                throw APIError.serverError
            }
            
            let apiResponse = try JSONDecoder().decode(PrayerTimesResponse.self, from: data)
            
            print("✅ Successfully decoded API response")
            print("🔢 API Response Code: \(apiResponse.code)")
            
            if apiResponse.code == 200 {
                currentPrayerTimes = convertToPrayerTimes(from: apiResponse.data)
                print("🕌 Prayer times converted successfully")
            } else {
                throw APIError.invalidData
            }
            
        } catch let decodingError as DecodingError {
            // Enhanced error handling for JSON parsing issues
            switch decodingError {
            case .keyNotFound(let key, let context):
                errorMessage = "Missing required field '\(key.stringValue)' in API response"
                print("❌ Missing key: \(key.stringValue) in \(context.debugDescription)")
                
            case .typeMismatch(let type, let context):
                errorMessage = "Wrong data type for field (expected \(type)) in API response"
                print("❌ Type mismatch: expected \(type) in \(context.debugDescription)")
                
            case .valueNotFound(let type, let context):
                errorMessage = "Required field of type \(type) was null in API response"
                print("❌ Value not found: \(type) in \(context.debugDescription)")
                
            case .dataCorrupted(let context):
                errorMessage = "Invalid data format in API response"
                print("❌ Data corrupted: \(context.debugDescription)")
                
            @unknown default:
                errorMessage = "Unknown parsing error: \(decodingError.localizedDescription)"
                print("❌ Unknown decoding error: \(decodingError)")
            }
            
        } catch let apiError as APIError {
            errorMessage = apiError.localizedDescription
            print("❌ API Error: \(apiError)")
            
        } catch {
            errorMessage = "Failed to fetch prayer times: \(error.localizedDescription)"
            print("❌ General error: \(error)")
        }
        
        isLoading = false
    }
    
    private func convertToPrayerTimes(from data: PrayerDayData) -> PrayerTimes {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let today = Date()
        
        let fajr = createTime(from: data.timings.Fajr, date: today, formatter: formatter)
        let sunrise = createTime(from: data.timings.Sunrise ?? "06:00", date: today, formatter: formatter)
        let dhuhr = createTime(from: data.timings.Dhuhr, date: today, formatter: formatter)
        let asr = createTime(from: data.timings.Asr, date: today, formatter: formatter)
        let maghrib = createTime(from: data.timings.Maghrib, date: today, formatter: formatter)
        let isha = createTime(from: data.timings.Isha, date: today, formatter: formatter)
        
        print("🕐 Converted prayer times:")
        print("   Fajr: \(DateFormatter.debugTime.string(from: fajr))")
        print("   Shrouq: \(DateFormatter.debugTime.string(from: sunrise))")
        print("   Dhuhr: \(DateFormatter.debugTime.string(from: dhuhr))")
        print("   Asr: \(DateFormatter.debugTime.string(from: asr))")
        print("   Maghrib: \(DateFormatter.debugTime.string(from: maghrib))")
        print("   Isha: \(DateFormatter.debugTime.string(from: isha))")
        
        return PrayerTimes(
            fajr: fajr,
            sunrise: sunrise,
            dhuhr: dhuhr,
            asr: asr,
            maghrib: maghrib,
            isha: isha,
            date: today
        )
    }
    
    private func createTime(from timeString: String, date: Date, formatter: DateFormatter) -> Date {
        // Remove timezone info if present (e.g., "05:30 (+03)" -> "05:30")
        let cleanTimeString = timeString.components(separatedBy: " ").first ?? timeString
        
        if let time = formatter.date(from: cleanTimeString) {
            let calendar = Calendar.current
            let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
            return calendar.date(bySettingHour: timeComponents.hour ?? 0,
                               minute: timeComponents.minute ?? 0,
                               second: 0,
                               of: date) ?? date
        }
        
        return date
    }
}

// MARK: - Error Types

enum APIError: LocalizedError {
    case invalidURL
    case serverError
    case invalidData
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server error"
        case .invalidData:
            return "Invalid data received"
        case .networkError:
            return "Network connection error"
        }
    }
}

// MARK: - Debug Helper

extension DateFormatter {
    static let debugTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
} 