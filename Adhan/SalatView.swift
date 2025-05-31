//
//  SalatView.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI

struct SalatView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var apiManager = PrayerTimeAPIManager.shared
    @StateObject private var userSettings = UserSettings.shared
    @State private var currentTime = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with location and date
                    headerSection
                    
                    // Loading or Error States
                    if apiManager.isLoading {
                        loadingView
                    } else if let errorMessage = apiManager.errorMessage {
                        errorView(errorMessage)
                    } else if let prayerTimes = apiManager.currentPrayerTimes {
                        // Current prayer and countdown
                        currentPrayerCard(prayerTimes: prayerTimes)
                        
                        // All prayer times
                        allPrayerTimesSection(prayerTimes: prayerTimes)
                    } else {
                        emptyStateView
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(
                LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("tab_salat".localized)
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await loadPrayerTimes()
            }
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .onAppear {
            Task {
                await loadPrayerTimes()
            }
        }
        .onChange(of: locationManager.location) { _ in
            Task {
                await loadPrayerTimes()
            }
        }
        .onChange(of: userSettings.selectedJuristicMethod) { _ in
            Task {
                await loadPrayerTimes()
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(AppColors.accent)
            
            Text("loading_prayer_times".localized)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    // MARK: - Error View
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(AppColors.accent)
            
            Text("unable_load_times".localized)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("try_again".localized) {
                Task {
                    await loadPrayerTimes()
                }
            }
            .padding()
            .background(AppColors.accent)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.slash")
                .font(.system(size: 50))
                .foregroundColor(AppColors.accent)
            
            Text("location_required".localized)
                .font(.headline)
                .foregroundColor(.white)
            
            Text("location_permission_message".localized)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
            
            Button("retry".localized) {
                locationManager.requestLocationPermission()
                Task {
                    await loadPrayerTimes()
                }
            }
            .padding()
            .background(AppColors.accent)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "location")
                    .foregroundColor(AppColors.accent)
                Text(locationManager.city)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
            }
            
            HStack {
                Text(DateFormatter.prayerDate.string(from: currentTime))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
            }
        }
        .padding()
        .background(AppColors.cardBackground.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Current Prayer Card
    
    private func currentPrayerCard(prayerTimes: PrayerTimes) -> some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("next_prayer".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(localizedPrayerName(nextPrayer(prayerTimes: prayerTimes).name))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primary)
                    
                    Text(nextPrayer(prayerTimes: prayerTimes).arabicName)
                        .font(.title3)
                        .foregroundColor(AppColors.textSecondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("time_remaining".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text(timeUntilNextPrayer(prayerTimes: prayerTimes))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.accent)
                        .monospacedDigit()
                }
            }
            
            HStack {
                Image(systemName: nextPrayerIcon(prayerTimes: prayerTimes))
                    .foregroundColor(AppColors.primary)
                    .font(.title2)
                
                Text(DateFormatter.prayerTime.string(from: nextPrayer(prayerTimes: prayerTimes).time))
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textPrimary)
                
                Spacer()
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - All Prayer Times Section
    
    private func allPrayerTimesSection(prayerTimes: PrayerTimes) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("today_prayer_times".localized)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            
            LazyVStack(spacing: 8) {
                ForEach(prayerTimes.allPrayers, id: \.name) { prayer in
                    PrayerTimeRow(
                        name: localizedPrayerName(prayer.name),
                        arabicName: prayer.arabicName,
                        time: prayer.time,
                        isNext: prayer.name == nextPrayer(prayerTimes: prayerTimes).name,
                        icon: Prayer(rawValue: prayer.name)?.icon ?? "clock"
                    )
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadPrayerTimes() {
        Task {
            await apiManager.fetchPrayerTimes(
                latitude: locationManager.location?.coordinate.latitude ?? 0,
                longitude: locationManager.location?.coordinate.longitude ?? 0,
                method: 4, // Hardcoded to Umm al-Qura
                school: userSettings.selectedJuristicMethod.schoolId
            )
        }
    }
    
    // MARK: - Computed Properties
    
    private func nextPrayer(prayerTimes: PrayerTimes) -> (name: String, time: Date, arabicName: String) {
        let prayers = prayerTimes.allPrayers
        
        // Find the next prayer
        for prayer in prayers {
            if prayer.time > currentTime {
                return prayer
            }
        }
        
        // If no prayer is left today, return Fajr of tomorrow
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentTime) ?? currentTime
        
        // We would need to fetch tomorrow's times, but for now return estimated Fajr
        let tomorrowFajr = calendar.date(bySettingHour: 5, minute: 30, second: 0, of: tomorrow) ?? tomorrow
        
        return ("Fajr", tomorrowFajr, "الفجر")
    }
    
    private func nextPrayerIcon(prayerTimes: PrayerTimes) -> String {
        return Prayer(rawValue: nextPrayer(prayerTimes: prayerTimes).name)?.icon ?? "clock"
    }
    
    private func timeUntilNextPrayer(prayerTimes: PrayerTimes) -> String {
        let timeInterval = nextPrayer(prayerTimes: prayerTimes).time.timeIntervalSince(currentTime)
        
        if timeInterval <= 0 {
            return "00:00:00"
        }
        
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) % 3600 / 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func localizedPrayerName(_ prayerName: String) -> String {
        let key = "prayer_\(prayerName.lowercased())"
        return key.localized
    }
}

// MARK: - Prayer Time Row Component

struct PrayerTimeRow: View {
    let name: String
    let arabicName: String
    let time: Date
    let isNext: Bool
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(isNext ? AppColors.accent : AppColors.primary)
                .font(.title3)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(arabicName)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Text(DateFormatter.prayerTime.string(from: time))
                .font(.headline)
                .fontWeight(isNext ? .bold : .medium)
                .foregroundColor(isNext ? AppColors.accent : AppColors.textPrimary)
                .monospacedDigit()
        }
        .padding()
        .background(
            isNext ? AppColors.accent.opacity(0.1) : AppColors.cardBackground
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isNext ? AppColors.accent : Color.clear, lineWidth: 1)
        )
    }
}

// MARK: - Date Formatters

extension DateFormatter {
    static let prayerTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let prayerDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

#Preview {
    SalatView()
} 