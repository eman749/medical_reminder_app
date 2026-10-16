import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';
import '../../models/medication_model.dart';
import '../../services/database_service.dart';
import '../../widgets/language_toggle_button.dart';
import 'add_medication_screen.dart';
import 'med_details_screen.dart';

class MedicationsScreen extends StatefulWidget {
  const MedicationsScreen({super.key});

  @override
  State<MedicationsScreen> createState() => _MedicationsScreenState();
}

class _MedicationsScreenState extends State<MedicationsScreen> {
  String _searchQuery = '';
  int _selectedFilterIndex = 0; // 0: All, 1: Active, 2: Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('my_medications'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: LanguageToggleButton(isCompact: true),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          context.tr('add_med_action'),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: DatabaseService.instance,
        builder: (context, _) {
          final allMeds = DatabaseService.instance.medications;

          // Filter by search and tab
          final filtered = allMeds.where((m) {
            final matchesSearch = m.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase().trim());
            if (!matchesSearch) return false;

            if (_selectedFilterIndex == 1) return m.isActive;
            if (_selectedFilterIndex == 2) return !m.isActive;
            return true;
          }).toList();

          return Column(
            children: [
              // Search Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: context.tr('search_meds'),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppTheme.textSecondary,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),

              // Filter Tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                child: Row(
                  children: [
                    _buildFilterChip(0, context.tr('tab_all')),
                    const SizedBox(width: 8),
                    _buildFilterChip(1, context.tr('tab_active')),
                    const SizedBox(width: 8),
                    _buildFilterChip(2, context.tr('tab_completed')),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Medications List
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medication_outlined,
                              size: 64,
                              color: AppTheme.textMuted,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No medications found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 90,
                          top: 8,
                        ),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final med = filtered[index];
                          return _MedicationItemCard(
                            med: med,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MedDetailsScreen(medication: med),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MedicationItemCard extends StatelessWidget {
  final Medication med;
  final VoidCallback onTap;

  const _MedicationItemCard({
    required this.med,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLowStock = med.isLowStock;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Medication Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(med.colorValue).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    _getFormIcon(med.form),
                    color: Color(med.colorValue),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${med.strength} • ${med.frequency}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(color: AppTheme.borderSubtle, height: 1),
            const SizedBox(height: 12),
            // Bottom pill counter row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remaining pills pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isLowStock
                        ? AppTheme.error.withValues(alpha: 0.1)
                        : AppTheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isLowStock
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 14,
                        color: isLowStock ? AppTheme.error : AppTheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${med.remainingPills} ${context.tr('pills_left')}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isLowStock ? AppTheme.error : AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Times scheduled
                Text(
                  med.times.join(' • '),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFormIcon(MedicationForm form) {
    switch (form) {
      case MedicationForm.tablet:
        return Icons.circle_outlined;
      case MedicationForm.capsule:
        return Icons.medication_rounded;
      case MedicationForm.syrup:
        return Icons.water_drop_outlined;
      case MedicationForm.injection:
        return Icons.vaccines_outlined;
    }
  }
}
