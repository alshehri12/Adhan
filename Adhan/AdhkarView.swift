//
//  AdhkarView.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI

struct AdhkarView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header text
                    VStack(spacing: 8) {
                        Text("adhkar_main_title".localized)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Text("adhkar_main_subtitle".localized)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Three main category squares
                    VStack(spacing: 20) {
                        // Morning Adhkar
                        NavigationLink(destination: AdhkarDetailView(category: .morning)) {
                            AdhkarCategorySquare(
                                category: .morning,
                                titleKey: "adhkar_morning_title",
                                arabicTitle: "اذكار الصباح",
                                icon: "sun.and.horizon",
                                gradientColors: [Color.orange.opacity(0.8), Color.yellow.opacity(0.6)]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // Evening Adhkar
                        NavigationLink(destination: AdhkarDetailView(category: .evening)) {
                            AdhkarCategorySquare(
                                category: .evening,
                                titleKey: "adhkar_evening_title",
                                arabicTitle: "اذكار المساء",
                                icon: "moon.and.stars",
                                gradientColors: [Color.purple.opacity(0.8), Color.blue.opacity(0.6)]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        // After Prayer Adhkar
                        NavigationLink(destination: AdhkarDetailView(category: .afterPrayer)) {
                            AdhkarCategorySquare(
                                category: .afterPrayer,
                                titleKey: "adhkar_after_prayer_title",
                                arabicTitle: "اذكار بعد الصلاة",
                                icon: "hands.sparkles",
                                gradientColors: [Color.green.opacity(0.8), Color.teal.opacity(0.6)]
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .background(
                LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
            .navigationTitle("tab_adhkar".localized)
            .navigationBarTitleDisplayMode(.large)
        }
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

// MARK: - Adhkar Category Square

struct AdhkarCategorySquare: View {
    let category: AdhkarCategory
    let titleKey: String
    let arabicTitle: String
    let icon: String
    let gradientColors: [Color]
    
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.white)
            
            // Title based on language
            VStack(spacing: 4) {
                if localizationManager.currentLanguage == .arabic {
                    // Show only Arabic for Arabic users
                    Text(arabicTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                } else {
                    // Show localized title first, then Arabic below for non-Arabic users
                    Text(titleKey.localized)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(arabicTitle)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .padding(20)
        .background(
            LinearGradient(
                colors: gradientColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Adhkar Detail View

struct AdhkarDetailView: View {
    let category: AdhkarCategory
    @StateObject private var localizationManager = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    private var categoryAdhkar: [Adhkar] {
        Adhkar.sampleAdhkar.filter { $0.category == category }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(categoryAdhkar) { adhkar in
                    AdhkarCard(adhkar: adhkar)
                }
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
        .navigationTitle(getCategoryTitle())
        .navigationBarTitleDisplayMode(.large)
        .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
    
    private func getCategoryTitle() -> String {
        switch category {
        case .morning:
            return localizationManager.currentLanguage == .arabic ? "اذكار الصباح" : "adhkar_morning_title".localized
        case .evening:
            return localizationManager.currentLanguage == .arabic ? "اذكار المساء" : "adhkar_evening_title".localized
        case .afterPrayer:
            return localizationManager.currentLanguage == .arabic ? "اذكار بعد الصلاة" : "adhkar_after_prayer_title".localized
        }
    }
}

// MARK: - Adhkar Card

struct AdhkarCard: View {
    let adhkar: Adhkar
    @StateObject private var localizationManager = LocalizationManager.shared
    @State private var currentCount = 0
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: getAlignment(), spacing: 16) {
            // Header with favorite button and source
            HStack {
                if localizationManager.currentLanguage.isRTL {
                    favoriteButton
                    Spacer()
                    sourceInfo
                } else {
                    sourceInfo
                    Spacer()
                    favoriteButton
                }
            }
            
            // Arabic text (always displayed prominently)
            Text(adhkar.arabicText)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(localizationManager.currentLanguage.isRTL ? .trailing : .center)
                .frame(maxWidth: .infinity, alignment: localizationManager.currentLanguage.isRTL ? .trailing : .center)
                .padding(.vertical, 8)
            
            // Conditional transliteration and translation (only for non-Arabic)
            if localizationManager.currentLanguage != .arabic {
                VStack(spacing: 8) {
                    // Transliteration
                    if let transliteration = adhkar.transliteration {
                        Text(transliteration)
                            .font(.body)
                            .foregroundColor(AppColors.textSecondary)
                            .italic()
                            .multilineTextAlignment(.center)
                    }
                    
                    // Translation in current language
                    if let translation = getTranslation() {
                        Text(translation)
                            .font(.body)
                            .foregroundColor(AppColors.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            
            // Counter section (if applicable)
            if let repeatCount = adhkar.repeatCount {
                counterSection(repeatCount: repeatCount)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            isFavorite = adhkar.isFavorite
        }
    }
    
    private var sourceInfo: some View {
        VStack(alignment: localizationManager.currentLanguage.isRTL ? .trailing : .leading, spacing: 4) {
            if let source = adhkar.source {
                Text("adhkar_source".localized + ": \(source)")
                    .font(.caption2)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
    }
    
    private var favoriteButton: some View {
        Button(action: { isFavorite.toggle() }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? AppColors.accent : AppColors.textSecondary)
        }
    }
    
    private func counterSection(repeatCount: Int) -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("adhkar_repeat_count".localized + ": \(repeatCount)")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                Spacer()
                Text("adhkar_current_count".localized + ": \(currentCount)")
                    .font(.caption)
                    .foregroundColor(AppColors.primary)
            }
            
            HStack(spacing: 12) {
                Button(action: { 
                    if currentCount > 0 {
                        currentCount -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(AppColors.textSecondary)
                        .font(.title2)
                }
                .disabled(currentCount == 0)
                
                Spacer()
                
                Button(action: { 
                    currentCount += 1
                    // Haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(AppColors.primary)
                        .font(.title2)
                }
                
                Spacer()
                
                Button(action: { 
                    currentCount = 0
                }) {
                    Text("adhkar_reset".localized)
                        .font(.caption)
                        .foregroundColor(AppColors.accent)
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func getAlignment() -> HorizontalAlignment {
        return localizationManager.currentLanguage.isRTL ? .trailing : .leading
    }
    
    private func getTranslation() -> String? {
        switch localizationManager.currentLanguage {
        case .english:
            return adhkar.englishTranslation
        case .french:
            return adhkar.frenchTranslation
        case .urdu:
            return adhkar.urduTranslation
        case .arabic:
            return nil // No translation needed for Arabic
        }
    }
}

#Preview {
    AdhkarView()
} 