import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../controllers/progress_controller.dart';
import '../models/progress_model.dart';
import 'progress_detail_view.dart';
import 'edit_progress_view.dart';

class ProgressHistoryView extends StatelessWidget {
  const ProgressHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProgressController>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: const Text('Progress History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refreshData,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingHistory.value &&
            controller.progressHistory.value == null) {
          return const Center(child: LoadingIndicator());
        }

        final history = controller.progressHistory.value;
        if (history == null || history.progressEntries.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          children: [
            _buildStatsSummary(controller),
            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshData,
                child: ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: history.progressEntries.length + 1,
                  itemBuilder: (context, index) {
                    if (index == history.progressEntries.length) {
                      return _buildLoadMoreButton(controller, history);
                    }
                    return _buildProgressEntryCard(
                      history.progressEntries[index],
                      controller,
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: AppTheme.textMuted,
          ),
          const SizedBox(height: 16),
          Text(
            'No Progress Entries',
            style: Get.textTheme.titleLarge?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your progress by adding your first entry',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSummary(ProgressController controller) {
    return Container(
      margin: const EdgeInsets.all(24),
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
      child: Obx(() {
        final stats = controller.progressStatistics.value;
        final history = controller.progressHistory.value;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  'Total Entries',
                  stats?.totalEntries.toString() ?? '0',
                  Icons.assessment,
                ),
                _buildStat(
                  'Weight Change',
                  stats != null
                      ? '${stats.weightChange > 0 ? '+' : ''}${stats.weightChange.toStringAsFixed(1)} kg'
                      : '0 kg',
                  stats != null && stats.weightChange < 0
                      ? Icons.trending_down
                      : Icons.trending_up,
                ),
                _buildStat(
                  'Current Page',
                  '${history?.pagination.currentPage ?? 1}/${history?.pagination.totalPages ?? 1}',
                  Icons.pages,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.violetBlue, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressEntryCard(
      ProgressEntry entry, ProgressController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Get.to(() => ProgressDetailView(entry: entry)),
        borderRadius: BorderRadius.circular(16),
        child: Container(
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
                  Text(
                    _formatDate(entry.measurementDate),
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleMenuAction(value, entry, controller),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility),
                            SizedBox(width: 8),
                            Text('View Details'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetric(
                      'Weight',
                      '${entry.weight} kg',
                      Icons.scale,
                    ),
                  ),
                  if (entry.measurements.waist != null)
                    Expanded(
                      child: _buildMetric(
                        'Waist',
                        '${entry.measurements.waist} cm',
                        Icons.straighten,
                      ),
                    ),
                  if (entry.bodyComposition.fatMass != null)
                    Expanded(
                      child: _buildMetric(
                        'Body Fat',
                        '${entry.bodyComposition.fatMass}%',
                        Icons.monitor_weight_outlined,
                      ),
                    ),
                ],
              ),
              if (entry.notes != null && entry.notes!.isNotEmpty) ...[
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
                          entry.notes!,
                          style: Get.textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (entry.images.isNotEmpty) ...[
                const SizedBox(height: 16),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: entry.images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppTheme.violetBlue.withOpacity(0.1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            entry.images[index].url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: AppTheme.textMuted,
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.violetBlue),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Get.textTheme.bodySmall?.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
            Text(
              value,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadMoreButton(
      ProgressController controller, ProgressHistory history) {
    if (!history.pagination.hasNextPage) {
      return const SizedBox(height: 32);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Obx(() => ElevatedButton(
              onPressed: controller.isLoadingHistory.value
                  ? null
                  : controller.loadMoreEntries,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.violetBlue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: controller.isLoadingHistory.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Load More (${history.pagination.totalPages - history.pagination.currentPage} pages left)'),
            )),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _handleMenuAction(
      String action, ProgressEntry entry, ProgressController controller) {
    switch (action) {
      case 'view':
        Get.to(() => ProgressDetailView(entry: entry));
        break;
      case 'edit':
        Get.to(() => EditProgressView(entry: entry));
        break;
      case 'delete':
        _showDeleteConfirmation(entry, controller);
        break;
    }
  }

  void _showDeleteConfirmation(
      ProgressEntry entry, ProgressController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Progress Entry'),
        content: Text(
            'Are you sure you want to delete the progress entry from ${_formatDate(entry.measurementDate)}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.deleteProgressEntry(entry.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
