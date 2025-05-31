//
//  QiblahView.swift
//  Adhan
//
//  Created by Abdulrahman Alshehri on 03/12/1446 AH.
//

import SwiftUI
import CoreLocation

// MARK: - Qibla ViewModel

class QiblaViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentHeading: Double = 0
    @Published var qiblaDirection: Double = 0
    @Published var accuracyColor: Color = .red
    @Published var compassAccuracy: String = "Calibrating..."
    @Published var headingAccuracy: CLLocationDirection = -1
    @Published var showCalibrationAlert: Bool = false
    @Published var isHeadingAvailable: Bool = false
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocation?
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request permissions
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingHeading()
            isHeadingAvailable = true
        }
        
        // Get current location if available
        if let location = LocationManager.shared.location {
            userLocation = location
            calculateQiblaDirection()
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            // Use true heading if available, otherwise magnetic heading
            let heading = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
            
            self.currentHeading = heading
            self.headingAccuracy = newHeading.headingAccuracy
            
            self.updateCompassAccuracy(accuracy: newHeading.headingAccuracy)
            self.updateAccuracyColor()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    // MARK: - Calculations
    
    func updateLocation(_ location: CLLocation) {
        userLocation = location
        calculateQiblaDirection()
    }
    
    private func calculateQiblaDirection() {
        guard let userLocation = userLocation else { return }
        
        let userLat = userLocation.coordinate.latitude * .pi / 180
        let userLng = userLocation.coordinate.longitude * .pi / 180
        let meccaLat = 21.4225 * .pi / 180
        let meccaLng = 39.8262 * .pi / 180
        
        let dLng = meccaLng - userLng
        
        let y = sin(dLng) * cos(meccaLat)
        let x = cos(userLat) * sin(meccaLat) - sin(userLat) * cos(meccaLat) * cos(dLng)
        
        var bearing = atan2(y, x)
        bearing = bearing * 180 / .pi
        bearing = (bearing + 360).truncatingRemainder(dividingBy: 360)
        
        qiblaDirection = bearing
        updateAccuracyColor()
    }
    
    private func updateAccuracyColor() {
        let difference = abs(angleDifference(currentHeading, qiblaDirection))
        
        if difference <= 3 {
            accuracyColor = .green
            // Trigger haptic feedback when reaching green zone
            triggerHapticFeedback()
        } else if difference <= 10 {
            accuracyColor = .yellow
        } else {
            accuracyColor = .red
        }
    }
    
    private func updateCompassAccuracy(accuracy: CLLocationDirection) {
        if accuracy < 0 {
            compassAccuracy = "Calibrating..."
            showCalibrationAlert = false
        } else if accuracy <= 5 {
            compassAccuracy = "Excellent"
            showCalibrationAlert = false
        } else if accuracy <= 15 {
            compassAccuracy = "Good"
            showCalibrationAlert = false
        } else {
            compassAccuracy = "Poor - Calibration needed"
            showCalibrationAlert = true
        }
    }
    
    private func triggerHapticFeedback() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    // Helper function to calculate the smallest angle difference
    private func angleDifference(_ angle1: Double, _ angle2: Double) -> Double {
        let diff = abs(angle1 - angle2)
        return min(diff, 360 - diff)
    }
    
    var headingDifference: Double {
        angleDifference(currentHeading, qiblaDirection)
    }
    
    var distanceToMecca: String {
        guard let userLocation = userLocation else { return "Unknown" }
        
        let meccaLocation = CLLocation(latitude: 21.4225, longitude: 39.8262)
        let distance = userLocation.distance(from: meccaLocation) / 1000 // Convert to km
        
        if distance < 1000 {
            return "\(Int(distance)) km"
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
}

// MARK: - Qiblah View

struct QiblahView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var qiblaViewModel = QiblaViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header with location info
                    locationHeader
                    
                    // Main compass section
                    if qiblaViewModel.isHeadingAvailable {
                        compassSection
                        
                        // Numeric displays
                        numericDisplays
                        
                        // Calibration status
                        calibrationStatus
                    } else {
                        errorStateView
                    }
                    
                    // Enhanced instructions
                    enhancedInstructions
                    
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
            .navigationTitle("qiblah_direction".localized)
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            if let location = locationManager.location {
                qiblaViewModel.updateLocation(location)
            }
        }
        .onChange(of: locationManager.location) { oldValue, newLocation in
            if let location = newLocation {
                qiblaViewModel.updateLocation(location)
            }
        }
        .alert("Compass Calibration", isPresented: $qiblaViewModel.showCalibrationAlert) {
            Button("OK") {
                qiblaViewModel.showCalibrationAlert = false
            }
        } message: {
            Text("Wave your device in a figure-8 pattern to improve compass accuracy.")
        }
    }
    
    // MARK: - Location Header
    
    private var locationHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "location")
                    .foregroundColor(AppColors.accent)
                Text(locationManager.city)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                
                // Distance to Mecca
                Text(qiblaViewModel.distanceToMecca)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(AppColors.cardBackground.opacity(0.2))
                    .cornerRadius(8)
            }
            
            if let location = locationManager.location {
                HStack {
                    Text("Lat: \(location.coordinate.latitude, specifier: "%.4f")")
                    Text("Lng: \(location.coordinate.longitude, specifier: "%.4f")")
                    Spacer()
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(AppColors.cardBackground.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Interactive Compass Section
    
    private var compassSection: some View {
        VStack(spacing: 20) {
            ZStack {
                // Accuracy feedback circle (background)
                Circle()
                    .fill(qiblaViewModel.accuracyColor.opacity(0.2))
                    .frame(width: 320, height: 320)
                    .scaleEffect(qiblaViewModel.accuracyColor == .green ? 1.05 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: qiblaViewModel.accuracyColor)
                
                // Outer compass ring
                Circle()
                    .stroke(AppColors.cardBackground, lineWidth: 4)
                    .frame(width: 280, height: 280)
                
                // Accuracy ring
                Circle()
                    .stroke(qiblaViewModel.accuracyColor, lineWidth: 6)
                    .frame(width: 280, height: 280)
                    .opacity(0.8)
                
                // Compass markings (fixed)
                ForEach(0..<360, id: \.self) { degree in
                    if degree % 30 == 0 {
                        Rectangle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 2, height: degree % 90 == 0 ? 20 : 12)
                            .offset(y: -130)
                            .rotationEffect(.degrees(Double(degree)))
                    }
                }
                
                // Direction labels (fixed)
                VStack {
                    Text("N")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: -120)
                    Spacer()
                    Text("S")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: 120)
                }
                .frame(height: 280)
                
                HStack {
                    Text("W")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: -120)
                    Spacer()
                    Text("E")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(x: 120)
                }
                .frame(width: 280)
                
                // Device direction indicator (thin line pointing up)
                Rectangle()
                    .fill(.white)
                    .frame(width: 3, height: 60)
                    .offset(y: -90)
                    .opacity(0.8)
                
                // Qiblah direction arrow (rotates to point to Qibla)
                VStack {
                    Image(systemName: "location.north.fill")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(AppColors.accent)
                    
                    Text("QIBLA")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.accent)
                }
                .offset(y: -70)
                .rotationEffect(.degrees(qiblaViewModel.qiblaDirection - qiblaViewModel.currentHeading))
                .animation(.easeOut(duration: 0.2), value: qiblaViewModel.currentHeading)
                .animation(.easeOut(duration: 0.2), value: qiblaViewModel.qiblaDirection)
                
                // Center Kaaba icon
                ZStack {
                    Circle()
                        .fill(AppColors.primary)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "building.2.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                }
            }
        }
    }
    
    // MARK: - Numeric Displays
    
    private var numericDisplays: some View {
        HStack(spacing: 16) {
            // Current device heading
            VStack(spacing: 4) {
                Text("qibla_device_heading".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text("\(qiblaViewModel.currentHeading, specifier: "%.0f")°")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.cardBackground.opacity(0.3))
            .cornerRadius(12)
            
            // Target Qibla direction
            VStack(spacing: 4) {
                Text("Qibla")
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text("\(qiblaViewModel.qiblaDirection, specifier: "%.0f")°")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.accent)
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.cardBackground.opacity(0.3))
            .cornerRadius(12)
            
            // Accuracy difference
            VStack(spacing: 4) {
                Text("qibla_off_by".localized)
                    .font(.caption)
                    .foregroundColor(AppColors.textSecondary)
                
                Text("\(qiblaViewModel.headingDifference, specifier: "%.0f")°")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(qiblaViewModel.accuracyColor)
                    .monospacedDigit()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppColors.cardBackground.opacity(0.3))
            .cornerRadius(12)
        }
    }
    
    // MARK: - Calibration Status
    
    private var calibrationStatus: some View {
        HStack {
            Image(systemName: qiblaViewModel.compassAccuracy == "Excellent" ? "checkmark.circle.fill" : 
                  qiblaViewModel.compassAccuracy == "Good" ? "checkmark.circle" : "exclamationmark.triangle.fill")
                .foregroundColor(qiblaViewModel.compassAccuracy == "Excellent" ? .green :
                               qiblaViewModel.compassAccuracy == "Good" ? .yellow : .orange)
            
            Text("Compass: \(qiblaViewModel.compassAccuracy)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(AppColors.cardBackground.opacity(0.3))
        .cornerRadius(8)
    }
    
    // MARK: - Error State
    
    private var errorStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "compass.drawing")
                .font(.system(size: 50))
                .foregroundColor(AppColors.accent)
            
            Text("qibla_compass_not_available".localized)
                .font(.headline)
                .foregroundColor(.white)
            
            Text("qibla_compass_error_message".localized)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
        .background(AppColors.cardBackground.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Enhanced Instructions
    
    private var enhancedInstructions: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(AppColors.primary)
                Text("qibla_how_to_use".localized)
                    .font(.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                instructionRow("🔴", "qibla_instruction_red".localized)
                instructionRow("🟡", "qibla_instruction_yellow".localized)
                instructionRow("🟢", "qibla_instruction_green".localized)
                instructionRow("📱", "qibla_instruction_hold_device".localized)
                instructionRow("🧭", "qibla_instruction_calibrate".localized)
            }
        }
        .padding()
        .background(AppColors.cardBackground)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func instructionRow(_ icon: String, _ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(icon)
                .font(.caption)
                .frame(width: 20, alignment: .leading)
            
            Text(text)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
    }
}

#Preview {
    QiblahView()
} 