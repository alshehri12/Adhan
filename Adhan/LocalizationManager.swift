//
//  LocalizationManager.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import Foundation
import SwiftUI

enum SupportedLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"
    case french = "fr"
    case urdu = "ur"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        case .french: return "Français"
        case .urdu: return "اردو"
        }
    }
    
    var localizedKey: String {
        switch self {
        case .english: return "language_english"
        case .arabic: return "language_arabic"
        case .french: return "language_french"
        case .urdu: return "language_urdu"
        }
    }
    
    var isRTL: Bool {
        return self == .arabic || self == .urdu
    }
}

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: SupportedLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            updateBundle()
        }
    }
    
    private var bundle = Bundle.main
    
    private init() {
        // Check if user has manually selected a language
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = SupportedLanguage(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            // Auto-detect system language
            let systemLanguage = Locale.current.language.languageCode?.identifier ?? "en"
            
            switch systemLanguage {
            case "ar":
                self.currentLanguage = .arabic
            case "fr":
                self.currentLanguage = .french
            case "ur":
                self.currentLanguage = .urdu
            default:
                self.currentLanguage = .english
            }
        }
        updateBundle()
    }
    
    private func updateBundle() {
        if let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            self.bundle = bundle
        } else {
            self.bundle = Bundle.main
        }
    }
    
    func localizedString(_ key: String, comment: String = "") -> String {
        return bundle.localizedString(forKey: key, value: key, table: nil)
    }
    
    func setLanguage(_ language: SupportedLanguage) {
        currentLanguage = language
    }
    
    func restartApp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // This will ask the user to restart the app manually
            // since iOS doesn't allow programmatic app restart
            if let url = URL(string: "App-prefs:") {
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - Localized String Extension

extension String {
    var localized: String {
        return LocalizationManager.shared.localizedString(self)
    }
    
    func localized(with arguments: [CVarArg]) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// MARK: - Environment Key for Localization

struct LocalizationKey: EnvironmentKey {
    static let defaultValue = LocalizationManager.shared
}

extension EnvironmentValues {
    var localization: LocalizationManager {
        get { self[LocalizationKey.self] }
        set { self[LocalizationKey.self] = newValue }
    }
} 