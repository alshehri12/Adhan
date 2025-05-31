//
//  SettingsView.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var userSettings = UserSettings.shared
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var isDarkMode = false
    @State private var showLanguageAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // Prayer Settings Section
                Section("prayer_settings".localized) {
                    juristicMethodRow
                }
                
                // Notification Settings Section
                Section("notifications_title".localized) {
                    notificationToggleRow
                    adhanSoundRow
                    vibrationRow
                }
                
                // Location Settings Section
                Section("Location") {
                    currentLocationRow
                    manageLocationsRow
                }
                
                // App Settings Section
                Section("app_settings".localized) {
                    languageRow
                    themeRow
                }
                
                // Information Section
                Section("about".localized) {
                    aboutRow
                    helpRow
                    privacyPolicyRow
                }
                
                // App Version
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 4) {
                            Text("Adhan App")
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                            
                            Text("version".localized + " 1.0.0")
                                .font(.caption2)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle("tab_settings".localized)
            .background(AppColors.backgroundLight)
            .alert("restart_required".localized, isPresented: $showLanguageAlert) {
                Button("restart_now".localized) {
                    localizationManager.restartApp()
                }
                Button("restart_later".localized, role: .cancel) {}
            } message: {
                Text("restart_message".localized)
            }
        }
    }
    
    // MARK: - Prayer Settings
    
    private var juristicMethodRow: some View {
        NavigationLink(destination: JuristicMethodSelectionView()) {
            SettingsRow(
                icon: "book.closed",
                title: "juristic_method".localized,
                subtitle: userSettings.selectedJuristicMethod.rawValue,
                iconColor: AppColors.secondary
            )
        }
    }
    
    // MARK: - Notification Settings
    
    private var notificationToggleRow: some View {
        HStack {
            SettingsIconView(icon: "bell", color: AppColors.accent)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("notifications_enabled".localized)
                    .font(.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Receive notifications for prayer times")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $userSettings.notificationsEnabled)
                .labelsHidden()
        }
    }
    
    private var adhanSoundRow: some View {
        HStack {
            SettingsIconView(icon: "speaker.wave.2", color: AppColors.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("adhan_sound".localized)
                    .font(.body)
                    .foregroundColor(userSettings.notificationsEnabled ? AppColors.textPrimary : AppColors.textSecondary)
                
                Text("Play Adhan for prayer notifications")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $userSettings.adhanSoundEnabled)
                .labelsHidden()
                .disabled(!userSettings.notificationsEnabled)
        }
    }
    
    private var vibrationRow: some View {
        HStack {
            SettingsIconView(icon: "iphone.radiowaves.left.and.right", color: AppColors.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("vibrations".localized)
                    .font(.body)
                    .foregroundColor(userSettings.notificationsEnabled ? AppColors.textPrimary : AppColors.textSecondary)
                
                Text("Vibrate for prayer notifications")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $userSettings.vibrationsEnabled)
                .labelsHidden()
                .disabled(!userSettings.notificationsEnabled)
        }
    }
    
    // MARK: - Location Settings
    
    private var currentLocationRow: some View {
        NavigationLink(destination: LocationSettingsView()) {
            SettingsRow(
                icon: "location",
                title: "Current Location",
                subtitle: LocationManager.shared.city,
                iconColor: AppColors.accent
            )
        }
    }
    
    private var manageLocationsRow: some View {
        NavigationLink(destination: ManageLocationsView()) {
            SettingsRow(
                icon: "map",
                title: "Manage Locations",
                subtitle: "Add or edit saved locations",
                iconColor: AppColors.primary
            )
        }
    }
    
    // MARK: - App Settings
    
    private var languageRow: some View {
        NavigationLink(destination: LanguageSelectionView()) {
            SettingsRow(
                icon: "globe",
                title: "language_setting".localized,
                subtitle: localizationManager.currentLanguage.displayName,
                iconColor: AppColors.secondary
            )
        }
    }
    
    private var themeRow: some View {
        HStack {
            SettingsIconView(icon: "paintbrush", color: AppColors.primary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Dark Mode")
                    .font(.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Use dark theme")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Toggle("", isOn: $isDarkMode)
                .labelsHidden()
        }
    }
    
    // MARK: - Information Rows
    
    private var aboutRow: some View {
        NavigationLink(destination: AboutView()) {
            SettingsRow(
                icon: "info.circle",
                title: "About",
                subtitle: "Learn more about this app",
                iconColor: AppColors.primary
            )
        }
    }
    
    private var helpRow: some View {
        NavigationLink(destination: HelpView()) {
            SettingsRow(
                icon: "questionmark.circle",
                title: "Help & Support",
                subtitle: "Get help using the app",
                iconColor: AppColors.secondary
            )
        }
    }
    
    private var privacyPolicyRow: some View {
        NavigationLink(destination: PrivacyPolicyView()) {
            SettingsRow(
                icon: "lock.shield",
                title: "Privacy Policy",
                subtitle: "Review our privacy policy",
                iconColor: AppColors.accent
            )
        }
    }
}

// MARK: - Settings Components

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            SettingsIconView(icon: icon, color: iconColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsIconView: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .foregroundColor(.white)
            .font(.body)
            .frame(width: 32, height: 32)
            .background(color)
            .cornerRadius(8)
    }
}

// MARK: - Enhanced Settings Detail Views

struct JuristicMethodSelectionView: View {
    @StateObject private var userSettings = UserSettings.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(JuristicMethod.allCases, id: \.self) { method in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(method.rawValue)
                            .font(.headline)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(method == .shafi ? 
                             "Asr begins when shadow equals object length" :
                             "Asr begins when shadow equals twice object length")
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    if userSettings.selectedJuristicMethod == method {
                        Image(systemName: "checkmark")
                            .foregroundColor(AppColors.primary)
                            .font(.headline)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    userSettings.selectedJuristicMethod = method
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("About Juristic Methods")
                        .font(.headline)
                        .foregroundColor(AppColors.primary)
                    
                    Text("Different schools of Islamic jurisprudence have varying methods for calculating Asr prayer time based on shadow length.")
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("• Shafi/Maliki/Hanbali: Shadow equals object length")
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                    
                    Text("• Hanafi: Shadow equals twice the object length")
                        .font(.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Juristic Method")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Placeholder Detail Views (Updated)

struct CalculationMethodView: View {
    @Binding var selectedMethod: CalculationMethod
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(CalculationMethod.allCases, id: \.self) { method in
                HStack {
                    Text(method.description)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    if selectedMethod == method {
                        Image(systemName: "checkmark")
                            .foregroundColor(AppColors.primary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedMethod = method
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Calculation Method")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct JuristicMethodView: View {
    @Binding var selectedMethod: JuristicMethod
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(JuristicMethod.allCases, id: \.self) { method in
                HStack {
                    Text(method.rawValue)
                        .foregroundColor(AppColors.textPrimary)
                    
                    Spacer()
                    
                    if selectedMethod == method {
                        Image(systemName: "checkmark")
                            .foregroundColor(AppColors.primary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedMethod = method
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .navigationTitle("Juristic Method")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LanguageSelectionView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showRestartAlert = false
    
    var body: some View {
        List {
            ForEach(SupportedLanguage.allCases) { language in
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(language.displayName)
                            .font(.body)
                            .foregroundColor(AppColors.textPrimary)
                        
                        if language != .english {
                            Text(language.localizedKey.localized)
                                .font(.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    }
                    
                    Spacer()
                    
                    if localizationManager.currentLanguage == language {
                        Image(systemName: "checkmark")
                            .foregroundColor(AppColors.primary)
                            .font(.headline)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if localizationManager.currentLanguage != language {
                        localizationManager.setLanguage(language)
                        showRestartAlert = true
                    }
                }
            }
        }
        .navigationTitle("language_setting".localized)
        .navigationBarTitleDisplayMode(.inline)
        .alert("restart_required".localized, isPresented: $showRestartAlert) {
            Button("restart_now".localized) {
                localizationManager.restartApp()
            }
            Button("restart_later".localized, role: .cancel) {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("restart_message".localized)
        }
    }
}

// Simple placeholder views for other settings screens
struct LocationSettingsView: View {
    var body: some View {
        Text("Location Settings")
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct ManageLocationsView: View {
    var body: some View {
        Text("Manage Locations")
            .navigationTitle("Locations")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Adhan - Prayer Companion")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
                
                Text("A beautiful and accurate Islamic prayer times app designed to help Muslims worldwide stay connected to their faith.")
                    .font(.body)
                    .foregroundColor(AppColors.textPrimary)
                
                Text("Features:")
                    .font(.headline)
                    .foregroundColor(AppColors.primary)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("• Accurate prayer times calculations")
                    Text("• Qiblah direction compass")
                    Text("• Daily Adhkar and supplications")
                    Text("• Customizable notifications")
                    Text("• Multiple calculation methods")
                    Text("• Beautiful, spiritual design")
                }
                .font(.body)
                .foregroundColor(AppColors.textPrimary)
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpView: View {
    var body: some View {
        Text("Help & Support")
            .navigationTitle("Help")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        Text("Privacy Policy")
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
} 