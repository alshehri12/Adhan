//
//  AdhkarView.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI

struct AdhkarView: View {
    @State private var selectedCategory: DhikrCategory = .morning
    @State private var searchText = ""
    @State private var showingFavoritesOnly = false
    
    private let adhkar = Dhikr.sampleAdhkar
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter bar
                searchAndFilterSection
                
                // Category selection
                categorySelector
                
                // Adhkar list
                adhkarList
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
    }
    
    // MARK: - Search and Filter Section
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppColors.textSecondary)
                    
                    TextField("search_adhkar".localized, text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(10)
                
                Button(action: { showingFavoritesOnly.toggle() }) {
                    Image(systemName: showingFavoritesOnly ? "heart.fill" : "heart")
                        .foregroundColor(showingFavoritesOnly ? AppColors.accent : AppColors.textSecondary)
                        .font(.title2)
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    // MARK: - Category Selector
    
    private var categorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DhikrCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
    
    // MARK: - Adhkar List
    
    private var adhkarList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(filteredAdhkar) { dhikr in
                    DhikrCard(dhikr: dhikr)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Computed Properties
    
    private var filteredAdhkar: [Dhikr] {
        adhkar.filter { dhikr in
            let matchesCategory = dhikr.category == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                dhikr.arabic.contains(searchText) ||
                dhikr.transliteration.localizedCaseInsensitiveContains(searchText) ||
                dhikr.translation.localizedCaseInsensitiveContains(searchText)
            let matchesFavorites = !showingFavoritesOnly || dhikr.isFavorite
            
            return matchesCategory && matchesSearch && matchesFavorites
        }
    }
}

// MARK: - Category Button Component

struct CategoryButton: View {
    let category: DhikrCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                isSelected ? AppColors.primary : AppColors.cardBackground
            )
            .foregroundColor(
                isSelected ? .white : AppColors.textPrimary
            )
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Dhikr Card Component

struct DhikrCard: View {
    let dhikr: Dhikr
    @State private var currentCount = 0
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with favorite button
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dhikr.category.rawValue)
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                    
                    if let source = dhikr.source {
                        Text("Source: \(source)")
                            .font(.caption2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
                
                Spacer()
                
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? AppColors.accent : AppColors.textSecondary)
                }
            }
            
            // Arabic text
            Text(dhikr.arabic)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 8)
            
            // Transliteration
            Text(dhikr.transliteration)
                .font(.body)
                .foregroundColor(AppColors.textSecondary)
                .italic()
                .multilineTextAlignment(.leading)
            
            // Translation
            Text(dhikr.translation)
                .font(.body)
                .foregroundColor(AppColors.textPrimary)
                .multilineTextAlignment(.leading)
            
            // Counter section (if applicable)
            if let count = dhikr.count {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("repeat_count".localized + ": \(count) " + "times".localized)
                            .font(.caption)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Text("Current: \(currentCount)")
                            .font(.caption)
                            .foregroundColor(AppColors.primary)
                    }
                    
                    Spacer()
                    
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
                        
                        Button(action: { 
                            currentCount += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(AppColors.primary)
                                .font(.title2)
                        }
                        
                        Button(action: { 
                            currentCount = 0
                        }) {
                            Text("clear".localized)
                                .font(.caption)
                                .foregroundColor(AppColors.accent)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .onAppear {
            isFavorite = dhikr.isFavorite
        }
    }
}

#Preview {
    AdhkarView()
} 