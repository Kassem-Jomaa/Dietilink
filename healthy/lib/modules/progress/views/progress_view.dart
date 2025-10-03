import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/progress_controller.dart';
import '../models/progress_model.dart';
import 'add_progress_view.dart';
import 'progress_history_view.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProgressController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: AppTheme.background,
              elevation: 0,
              title: Text(
                'Progress Tracking',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () => Get.to(() => const ProgressHistoryView()),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => Get.to(() => const AddProgressView()),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatisticsSection(controller),
                  const SizedBox(height: 24),
                  _buildLatestProgressCard(controller),
                  const SizedBox(height: 24),
                  _buildWeightProgressChart(controller),
                  const SizedBox(height: 24),
                  _buildMeasurementsOverview(controller),
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddProgressView()),
        backgroundColor: AppTheme.violetBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatisticsSection(ProgressController controller) {
    return Obx(() {
      if (controller.isLoadingStatistics.value) {
        return const SizedBox(
          height: 100,
          child: Center(child: LoadingIndicator()),
        );
      }

      final stats = controller.progressStatistics.value;
      if (stats == null) {
        return const SizedBox(height: 100);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Overview',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Weight Change',
                  '${stats.weightChange > 0 ? '+' : ''}${stats.weightChange.toStringAsFixed(1)} kg',
                  stats.weightChange < 0
                      ? Icons.trending_down
                      : Icons.trending_up,
                  stats.weightChange < 0
                      ? AppTheme.success
                      : AppTheme.warning.withOpacity(0.8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Entries',
                  stats.totalEntries.toString(),
                  Icons.assessment,
                  AppTheme.violetBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Current Weight',
                  '${stats.currentWeight.toStringAsFixed(1)} kg',
                  Icons.scale,
                  AppTheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Waist Change',
                  stats.waistChange != null
                      ? '${stats.waistChange! > 0 ? '+' : ''}${stats.waistChange!.toStringAsFixed(1)} cm'
                      : 'N/A',
                  Icons.straighten,
                  stats.waistChange != null && stats.waistChange! < 0
                      ? AppTheme.success
                      : AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Text(
                value,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Get.textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestProgressCard(ProgressController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 120,
          child: Center(child: LoadingIndicator()),
        );
      }

      final latest = controller.latestProgress.value;
      if (latest == null) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 48,
                color: AppTheme.textMuted,
              ),
              const SizedBox(height: 16),
              Text(
                'No progress entries yet',
                style: Get.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first progress entry to start tracking',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.violetBlue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Latest Progress',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    latest.measurementDate,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem('Weight', '${latest.weight} kg'),
                ),
                if (latest.measurements.waist != null)
                  Expanded(
                    child: _buildProgressItem(
                      'Waist',
                      '${latest.measurements.waist} cm',
                    ),
                  ),
                if (latest.bodyComposition.fatMass != null)
                  Expanded(
                    child: _buildProgressItem(
                      'Body Fat',
                      '${latest.bodyComposition.fatMass}%',
                    ),
                  ),
              ],
            ),
            if (latest.notes != null && latest.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.violetBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note_outlined,
                      size: 16,
                      color: AppTheme.violetBlue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        latest.notes!,
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildProgressItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildWeightProgressChart(ProgressController controller) {
    return Obx(() {
      final history = controller.progressHistory.value;
      if (history == null || history.progressEntries.isEmpty) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              'Not enough data for chart',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.violetBlue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight Progress',
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                _buildWeightChart(history.progressEntries),
              ),
            ),
          ],
        ),
      );
    });
  }

  LineChartData _buildWeightChart(List<ProgressEntry> entries) {
    final spots = entries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppTheme.cardBackground,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value >= 0 && value < entries.length) {
                final date =
                    DateTime.parse(entries[value.toInt()].measurementDate);
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${date.day}/${date.month}',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 12,
                ),
              );
            },
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppTheme.violetBlue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppTheme.violetBlue,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppTheme.violetBlue.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildMeasurementsOverview(ProgressController controller) {
    return Obx(() {
      final latest = controller.latestProgress.value;
      if (latest == null) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.violetBlue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Latest Measurements',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => Get.to(() => const ProgressHistoryView()),
                  child: Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildMeasurementGrid(latest.measurements),
          ],
        ),
      );
    });
  }

  Widget _buildMeasurementGrid(Measurements measurements) {
    final measurementItems = <Map<String, dynamic>>[
      if (measurements.chest != null)
        {
          'label': 'Chest',
          'value': '${measurements.chest} cm',
          'icon': Icons.accessibility
        },
      if (measurements.waist != null)
        {
          'label': 'Waist',
          'value': '${measurements.waist} cm',
          'icon': Icons.straighten
        },
      if (measurements.hips != null)
        {
          'label': 'Hips',
          'value': '${measurements.hips} cm',
          'icon': Icons.straighten
        },
      if (measurements.leftArm != null)
        {
          'label': 'Left Arm',
          'value': '${measurements.leftArm} cm',
          'icon': Icons.fitness_center
        },
      if (measurements.rightArm != null)
        {
          'label': 'Right Arm',
          'value': '${measurements.rightArm} cm',
          'icon': Icons.fitness_center
        },
      if (measurements.leftThigh != null)
        {
          'label': 'Left Thigh',
          'value': '${measurements.leftThigh} cm',
          'icon': Icons.accessibility
        },
    ];

    if (measurementItems.isEmpty) {
      return Center(
        child: Text(
          'No measurements available',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textMuted,
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: measurementItems.length,
      itemBuilder: (context, index) {
        final item = measurementItems[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.violetBlue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                item['icon'],
                size: 16,
                color: AppTheme.violetBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['label'],
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                    Text(
                      item['value'],
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
