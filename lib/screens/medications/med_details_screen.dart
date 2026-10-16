import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';
import '../../models/medication_model.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_button.dart';

class MedDetailsScreen extends StatelessWidget {
  final Medication medication;

  const MedDetailsScreen({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = medication.isLowStock;
    final progress = medication.totalPills > 0
        ? medication.remainingPills / medication.totalPills
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('med_details'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            // Medicine Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Color(medication.colorValue).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Icon(
                      Icons.medication_rounded,
                      color: Color(medication.colorValue),
                      size: 38,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    medication.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${medication.strength} • ${medication.form.name.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Schedule & Details Grid
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    Icons.repeat_rounded,
                    context.tr('frequency_label'),
                    medication.frequency,
                  ),
                  const Divider(color: AppTheme.borderSubtle, height: 24),
                  _buildDetailRow(
                    context,
                    Icons.access_time_rounded,
                    context.tr('first_dose_time'),
                    medication.times.join(', '),
                  ),
                  const Divider(color: AppTheme.borderSubtle, height: 24),
                  _buildDetailRow(
                    context,
                    Icons.restaurant_rounded,
                    context.tr('food_relation'),
                    medication.foodRelation.name,
                  ),
                  if (medication.instructions != null) ...[
                    const Divider(color: AppTheme.borderSubtle, height: 24),
                    _buildDetailRow(
                      context,
                      Icons.description_outlined,
                      context.tr('instruction_label'),
                      medication.instructions!,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Inventory Refill Tracker Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isLowStock ? AppTheme.error.withValues(alpha: 0.3) : AppTheme.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.tr('stock_status'),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${medication.remainingPills} / ${medication.totalPills} ${context.tr('pills_left')}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isLowStock ? AppTheme.error : AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(10),
                    backgroundColor: AppTheme.surfaceMuted,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isLowStock ? AppTheme.error : AppTheme.primary,
                    ),
                  ),
                  if (isLowStock) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppTheme.error,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.tr('low_stock_warning'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 36),

            // Delete Medication Button
            CustomButton(
              text: context.tr('delete'),
              isOutlined: true,
              textColor: AppTheme.error,
              icon: Icons.delete_outline_rounded,
              onPressed: () {
                _showDeleteDialog(context);
              },
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('delete')),
        content: Text(context.tr('delete_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              DatabaseService.instance.deleteMedication(medication.id);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Close details
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: Text(context.tr('delete')),
          ),
        ],
      ),
    );
  }
}
