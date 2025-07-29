import 'package:intl/intl.dart';

class Helpers {
  /// Format a number with appropriate decimal places
  static String formatNumber(double value, {int decimalPlaces = 1}) {
    return value.toStringAsFixed(decimalPlaces);
  }

  /// Format a date time to a readable string
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  /// Format a time difference to a readable string
  static String formatTimeDifference(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM dd').format(dateTime);
    }
  }

  /// Get a color based on a value and thresholds
  static String getStatusColor(double value, double warningThreshold, double criticalThreshold) {
    if (value >= criticalThreshold) {
      return 'critical';
    } else if (value >= warningThreshold) {
      return 'warning';
    } else {
      return 'normal';
    }
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Get sensor icon based on sensor type
  static String getSensorIcon(String sensorType) {
    switch (sensorType.toLowerCase()) {
      case 'temperature':
        return 'thermostat';
      case 'humidity':
        return 'water_drop';
      case 'electromagnetic':
        return 'electric_bolt';
      case 'pressure':
        return 'speed';
      case 'light':
        return 'lightbulb';
      case 'sound':
        return 'volume_up';
      default:
        return 'sensors';
    }
  }

  /// Convert sensor type to display name
  static String getSensorDisplayName(String sensorType) {
    switch (sensorType.toLowerCase()) {
      case 'temperature':
        return 'Temperature';
      case 'humidity':
        return 'Humidity';
      case 'electromagnetic':
        return 'Electromagnetic';
      case 'pressure':
        return 'Pressure';
      case 'light':
        return 'Light';
      case 'sound':
        return 'Sound';
      default:
        return capitalizeWords(sensorType);
    }
  }

  /// Get unit for sensor type
  static String getSensorUnit(String sensorType) {
    switch (sensorType.toLowerCase()) {
      case 'temperature':
        return '°C';
      case 'humidity':
        return '%';
      case 'electromagnetic':
        return 'μT';
      case 'pressure':
        return 'hPa';
      case 'light':
        return 'lux';
      case 'sound':
        return 'dB';
      default:
        return '';
    }
  }
} 