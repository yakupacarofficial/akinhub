class AppConstants {
  // App Information
  static const String appName = 'Akın HUB';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Sensor Data Dashboard';
  
  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration chartAnimationDuration = Duration(milliseconds: 1500);
  
  // Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
  
  // Chart Configuration
  static const int maxDataPoints = 50;
  static const int chartUpdateInterval = 1000; // milliseconds
  
  // Sensor Types
  static const String temperatureSensor = 'temperature';
  static const String humiditySensor = 'humidity';
  static const String electromagneticSensor = 'electromagnetic';
  static const String pressureSensor = 'pressure';
  static const String lightSensor = 'light';
  static const String soundSensor = 'sound';
  
  // Units
  static const String temperatureUnit = '°C';
  static const String humidityUnit = '%';
  static const String electromagneticUnit = 'μT';
  static const String pressureUnit = 'hPa';
  static const String lightUnit = 'lux';
  static const String soundUnit = 'dB';
  
  // Thresholds
  static const double temperatureMin = -40.0;
  static const double temperatureMax = 80.0;
  static const double humidityMin = 0.0;
  static const double humidityMax = 100.0;
  static const double electromagneticMin = 0.0;
  static const double electromagneticMax = 100.0;
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsKey = 'notifications_enabled';
  
  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.akinhub.com';
  static const String sensorDataEndpoint = '/sensor-data';
  static const String deviceStatusEndpoint = '/device-status';
  
  // Error Messages
  static const String networkError = 'Network connection error';
  static const String dataError = 'Failed to load sensor data';
  static const String deviceError = 'Device connection error';
  static const String unknownError = 'An unknown error occurred';
} 