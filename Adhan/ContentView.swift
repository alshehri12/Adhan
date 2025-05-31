//
//  ContentView.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        TabView {
            SalatView()
                .tabItem {
                    Image(systemName: "clock")
                    Text("tab_salat".localized)
                }
            
            QiblahView()
                .tabItem {
                    Image(systemName: "location.north")
                    Text("tab_qiblah".localized)
                }
            
            AdhkarView()
                .tabItem {
                    Image(systemName: "book.closed")
                    Text("tab_adhkar".localized)
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("tab_settings".localized)
                }
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .environment(\.localization, localizationManager)
        .accentColor(AppColors.primary)
        .onAppear {
            LocationManager.shared.requestLocationPermission()
        }
    }
}

#Preview {
    ContentView()
}
