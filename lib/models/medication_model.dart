enum MedicationForm {
  tablet,
  capsule,
  syrup,
  injection,
}

enum FoodRelation {
  beforeMeal,
  withMeal,
  afterMeal,
  noRelation,
}

class Medication {
  final String id;
  final String name;
  final MedicationForm form;
  final String strength;
  final String frequency;
  final List<String> times;
  final FoodRelation foodRelation;
  final int totalPills;
  final int remainingPills;
  final String? instructions;
  final int colorValue; // ARGB color
  final bool isActive;

  Medication({
    required this.id,
    required this.name,
    required this.form,
    required this.strength,
    required this.frequency,
    required this.times,
    required this.foodRelation,
    required this.totalPills,
    required this.remainingPills,
    this.instructions,
    this.colorValue = 0xFF165A48,
    this.isActive = true,
  });

  bool get isLowStock => remainingPills <= 5;
  double get adherenceProgress => totalPills > 0 ? (totalPills - remainingPills) / totalPills : 0.0;

  // Ready for Database / API serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'form': form.name,
      'strength': strength,
      'frequency': frequency,
      'times': times,
      'foodRelation': foodRelation.name,
      'totalPills': totalPills,
      'remainingPills': remainingPills,
      'instructions': instructions,
      'colorValue': colorValue,
      'isActive': isActive,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      form: MedicationForm.values.firstWhere(
        (e) => e.name == map['form'],
        orElse: () => MedicationForm.tablet,
      ),
      strength: map['strength'] ?? '',
      frequency: map['frequency'] ?? '',
      times: List<String>.from(map['times'] ?? []),
      foodRelation: FoodRelation.values.firstWhere(
        (e) => e.name == map['foodRelation'],
        orElse: () => FoodRelation.afterMeal,
      ),
      totalPills: map['totalPills']?.toInt() ?? 0,
      remainingPills: map['remainingPills']?.toInt() ?? 0,
      instructions: map['instructions'],
      colorValue: map['colorValue']?.toInt() ?? 0xFF165A48,
      isActive: map['isActive'] ?? true,
    );
  }

  Medication copyWith({
    String? id,
    String? name,
    MedicationForm? form,
    String? strength,
    String? frequency,
    List<String>? times,
    FoodRelation? foodRelation,
    int? totalPills,
    int? remainingPills,
    String? instructions,
    int? colorValue,
    bool? isActive,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      form: form ?? this.form,
      strength: strength ?? this.strength,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      foodRelation: foodRelation ?? this.foodRelation,
      totalPills: totalPills ?? this.totalPills,
      remainingPills: remainingPills ?? this.remainingPills,
      instructions: instructions ?? this.instructions,
      colorValue: colorValue ?? this.colorValue,
      isActive: isActive ?? this.isActive,
    );
  }
}
