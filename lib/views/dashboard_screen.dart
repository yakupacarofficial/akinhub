import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/sensor_provider.dart';
import '../widgets/top_bar.dart';
import '../widgets/chart_card.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize sensor data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            TopBar(
              onNotificationsTap: _showNotifications,
              onSettingsTap: _showSettings,
            ),
            
            // Dashboard Content
            Expanded(
              child: Consumer<SensorProvider>(
                builder: (context, sensorProvider, child) {
                  if (sensorProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (sensorProvider.hasError) {
                    return _buildErrorWidget(sensorProvider.error!);
                  }

                  return _buildDashboardContent(sensorProvider);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<SensorProvider>().refreshData(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDashboardContent(SensorProvider sensorProvider) {
    final sensorReadings = sensorProvider.sensorReadings;

    if (sensorReadings.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => sensorProvider.refreshData(),
      child: CustomScrollView(
        slivers: [
          // Summary Cards
          SliverToBoxAdapter(
            child: _buildSummarySection(sensorReadings),
          ),
          
          // Sensor Charts Grid
          SliverPadding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width < 600 
                ? AppConstants.smallPadding 
                : AppConstants.defaultPadding
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width < 600 ? 0.55 : 0.85,
                crossAxisSpacing: MediaQuery.of(context).size.width < 600 ? 4 : AppConstants.smallPadding,
                mainAxisSpacing: MediaQuery.of(context).size.width < 600 ? 4 : AppConstants.smallPadding,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sensorReading = sensorReadings[index];
                  return ChartCard(
                    sensorReading: sensorReading,
                    onTap: () => _showSensorDetails(sensorReading),
                  );
                },
                childCount: sensorReadings.length,
              ),
            ),
          ),
          
          // Bottom padding - reduced for mobile
          SliverToBoxAdapter(
            child: SizedBox(height: MediaQuery.of(context).size.width < 600 ? 20 : 80),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(List<dynamic> sensorReadings) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      margin: EdgeInsets.all(isMobile ? AppConstants.smallPadding : AppConstants.defaultPadding),
      padding: EdgeInsets.all(isMobile ? AppConstants.smallPadding : AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'System Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Active Sensors',
                  sensorReadings.length.toString(),
                  Icons.sensors,
                  AppTheme.successColor,
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: _buildSummaryCard(
                  'Warnings',
                  sensorReadings
                      .where((s) => s.status.index >= 1)
                      .length
                      .toString(),
                  Icons.warning,
                  AppTheme.warningColor,
                ),
              ),
              const SizedBox(width: AppConstants.smallPadding),
              Expanded(
                child: _buildSummaryCard(
                  'Last Update',
                  _formatLastUpdate(sensorReadings),
                  Icons.access_time,
                  AppTheme.infoColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sensors_off,
            size: 80,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'No Sensors Connected',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Connect your sensors to start monitoring',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: () => context.read<SensorProvider>().refreshData(),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'Error Loading Data',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.largePadding),
          ElevatedButton.icon(
            onPressed: () => context.read<SensorProvider>().refreshData(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  String _formatLastUpdate(List<dynamic> sensorReadings) {
    if (sensorReadings.isEmpty) return 'Never';
    
    final latestUpdate = sensorReadings
        .map((s) => s.lastUpdated)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    
    final now = DateTime.now();
    final difference = now.difference(latestUpdate);
    
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

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSensorDetails(dynamic sensorReading) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.8; // Maximum 80% of screen height
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.cardColor,
      isScrollControlled: true, // Allow scrolling
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        padding: EdgeInsets.all(
          isMobile ? AppConstants.smallPadding : AppConstants.defaultPadding
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textSecondaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: isMobile ? AppConstants.smallPadding : AppConstants.defaultPadding),
              
              // Title
              Text(
                sensorReading.sensorName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isMobile ? 8 : AppConstants.smallPadding),
              
              // Chart Card with fixed height for mobile
              Container(
                height: isMobile ? screenHeight * 0.35 : 200,
                child: ChartCard(
                  sensorReading: sensorReading,
                  isExpanded: true,
                ),
              ),
              
              // Bottom padding
              SizedBox(height: isMobile ? 8 : AppConstants.smallPadding),
            ],
          ),
        ),
      ),
    );
  }
} 