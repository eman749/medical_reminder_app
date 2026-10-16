import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../localization/app_strings.dart';
import '../../models/medication_model.dart';
import '../../services/database_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController(text: '500 mg');
  final _quantityController = TextEditingController(text: '30');
  final _instructionsController = TextEditingController();

  MedicationForm _selectedForm = MedicationForm.tablet;
  FoodRelation _selectedFood = FoodRelation.afterMeal;
  String _selectedFrequency = 'Twice daily';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _strengthController.dispose();
    _quantityController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final totalQty = int.tryParse(_quantityController.text) ?? 30;
      final timeFormatted =
          "${_selectedTime.hourOfPeriod.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')} ${_selectedTime.period == DayPeriod.am ? 'AM' : 'PM'}";

      final newMed = Medication(
        id: 'med_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        form: _selectedForm,
        strength: _strengthController.text.trim(),
        frequency: _selectedFrequency,
        times: [timeFormatted],
        foodRelation: _selectedFood,
        totalPills: totalQty,
        remainingPills: totalQty,
        instructions: _instructionsController.text.trim().isNotEmpty
            ? _instructionsController.text.trim()
            : null,
        colorValue: 0xFF165A48,
      );

      await DatabaseService.instance.addMedication(newMed);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('med_added_success')),
            backgroundColor: AppTheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('add_med_title'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Medication Name
              CustomTextField(
                label: context.tr('med_name'),
                hint: context.tr('med_name_hint'),
                controller: _nameController,
                prefixIcon: Icons.medication_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return context.tr('med_name');
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Form / Type Selector
              Text(
                context.tr('form_type'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFormTypeCard(
                    MedicationForm.tablet,
                    context.tr('form_tablet'),
                    Icons.circle_outlined,
                  ),
                  const SizedBox(width: 8),
                  _buildFormTypeCard(
                    MedicationForm.capsule,
                    context.tr('form_capsule'),
                    Icons.medication_rounded,
                  ),
                  const SizedBox(width: 8),
                  _buildFormTypeCard(
                    MedicationForm.syrup,
                    context.tr('form_syrup'),
                    Icons.water_drop_outlined,
                  ),
                  const SizedBox(width: 8),
                  _buildFormTypeCard(
                    MedicationForm.injection,
                    context.tr('form_injection'),
                    Icons.vaccines_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Strength / Dose & Total Quantity Row
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: context.tr('strength'),
                      hint: context.tr('strength_hint'),
                      controller: _strengthController,
                      prefixIcon: Icons.fitness_center_rounded,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: CustomTextField(
                      label: context.tr('total_inventory'),
                      hint: '30',
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icons.inventory_2_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Frequency
              Text(
                context.tr('frequency'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFreqChip('Once daily', context.tr('freq_once')),
                  _buildFreqChip('Twice daily', context.tr('freq_twice')),
                  _buildFreqChip('3 times daily', context.tr('freq_thrice')),
                  _buildFreqChip('As needed', context.tr('freq_needed')),
                ],
              ),

              const SizedBox(height: 20),

              // First Dose Time Picker
              Text(
                context.tr('first_dose_time'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedTime.format(context),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Relation to Food
              Text(
                context.tr('food_relation'),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFoodChip(
                    FoodRelation.beforeMeal,
                    context.tr('food_before'),
                  ),
                  _buildFoodChip(
                    FoodRelation.withMeal,
                    context.tr('food_with'),
                  ),
                  _buildFoodChip(
                    FoodRelation.afterMeal,
                    context.tr('food_after'),
                  ),
                  _buildFoodChip(
                    FoodRelation.noRelation,
                    context.tr('food_none'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Instructions (Optional)
              CustomTextField(
                label: context.tr('instruction_label'),
                hint: 'e.g. Take with a large glass of water',
                controller: _instructionsController,
                maxLines: 2,
                prefixIcon: Icons.note_alt_outlined,
              ),

              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: context.tr('save_med_btn'),
                isLoading: _isLoading,
                onPressed: _saveMedication,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormTypeCard(
    MedicationForm form,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedForm == form;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedForm = form),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : AppTheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.border,
              width: 1.2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : AppTheme.primary,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreqChip(String value, String label) {
    final isSelected = _selectedFrequency == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFrequency = value);
      },
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppTheme.textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primary : AppTheme.border,
        ),
      ),
    );
  }

  Widget _buildFoodChip(FoodRelation rel, String label) {
    final isSelected = _selectedFood == rel;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedFood = rel);
      },
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : AppTheme.textPrimary,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primary : AppTheme.border,
        ),
      ),
    );
  }
}
