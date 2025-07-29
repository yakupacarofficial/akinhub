# Akın HUB - Sensor Data Dashboard

A clean and scalable Flutter application for displaying real-time sensor data with beautiful charts and metrics. Built with clean architecture principles and modern Flutter development practices.

## 🚀 Features

- **Real-time Sensor Monitoring**: Display temperature, humidity, electromagnetic levels, pressure, light, and sound data
- **Interactive Charts**: Beautiful line charts using `fl_chart` with real-time updates
- **Responsive Design**: Adapts to different screen sizes with a modern, dark-mode UI
- **Clean Architecture**: Modular folder structure with separation of concerns
- **State Management**: Provider pattern for efficient state management
- **Splash Screen**: Animated splash screen with Lottie animations
- **Dashboard Overview**: System summary with active sensors, warnings, and last update time

## 📱 Screenshots

The app features:
- **Splash Screen**: Animated energy flow with app branding
- **Dashboard**: Grid layout of sensor cards with real-time charts
- **Sensor Details**: Expanded view of individual sensor data
- **Top Bar**: Current time, notifications, and settings access

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── constants.dart      # App-wide constants and configuration
│   └── theme.dart          # Theme configuration and color palette
├── models/
│   └── sensor_data.dart    # Data models for sensor readings
├── providers/
│   └── sensor_provider.dart # State management for sensor data
├── views/
│   ├── splash_screen.dart  # Animated splash screen
│   └── dashboard_screen.dart # Main dashboard with sensor grid
├── widgets/
│   ├── chart_card.dart     # Reusable sensor chart widget
│   └── top_bar.dart        # Top bar with time and actions
├── services/               # Future: API services, Bluetooth, etc.
├── utils/
│   └── helpers.dart        # Utility functions
└── main.dart              # App entry point
```

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd akinhub
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Dependencies

The project uses the following key dependencies:

- **fl_chart**: For beautiful, interactive charts
- **provider**: For state management
- **lottie**: For smooth animations
- **intl**: For date/time formatting
- **uuid**: For unique identifiers
- **shared_preferences**: For local storage (future use)
- **http**: For API calls (future use)

## 🎨 Design System

### Color Palette

- **Primary**: Blue (#1E88E5)
- **Secondary**: Teal (#26A69A)
- **Accent**: Orange (#FF9800)
- **Background**: Dark (#121212)
- **Surface**: Dark Gray (#1E1E1E)
- **Card**: Dark Gray (#2D2D2D)

### Typography

- **Headlines**: Bold, large text for titles
- **Body**: Regular text for content
- **Captions**: Small text for metadata

## 📊 Sensor Types

The app supports monitoring of:

1. **Temperature** (°C)
2. **Humidity** (%)
3. **Electromagnetic** (μT)
4. **Pressure** (hPa)
5. **Light** (lux)
6. **Sound** (dB)

## 🔧 Architecture

### Clean Architecture Principles

- **Separation of Concerns**: Each layer has a specific responsibility
- **Dependency Inversion**: High-level modules don't depend on low-level modules
- **Single Responsibility**: Each class has one reason to change
- **Open/Closed**: Open for extension, closed for modification

### State Management

Uses Provider pattern for:
- Sensor data management
- Real-time updates
- Error handling
- Loading states

### Data Flow

1. **Provider** manages sensor data state
2. **Models** define data structures
3. **Widgets** consume and display data
4. **Services** (future) will handle data fetching

## 🚀 Future Enhancements

### Planned Features

- **Bluetooth Connectivity**: Direct sensor connection
- **Wi-Fi Integration**: Remote sensor monitoring
- **Data Export**: CSV/JSON export functionality
- **Alerts & Notifications**: Push notifications for threshold breaches
- **Historical Data**: Long-term data storage and analysis
- **User Authentication**: Multi-user support
- **Settings Screen**: App configuration and preferences
- **Dark/Light Theme Toggle**: User preference support

### Technical Improvements

- **Unit Tests**: Comprehensive test coverage
- **Integration Tests**: End-to-end testing
- **Performance Optimization**: Memory and battery optimization
- **Accessibility**: Screen reader support
- **Internationalization**: Multi-language support

## 📝 Code Quality

### Standards

- **Dart Analysis**: Strict linting rules
- **Code Formatting**: Consistent code style
- **Documentation**: Comprehensive code comments
- **Error Handling**: Graceful error management
- **Performance**: Efficient widget rebuilding

### Best Practices

- **Widget Composition**: Reusable, composable widgets
- **State Management**: Efficient state updates
- **Memory Management**: Proper disposal of resources
- **Responsive Design**: Adaptive layouts
- **Accessibility**: Semantic labels and descriptions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Akın HUB Team**

---

*Built with ❤️ using Flutter*
