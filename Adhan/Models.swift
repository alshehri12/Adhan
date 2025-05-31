//
//  Models.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import Foundation

// MARK: - Prayer Time Models

struct PrayerTimes {
    let fajr: Date
    let sunrise: Date
    let dhuhr: Date
    let asr: Date
    let maghrib: Date
    let isha: Date
    let date: Date
    
    var allPrayers: [(name: String, time: Date, arabicName: String)] {
        return [
            ("Fajr", fajr, "الفجر"),
            ("Shrouq", sunrise, "الشروق"),
            ("Dhuhr", dhuhr, "الظهر"),
            ("Asr", asr, "العصر"),
            ("Maghrib", maghrib, "المغرب"),
            ("Isha", isha, "العشاء")
        ]
    }
}

enum Prayer: String, CaseIterable {
    case fajr = "Fajr"
    case shrouq = "Shrouq"
    case dhuhr = "Dhuhr" 
    case asr = "Asr"
    case maghrib = "Maghrib"
    case isha = "Isha"
    
    var arabicName: String {
        switch self {
        case .fajr: return "الفجر"
        case .shrouq: return "الشروق"
        case .dhuhr: return "الظهر"
        case .asr: return "العصر"
        case .maghrib: return "المغرب"
        case .isha: return "العشاء"
        }
    }
    
    var icon: String {
        switch self {
        case .fajr: return "moon.stars"
        case .shrouq: return "sunrise"
        case .dhuhr: return "sun.max"
        case .asr: return "sun.min"
        case .maghrib: return "sunset"
        case .isha: return "moon"
        }
    }
}

// MARK: - Calculation Methods

enum CalculationMethod: String, CaseIterable {
    case islamicFinder = "Islamic Finder"
    case makkah = "Umm Al-Qura (Makkah)"
    case karachi = "Karachi"
    case isna = "ISNA"
    case mwl = "Muslim World League"
    
    var description: String {
        return self.rawValue
    }
}

enum JuristicMethod: String, CaseIterable {
    case shafi = "Shafi/Maliki/Hanbali"
    case hanafi = "Hanafi"
    
    var schoolId: Int {
        switch self {
        case .shafi:
            return 0
        case .hanafi:
            return 1
        }
    }
}

// MARK: - Adhkar Models

struct Dhikr: Identifiable {
    let id = UUID()
    let arabic: String
    let transliteration: String
    let translation: String
    let category: DhikrCategory
    let count: Int?
    let source: String?
    let isFavorite: Bool = false
}

enum DhikrCategory: String, CaseIterable {
    case morning = "Morning Adhkar"
    case evening = "Evening Adhkar" 
    case afterPrayer = "After Prayer"
    case beforeSleep = "Before Sleep"
    case wakeUp = "Upon Waking"
    case daily = "Daily Supplications"
    case protection = "Protection"
    
    var icon: String {
        switch self {
        case .morning: return "sun.and.horizon"
        case .evening: return "moon.and.stars"
        case .afterPrayer: return "hands.sparkles"
        case .beforeSleep: return "bed.double"
        case .wakeUp: return "alarm"
        case .daily: return "book"
        case .protection: return "shield"
        }
    }
}

// MARK: - Sample Data

extension PrayerTimes {
    static var sample: PrayerTimes {
        let calendar = Calendar.current
        let now = Date()
        
        return PrayerTimes(
            fajr: calendar.date(bySettingHour: 5, minute: 30, second: 0, of: now) ?? now,
            sunrise: calendar.date(bySettingHour: 6, minute: 0, second: 0, of: now) ?? now,
            dhuhr: calendar.date(bySettingHour: 12, minute: 15, second: 0, of: now) ?? now,
            asr: calendar.date(bySettingHour: 15, minute: 45, second: 0, of: now) ?? now,
            maghrib: calendar.date(bySettingHour: 18, minute: 30, second: 0, of: now) ?? now,
            isha: calendar.date(bySettingHour: 20, minute: 0, second: 0, of: now) ?? now,
            date: now
        )
    }
}

extension Dhikr {
    static var sampleAdhkar: [Dhikr] {
        return [
            Dhikr(
                arabic: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ",
                transliteration: "Asbahna wa asbahal-mulku lillah, walhamdu lillah",
                translation: "We have reached the morning and with it Allah's dominion, and praise is to Allah",
                category: .morning,
                count: 1,
                source: "Muslim"
            ),
            Dhikr(
                arabic: "سُبْحَانَ اللهِ وَبِحَمْدِهِ",
                transliteration: "Subhan Allah wa bihamdihi",
                translation: "Glory is to Allah and praise is to Him",
                category: .daily,
                count: 100,
                source: "Bukhari & Muslim"
            ),
            Dhikr(
                arabic: "رَبِّ اغْفِرْ لِي ذَنْبِي وَخَطَئِي وَجَهْلِي",
                transliteration: "Rabbi ghfir li dhanbi wa khata'i wa jahli",
                translation: "My Lord, forgive my sin, my mistake, and my ignorance",
                category: .afterPrayer,
                count: 3,
                source: "Bukhari & Muslim"
            )
        ]
    }
} 