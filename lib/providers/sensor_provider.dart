import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/sensor_data.dart';
import '../core/constants.dart';

class SensorProvider with ChangeNotifier {
  List<SensorReading> _sensorReadings = [];
  bool _isLoading = false;
  String? _error;
  Timer? _updateTimer;

  // Getters
  List<SensorReading> get sensorReadings => _sensorReadings;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // Initialize with dummy data
  SensorProvider() {
    _initializeDummyData();
    _startDataUpdates();
  }

  void _initializeDummyData() {
    _sensorReadings = [
      SensorReading(
        sensorId: 'temp_001',
        sensorName: 'Temperature Sensor',
        sensorType: AppConstants.temperatureSensor,
        currentValue: 23.5,
        previousValue: 22.8,
        unit: AppConstants.temperatureUnit,
        status: SensorStatus.normal,
        history: _generateDummyHistory(23.5, AppConstants.temperatureUnit),
      ),
      SensorReading(
        sensorId: 'hum_001',
        sensorName: 'Humidity Sensor',
        sensorType: AppConstants.humiditySensor,
        currentValue: 65.2,
        previousValue: 63.1,
        unit: AppConstants.humidityUnit,
        status: SensorStatus.normal,
        history: _generateDummyHistory(65.2, AppConstants.humidityUnit),
      ),
      SensorReading(
        sensorId: 'em_001',
        sensorName: 'Electromagnetic Sensor',
        sensorType: AppConstants.electromagneticSensor,
        currentValue: 12.8,
        previousValue: 11.9,
        unit: AppConstants.electromagneticUnit,
        status: SensorStatus.warning,
        history: _generateDummyHistory(12.8, AppConstants.electromagneticUnit),
      ),
      SensorReading(
        sensorId: 'press_001',
        sensorName: 'Pressure Sensor',
        sensorType: AppConstants.pressureSensor,
        currentValue: 1013.25,
        previousValue: 1012.8,
        unit: AppConstants.pressureUnit,
        status: SensorStatus.normal,
        history: _generateDummyHistory(1013.25, AppConstants.pressureUnit),
      ),
      SensorReading(
        sensorId: 'light_001',
        sensorName: 'Light Sensor',
        sensorType: AppConstants.lightSensor,
        currentValue: 450.0,
        previousValue: 420.0,
        unit: AppConstants.lightUnit,
        status: SensorStatus.normal,
        history: _generateDummyHistory(450.0, AppConstants.lightUnit),
      ),
      SensorReading(
        sensorId: 'sound_001',
        sensorName: 'Sound Sensor',
        sensorType: AppConstants.soundSensor,
        currentValue: 45.2,
        previousValue: 44.8,
        unit: AppConstants.soundUnit,
        status: SensorStatus.normal,
        history: _generateDummyHistory(45.2, AppConstants.soundUnit),
      ),
    ];
  }

  List<SensorData> _generateDummyHistory(double currentValue, String unit) {
    final random = Random();
    final List<SensorData> history = [];
    final now = DateTime.now();
    
    for (int i = AppConstants.maxDataPoints - 1; i >= 0; i--) {
      final timestamp = now.subtract(Duration(minutes: i * 2));
      final variation = (random.nextDouble() - 0.5) * 10; // ±5 variation
      final value = (currentValue + variation).clamp(
        _getMinValue(unit),
        _getMaxValue(unit),
      );
      
      history.add(SensorData(
        sensorType: _getSensorTypeFromUnit(unit),
        value: value,
        unit: unit,
        timestamp: timestamp,
      ));
    }
    
    return history;
  }

  double _getMinValue(String unit) {
    switch (unit) {
      case AppConstants.temperatureUnit:
        return AppConstants.temperatureMin;
      case AppConstants.humidityUnit:
        return AppConstants.humidityMin;
      case AppConstants.electromagneticUnit:
        return AppConstants.electromagneticMin;
      default:
        return 0.0;
    }
  }

  double _getMaxValue(String unit) {
    switch (unit) {
      case AppConstants.temperatureUnit:
        return AppConstants.temperatureMax;
      case AppConstants.humidityUnit:
        return AppConstants.humidityMax;
      case AppConstants.electromagneticUnit:
        return AppConstants.electromagneticMax;
      default:
        return 1000.0;
    }
  }

  String _getSensorTypeFromUnit(String unit) {
    switch (unit) {
      case AppConstants.temperatureUnit:
        return AppConstants.temperatureSensor;
      case AppConstants.humidityUnit:
        return AppConstants.humiditySensor;
      case AppConstants.electromagneticUnit:
        return AppConstants.electromagneticSensor;
      case AppConstants.pressureUnit:
        return AppConstants.pressureSensor;
      case AppConstants.lightUnit:
        return AppConstants.lightSensor;
      case AppConstants.soundUnit:
        return AppConstants.soundSensor;
      default:
        return 'unknown';
    }
  }

  void _startDataUpdates() {
    _updateTimer = Timer.periodic(
      Duration(milliseconds: AppConstants.chartUpdateInterval),
      (timer) => _updateSensorData(),
    );
  }

  void _updateSensorData() {
    final random = Random();
    
    for (int i = 0; i < _sensorReadings.length; i++) {
      final reading = _sensorReadings[i];
      final variation = (random.nextDouble() - 0.5) * 2; // ±1 variation
      final newValue = (reading.currentValue + variation).clamp(
        _getMinValue(reading.unit),
        _getMaxValue(reading.unit),
      );
      
      // Update history
      final newHistory = List<SensorData>.from(reading.history);
      newHistory.add(SensorData(
        sensorType: reading.sensorType,
        value: newValue,
        unit: reading.unit,
        timestamp: DateTime.now(),
      ));
      
      // Keep only the last maxDataPoints
      if (newHistory.length > AppConstants.maxDataPoints) {
        newHistory.removeRange(0, newHistory.length - AppConstants.maxDataPoints);
      }
      
      // Update sensor reading
      _sensorReadings[i] = reading.copyWith(
        previousValue: reading.currentValue,
        currentValue: newValue,
        lastUpdated: DateTime.now(),
        history: newHistory,
        status: _determineStatus(newValue, reading.unit),
      );
    }
    
    notifyListeners();
  }

  SensorStatus _determineStatus(double value, String unit) {
    // Simple status determination logic
    if (unit == AppConstants.temperatureUnit) {
      if (value > 30 || value < 10) return SensorStatus.warning;
      if (value > 35 || value < 5) return SensorStatus.critical;
    } else if (unit == AppConstants.humidityUnit) {
      if (value > 80 || value < 20) return SensorStatus.warning;
      if (value > 90 || value < 10) return SensorStatus.critical;
    } else if (unit == AppConstants.electromagneticUnit) {
      if (value > 15) return SensorStatus.warning;
      if (value > 25) return SensorStatus.critical;
    }
    
    return SensorStatus.normal;
  }

  Future<void> refreshData() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      _initializeDummyData();
      notifyListeners();
    } catch (e) {
      _setError(AppConstants.dataError);
    } finally {
      _setLoading(false);
    }
  }

  SensorReading? getSensorReading(String sensorId) {
    try {
      return _sensorReadings.firstWhere((reading) => reading.sensorId == sensorId);
    } catch (e) {
      return null;
    }
  }

  List<SensorReading> getSensorReadingsByType(String sensorType) {
    return _sensorReadings.where((reading) => reading.sensorType == sensorType).toList();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
} 