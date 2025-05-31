//
//  UserSettings.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import Foundation

class UserSettings: ObservableObject {
    static let shared = UserSettings()
    
    @Published var selectedJuristicMethod: JuristicMethod {
        didSet {
            UserDefaults.standard.set(selectedJuristicMethod.rawValue, forKey: "juristicMethod")
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    @Published var adhanSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(adhanSoundEnabled, forKey: "adhanSoundEnabled")
        }
    }
    
    @Published var vibrationsEnabled: Bool {
        didSet {
            UserDefaults.standard.set(vibrationsEnabled, forKey: "vibrationsEnabled")
        }
    }
    
    private init() {
        // Load saved settings or set defaults
        let savedJuristicMethod = UserDefaults.standard.string(forKey: "juristicMethod")
        self.selectedJuristicMethod = JuristicMethod(rawValue: savedJuristicMethod ?? "") ?? .shafi
        
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        self.adhanSoundEnabled = UserDefaults.standard.bool(forKey: "adhanSoundEnabled")
        self.vibrationsEnabled = UserDefaults.standard.bool(forKey: "vibrationsEnabled")
        
        // Set default values if first launch
        if UserDefaults.standard.object(forKey: "notificationsEnabled") == nil {
            self.notificationsEnabled = true
            self.adhanSoundEnabled = true
            self.vibrationsEnabled = true
        }
    }
} 