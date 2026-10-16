import 'medication_model.dart';

enum DoseStatus {
  pending,
  taken,
  snoozed,
  skipped,
}

class DoseReminder {
  final String id;
  final String medicationId;
  final String medicationName;
  final String dosage;
  final String time; // e.g. "08:00 AM"
  final String period; // morning, afternoon, evening, night
  final MedicationForm form;
  final DoseStatus status;
  final DateTime? takenAt;
  final int colorValue;

  DoseReminder({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.period,
    this.form = MedicationForm.tablet,
    this.status = DoseStatus.pending,
    this.takenAt,
    this.colorValue = 0xFF165A48,
  });

  bool get isTaken => status == DoseStatus.taken;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'medicationName': medicationName,
      'dosage': dosage,
      'time': time,
      'period': period,
      'form': form.name,
      'status': status.name,
      'takenAt': takenAt?.toIso8601String(),
      'colorValue': colorValue,
    };
  }

  factory DoseReminder.fromMap(Map<String, dynamic> map) {
    return DoseReminder(
      id: map['id'] ?? '',
      medicationId: map['medicationId'] ?? '',
      medicationName: map['medicationName'] ?? '',
      dosage: map['dosage'] ?? '',
      time: map['time'] ?? '',
      period: map['period'] ?? 'morning',
      form: MedicationForm.values.firstWhere(
        (e) => e.name == map['form'],
        orElse: () => MedicationForm.tablet,
      ),
      status: DoseStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => DoseStatus.pending,
      ),
      takenAt: map['takenAt'] != null ? DateTime.tryParse(map['takenAt']) : null,
      colorValue: map['colorValue']?.toInt() ?? 0xFF165A48,
    );
  }

  DoseReminder copyWith({
    String? id,
    String? medicationId,
    String? medicationName,
    String? dosage,
    String? time,
    String? period,
    MedicationForm? form,
    DoseStatus? status,
    DateTime? takenAt,
    int? colorValue,
  }) {
    return DoseReminder(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      period: period ?? this.period,
      form: form ?? this.form,
      status: status ?? this.status,
      takenAt: takenAt ?? this.takenAt,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}
