# 🕌 Adhan - Islamic Prayer Times iOS App

A comprehensive iOS application for Muslims providing accurate prayer times, interactive Qibla direction, and daily supplications (Adhkar).

## ✨ Features

### 📅 Prayer Times (Salat)
- **Accurate Prayer Times**: Uses Umm al-Qura calculation method for maximum accuracy
- **Location-Based**: Automatic location detection with manual location selection
- **Shrouq Time**: Includes sunrise time between Fajr and Dhuhr
- **Live Countdown**: Real-time countdown to next prayer
- **Juristic Methods**: Support for Shafi/Maliki/Hanbali and Hanafi schools
- **Beautiful UI**: Modern design with gradients and animations

### 🧭 Interactive Qibla Compass
- **Real-Time Direction**: Live compass using device magnetometer
- **Visual Feedback**: Color-coded accuracy (Red/Yellow/Green)
- **Haptic Feedback**: Vibration when pointing toward Qibla
- **Accuracy Indicators**: Compass calibration status and numeric displays
- **Distance to Mecca**: Shows exact distance to Kaaba
- **Meaningful Icon**: Building icon representing the Kaaba

### 🌐 Multi-Language Support
- **4 Languages**: English, Arabic (العربية), French (Français), Urdu (اردو)
- **Automatic Detection**: System language detection on first launch
- **RTL Support**: Right-to-left layout for Arabic and Urdu
- **Complete Localization**: All UI elements and instructions translated
- **Language Switching**: Manual language selection with app restart

### 📿 Adhkar (Supplications)
- **Daily Supplications**: Morning, evening, and prayer-specific adhkar
- **Search Functionality**: Easy searching through supplications
- **Clean Display**: Arabic text with translations
- **Interactive Counters**: Tap counters for specific adhkar

### ⚙️ Settings & Customization
- **Notification Settings**: Prayer time alerts and adhan sounds
- **Location Management**: Multiple saved locations
- **App Settings**: Language selection and appearance options
- **Juristic Method Selection**: Choose between different calculation methods

## 🛠 Technical Implementation

### Architecture
- **SwiftUI**: Modern declarative UI framework
- **MVVM Pattern**: Clean separation of concerns
- **CoreLocation**: GPS and compass functionality
- **UserDefaults**: Persistent user preferences

### APIs & Services
- **AlAdhan API**: Accurate prayer time calculations
- **Umm al-Qura Method**: Saudi Arabia's official calculation method
- **Location Services**: Automatic city and coordinates detection

### Key Components
- `SalatView.swift`: Prayer times display and countdown
- `QiblahView.swift`: Interactive compass with real-time feedback
- `AdhkarView.swift`: Supplications browser with search
- `SettingsView.swift`: User preferences and configuration
- `LocalizationManager.swift`: Multi-language support system
- `PrayerTimeAPIManager.swift`: API integration and data management

## 📱 Screenshots

*Screenshots will be added here*

## 🚀 Installation

### Prerequisites
- Xcode 15.0 or later
- iOS 18.1 or later
- macOS Sonoma or later

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/alshehri12/Adhan.git
   cd Adhan
   ```

2. Open the project:
   ```bash
   open Adhan.xcodeproj
   ```

3. Build and run:
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

### Permissions Required
- **Location Services**: For accurate prayer times and Qibla direction
- **Compass Access**: For real-time Qibla compass functionality

## 🎯 Usage

1. **First Launch**: Grant location permissions for accurate prayer times
2. **Prayer Times**: View current and upcoming prayer times with countdown
3. **Qibla Compass**: Use the interactive compass to find Qibla direction
4. **Language**: Change language in Settings (app restart required)
5. **Notifications**: Configure prayer time alerts in Settings

## 🌟 Key Highlights

- ✅ **Zero Build Errors**: Clean, production-ready codebase
- ✅ **Complete Localization**: 4 languages with RTL support
- ✅ **Modern UI/UX**: Beautiful gradients and smooth animations
- ✅ **Accurate Calculations**: Umm al-Qura method for Saudi standards
- ✅ **Real-Time Features**: Live countdown and compass feedback
- ✅ **Robust Error Handling**: Graceful fallbacks and user guidance

## 📂 Project Structure

```
Adhan/
├── Adhan/
│   ├── AdhanApp.swift              # App entry point
│   ├── ContentView.swift           # Main tab view
│   ├── SalatView.swift             # Prayer times view
│   ├── QiblahView.swift            # Compass view
│   ├── AdhkarView.swift            # Supplications view
│   ├── SettingsView.swift          # Settings view
│   ├── Models.swift                # Data models
│   ├── AppColors.swift             # Color scheme
│   ├── LocationManager.swift       # Location services
│   ├── PrayerTimeAPIManager.swift  # API integration
│   ├── LocalizationManager.swift   # Language management
│   ├── UserSettings.swift          # User preferences
│   ├── Localizable.strings         # English strings
│   ├── ar.lproj/                   # Arabic localization
│   ├── fr.lproj/                   # French localization
│   └── ur.lproj/                   # Urdu localization
└── Adhan.xcodeproj/               # Xcode project
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **AlAdhan API**: For providing accurate prayer time calculations
- **Islamic Society of North America (ISNA)**: For calculation method guidelines
- **Umm al-Qura University**: For the official Saudi calculation method
- **Apple Documentation**: For SwiftUI and CoreLocation guidance

## 📧 Contact

**Abdulrahman Alshehri**
- GitHub: [@alshehri12](https://github.com/alshehri12)
- Repository: [https://github.com/alshehri12/Adhan](https://github.com/alshehri12/Adhan)

---

*Built with ❤️ for the Muslim community* 