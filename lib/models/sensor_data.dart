import 'package:uuid/uuid.dart';

class SensorData {
  final String id;
  final String sensorType;
  final double value;
  final String unit;
  final DateTime timestamp;
  final String? location;
  final Map<String, dynamic>? metadata;

  SensorData({
    String? id,
    required this.sensorType,
    required this.value,
    required this.unit,
    DateTime? timestamp,
    this.location,
    this.metadata,
  }) : 
    id = id ?? const Uuid().v4(),
    timestamp = timestamp ?? DateTime.now();

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      id: json['id'],
      sensorType: json['sensorType'],
      value: json['value'].toDouble(),
      unit: json['unit'],
      timestamp: DateTime.parse(json['timestamp']),
      location: json['location'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sensorType': sensorType,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'metadata': metadata,
    };
  }

  SensorData copyWith({
    String? id,
    String? sensorType,
    double? value,
    String? unit,
    DateTime? timestamp,
    String? location,
    Map<String, dynamic>? metadata,
  }) {
    return SensorData(
      id: id ?? this.id,
      sensorType: sensorType ?? this.sensorType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      timestamp: timestamp ?? this.timestamp,
      location: location ?? this.location,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'SensorData(id: $id, sensorType: $sensorType, value: $value, unit: $unit, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SensorData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class SensorReading {
  final String sensorId;
  final String sensorName;
  final String sensorType;
  final double currentValue;
  final double? previousValue;
  final String unit;
  final DateTime lastUpdated;
  final SensorStatus status;
  final List<SensorData> history;

  SensorReading({
    required this.sensorId,
    required this.sensorName,
    required this.sensorType,
    required this.currentValue,
    this.previousValue,
    required this.unit,
    DateTime? lastUpdated,
    this.status = SensorStatus.normal,
    List<SensorData>? history,
  }) : 
    lastUpdated = lastUpdated ?? DateTime.now(),
    history = history ?? [];

  double get changePercentage {
    if (previousValue == null || previousValue == 0) return 0.0;
    return ((currentValue - previousValue!) / previousValue!) * 100;
  }

  bool get isIncreasing => changePercentage > 0;
  bool get isDecreasing => changePercentage < 0;
  bool get isStable => changePercentage == 0;

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      sensorId: json['sensorId'],
      sensorName: json['sensorName'],
      sensorType: json['sensorType'],
      currentValue: json['currentValue'].toDouble(),
      previousValue: json['previousValue']?.toDouble(),
      unit: json['unit'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      status: SensorStatus.values.firstWhere(
        (e) => e.toString() == 'SensorStatus.${json['status']}',
        orElse: () => SensorStatus.normal,
      ),
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => SensorData.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'sensorName': sensorName,
      'sensorType': sensorType,
      'currentValue': currentValue,
      'previousValue': previousValue,
      'unit': unit,
      'lastUpdated': lastUpdated.toIso8601String(),
      'status': status.toString().split('.').last,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }

  SensorReading copyWith({
    String? sensorId,
    String? sensorName,
    String? sensorType,
    double? currentValue,
    double? previousValue,
    String? unit,
    DateTime? lastUpdated,
    SensorStatus? status,
    List<SensorData>? history,
  }) {
    return SensorReading(
      sensorId: sensorId ?? this.sensorId,
      sensorName: sensorName ?? this.sensorName,
      sensorType: sensorType ?? this.sensorType,
      currentValue: currentValue ?? this.currentValue,
      previousValue: previousValue ?? this.previousValue,
      unit: unit ?? this.unit,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
      history: history ?? this.history,
    );
  }
}

enum SensorStatus {
  normal,
  warning,
  critical,
  offline,
  error,
}

extension SensorStatusExtension on SensorStatus {
  String get displayName {
    switch (this) {
      case SensorStatus.normal:
        return 'Normal';
      case SensorStatus.warning:
        return 'Warning';
      case SensorStatus.critical:
        return 'Critical';
      case SensorStatus.offline:
        return 'Offline';
      case SensorStatus.error:
        return 'Error';
    }
  }
} 