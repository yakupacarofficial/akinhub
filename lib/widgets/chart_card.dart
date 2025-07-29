import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import '../models/sensor_data.dart';
import '../utils/helpers.dart';

class ChartCard extends StatelessWidget {
  final SensorReading sensorReading;
  final bool isExpanded;
  final VoidCallback? onTap;

  const ChartCard({
    super.key,
    required this.sensorReading,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            isMobile ? AppConstants.smallPadding : AppConstants.defaultPadding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              SizedBox(height: isMobile ? 1 : AppConstants.smallPadding),
              _buildValueDisplay(context),
              SizedBox(height: isMobile ? 1 : AppConstants.smallPadding),
              Flexible(
                child: _buildChart(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sensorReading.sensorName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: isMobile ? 14 : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isMobile ? 2 : 4),
              Row(
                children: [
                  _buildStatusIndicator(),
                  const SizedBox(width: 8),
                  Text(
                    sensorReading.status.displayName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(
          _getSensorIcon(),
          color: AppTheme.chartColors[0],
          size: 24,
        ),
      ],
    );
  }

  Widget _buildValueDisplay(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final changePercentage = sensorReading.changePercentage;
    final isPositive = changePercentage > 0;
    final isNegative = changePercentage < 0;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sensorReading.currentValue.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                      fontSize: isMobile ? 20 : null,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    sensorReading.unit,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
              if (sensorReading.previousValue != null) ...[
                SizedBox(height: isMobile ? 2 : 4),
                Row(
                  children: [
                    Icon(
                      isPositive
                          ? Icons.trending_up
                          : isNegative
                              ? Icons.trending_down
                              : Icons.trending_flat,
                      size: 16,
                      color: isPositive
                          ? AppTheme.successColor
                          : isNegative
                              ? AppTheme.errorColor
                              : AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${changePercentage.abs().toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isPositive
                            ? AppTheme.successColor
                            : isNegative
                                ? AppTheme.errorColor
                                : AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        Text(
          _formatLastUpdated(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textHintColor,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context) {
    if (sensorReading.history.isEmpty) {
      return const Center(
        child: Text('No data available'),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.textHintColor.withOpacity(0.1),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 30,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        minX: 0,
        maxX: (sensorReading.history.length - 1).toDouble(),
        minY: _getMinY(),
        maxY: _getMaxY(),
        lineBarsData: [
          LineChartBarData(
            spots: _getChartSpots(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.chartColors[0].withOpacity(0.8),
                AppTheme.chartColors[0].withOpacity(0.1),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.chartColors[0].withOpacity(0.3),
                  AppTheme.chartColors[0].withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: _getStatusColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getStatusColor() {
    switch (sensorReading.status) {
      case SensorStatus.normal:
        return AppTheme.successColor;
      case SensorStatus.warning:
        return AppTheme.warningColor;
      case SensorStatus.critical:
        return AppTheme.errorColor;
      case SensorStatus.offline:
        return AppTheme.textHintColor;
      case SensorStatus.error:
        return AppTheme.errorColor;
    }
  }

  IconData _getSensorIcon() {
    switch (sensorReading.sensorType) {
      case AppConstants.temperatureSensor:
        return Icons.thermostat;
      case AppConstants.humiditySensor:
        return Icons.water_drop;
      case AppConstants.electromagneticSensor:
        return Icons.electric_bolt;
      case AppConstants.pressureSensor:
        return Icons.speed;
      case AppConstants.lightSensor:
        return Icons.lightbulb;
      case AppConstants.soundSensor:
        return Icons.volume_up;
      default:
        return Icons.sensors;
    }
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    final difference = now.difference(sensorReading.lastUpdated);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  List<FlSpot> _getChartSpots() {
    return sensorReading.history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
  }

  double _getMinY() {
    if (sensorReading.history.isEmpty) return 0;
    final minValue = sensorReading.history.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    return minValue - (minValue * 0.1);
  }

  double _getMaxY() {
    if (sensorReading.history.isEmpty) return 100;
    final maxValue = sensorReading.history.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return maxValue + (maxValue * 0.1);
  }
} 