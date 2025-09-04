# Nari Shakti - Women Safety App

A Flutter-based mobile application designed to ensure women's safety with features like emergency alerts, location sharing, and incident reporting.

## Features

### Onboarding Experience
- **Welcome Screen**: Introduction to the app's purpose and mission
- **Emergency Alert**: Information about panic situation handling
- **Location Review**: Details about harassment case reporting and location awareness
- **Share Location**: Emergency location sharing functionality

### Core Safety Features
- **Emergency Alert System**: Quick access to emergency contacts
- **Location Sharing**: Real-time location sharing with trusted contacts
- **Incident Reporting**: Report and track safety incidents
- **SOS Button**: Quick emergency response trigger

## Screenshots

The app features a modern, intuitive design with:
- Clean white background with pink accent colors
- Beautiful illustrations for each feature
- Smooth navigation between onboarding pages
- Modern Material Design 3 components

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator or physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd nari_shakti
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── onboarding_data.dart # Onboarding page data models
├── screens/
│   ├── onboarding_screen.dart # Main onboarding flow
│   └── home_screen.dart      # Home screen after onboarding
└── widgets/
    └── onboarding_page.dart  # Individual onboarding page widget
```

## Dependencies

- **google_fonts**: Custom typography
- **shared_preferences**: Local data persistence
- **permission_handler**: Device permissions management
- **geolocator**: Location services
- **url_launcher**: External app launching
- **flutter_local_notifications**: Local notifications

## Design System

### Colors
- **Primary**: #E91E63 (Pink)
- **Background**: #FFFFFF (White)
- **Text**: #1A1A1A (Dark Gray)
- **Accent**: Various colors for different features

### Typography
- **Font Family**: Poppins (Google Fonts)
- **Headings**: Bold, 28-32px
- **Body Text**: Regular, 16px
- **Captions**: Medium, 14px

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.

---

**Note**: This is a prototype/demo application. For production use, additional security measures, backend integration, and thorough testing are required.
