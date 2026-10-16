import 'package:flutter/material.dart';
import '../models/medication_model.dart';
import '../models/dose_reminder_model.dart';
import '../models/user_model.dart';

/// Database Service Layer
/// 
/// This class acts as the single source of truth for the frontend.
/// It currently holds reactive mock data simulating a real database.
/// When you are ready to connect to Firebase, Supabase, or a REST API,
/// you only need to swap the methods inside this file!
class DatabaseService extends ChangeNotifier {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal() {
    _initSampleData();
  }

  UserModel? _currentUser = UserModel(
    id: 'u_1',
    name: 'Sarah Ahmed',
    email: 'sarah.ahmed@example.com',
    dateOfBirth: '1995-04-12',
    phone: '+20 101 234 5678',
    bloodType: 'O+',
    password: 'password123',
  );

  final List<Medication> _medications = [];
  final List<DoseReminder> _todayDoses = [];

  UserModel? get currentUser => _currentUser;
  List<Medication> get medications => List.unmodifiable(_medications);
  List<DoseReminder> get todayDoses => List.unmodifiable(_todayDoses);

  // Statistics
  int get totalDosesToday => _todayDoses.length;
  int get takenDosesToday => _todayDoses.where((d) => d.status == DoseStatus.taken).length;
  double get todayAdherencePercentage =>
      totalDosesToday > 0 ? (takenDosesToday / totalDosesToday) : 0.0;

  void _initSampleData() {
    _medications.addAll([
      Medication(
        id: 'med_1',
        name: 'Panadol Extra',
        form: MedicationForm.tablet,
        strength: '500 mg',
        frequency: 'Twice daily',
        times: ['08:00 AM', '08:00 PM'],
        foodRelation: FoodRelation.afterMeal,
        totalPills: 24,
        remainingPills: 16,
        instructions: 'Take with a full glass of water after food.',
        colorValue: 0xFF165A48,
      ),
      Medication(
        id: 'med_2',
        name: 'Amoxicillin',
        form: MedicationForm.capsule,
        strength: '250 mg',
        frequency: 'Every 8 hours',
        times: ['07:00 AM', '03:00 PM', '11:00 PM'],
        foodRelation: FoodRelation.withMeal,
        totalPills: 30,
        remainingPills: 4, // Low stock demo!
        instructions: 'Complete full course prescribed by Dr. Khaled.',
        colorValue: 0xFF028090,
      ),
      Medication(
        id: 'med_3',
        name: 'Omega 3 Fish Oil',
        form: MedicationForm.capsule,
        strength: '1000 mg',
        frequency: 'Once daily',
        times: ['01:00 PM'],
        foodRelation: FoodRelation.afterMeal,
        totalPills: 60,
        remainingPills: 45,
        instructions: 'Dietary supplement with lunch.',
        colorValue: 0xFFF59E0B,
      ),
      Medication(
        id: 'med_4',
        name: 'Vitamin D3 Drops',
        form: MedicationForm.syrup,
        strength: '400 IU',
        frequency: 'Once daily',
        times: ['09:00 AM'],
        foodRelation: FoodRelation.beforeMeal,
        totalPills: 15,
        remainingPills: 11,
        instructions: '5 drops in the morning.',
        colorValue: 0xFF27AE60,
      ),
    ]);

    _todayDoses.addAll([
      DoseReminder(
        id: 'dose_1',
        medicationId: 'med_2',
        medicationName: 'Amoxicillin',
        dosage: '250 mg (1 Capsule)',
        time: '07:00 AM',
        period: 'morning',
        form: MedicationForm.capsule,
        status: DoseStatus.taken,
        takenAt: DateTime.now().subtract(const Duration(hours: 4)),
        colorValue: 0xFF028090,
      ),
      DoseReminder(
        id: 'dose_2',
        medicationId: 'med_1',
        medicationName: 'Panadol Extra',
        dosage: '500 mg (1 Tablet)',
        time: '08:00 AM',
        period: 'morning',
        form: MedicationForm.tablet,
        status: DoseStatus.taken,
        takenAt: DateTime.now().subtract(const Duration(hours: 3)),
        colorValue: 0xFF165A48,
      ),
      DoseReminder(
        id: 'dose_3',
        medicationId: 'med_4',
        medicationName: 'Vitamin D3 Drops',
        dosage: '5 Drops',
        time: '09:00 AM',
        period: 'morning',
        form: MedicationForm.syrup,
        status: DoseStatus.taken,
        takenAt: DateTime.now().subtract(const Duration(hours: 2)),
        colorValue: 0xFF27AE60,
      ),
      DoseReminder(
        id: 'dose_4',
        medicationId: 'med_3',
        medicationName: 'Omega 3 Fish Oil',
        dosage: '1000 mg (1 Capsule)',
        time: '01:00 PM',
        period: 'afternoon',
        form: MedicationForm.capsule,
        status: DoseStatus.taken,
        colorValue: 0xFFF59E0B,
      ),
      DoseReminder(
        id: 'dose_5',
        medicationId: 'med_1',
        medicationName: 'Panadol Extra',
        dosage: '500 mg (1 Tablet)',
        time: '08:00 PM',
        period: 'evening',
        form: MedicationForm.tablet,
        status: DoseStatus.pending,
        colorValue: 0xFF165A48,
      ),
    ]);
  }

  // --- CRUD Operations Ready For Backend ---

  Future<void> addMedication(Medication med) async {
    // TODO: Connect Firebase Firestore / Supabase / SQLite:
    // await FirebaseFirestore.instance.collection('medications').add(med.toMap());
    _medications.add(med);

    // Also automatically generate today's doses from the times provided
    for (int i = 0; i < med.times.length; i++) {
      final timeStr = med.times[i];
      _todayDoses.add(
        DoseReminder(
          id: 'dose_${DateTime.now().millisecondsSinceEpoch}_$i',
          medicationId: med.id,
          medicationName: med.name,
          dosage: '${med.strength} (${med.form.name})',
          time: timeStr,
          period: _determinePeriod(timeStr),
          form: med.form,
          status: DoseStatus.pending,
          colorValue: med.colorValue,
        ),
      );
    }

    notifyListeners();
  }

  Future<void> updateMedication(Medication updated) async {
    final index = _medications.indexWhere((m) => m.id == updated.id);
    if (index != -1) {
      _medications[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteMedication(String id) async {
    _medications.removeWhere((m) => m.id == id);
    _todayDoses.removeWhere((d) => d.medicationId == id);
    notifyListeners();
  }

  Future<void> updateDoseStatus(String doseId, DoseStatus newStatus) async {
    final index = _todayDoses.indexWhere((d) => d.id == doseId);
    if (index != -1) {
      final current = _todayDoses[index];
      _todayDoses[index] = current.copyWith(
        status: newStatus,
        takenAt: newStatus == DoseStatus.taken ? DateTime.now() : null,
      );

      // If marked taken, optionally decrement remaining pills
      if (newStatus == DoseStatus.taken) {
        final medIdx = _medications.indexWhere((m) => m.id == current.medicationId);
        if (medIdx != -1 && _medications[medIdx].remainingPills > 0) {
          _medications[medIdx] = _medications[medIdx].copyWith(
            remainingPills: _medications[medIdx].remainingPills - 1,
          );
        }
      }

      notifyListeners();
    }
  }

  // Auth Operations Ready For Backend
  Future<bool> login(String email, String password) async {
    // TODO: Connect FirebaseAuth:
    // await FirebaseAuth.instance.signInWithEmailAndPassword(...)
    await Future.delayed(const Duration(milliseconds: 600)); // simulate delay
    _currentUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
    );
    notifyListeners();
    return true;
  }

  Future<bool> signup(String name, String email, String password, String? dob) async {
    // TODO: Connect FirebaseAuth:
    await Future.delayed(const Duration(milliseconds: 600));
    _currentUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      dateOfBirth: dob,
    );
    notifyListeners();
    return true;
  }

  Future<bool> updateUserProfile({
    required String name,
    required String email,
    String? phone,
    String? dateOfBirth,
    String? bloodType,
  }) async {
    if (_currentUser == null) return false;
    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      bloodType: bloodType,
    );
    notifyListeners();
    return true;
  }

  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      return {'success': false, 'error': 'user_not_found'};
    }
    if (_currentUser!.password != null && _currentUser!.password != currentPassword) {
      return {'success': false, 'error': 'current_password_wrong'};
    }
    if (newPassword.length < 6) {
      return {'success': false, 'error': 'password_too_short'};
    }
    _currentUser = _currentUser!.copyWith(password: newPassword);
    notifyListeners();
    return {'success': true};
  }

  Future<void> snoozeDose(String doseId, int snoozeMinutes) async {
    final index = _todayDoses.indexWhere((d) => d.id == doseId);
    if (index != -1) {
      final current = _todayDoses[index];
      // Format current time + snoozeMinutes
      final now = DateTime.now().add(Duration(minutes: snoozeMinutes));
      final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final minute = now.minute.toString().padLeft(2, '0');
      final period = now.hour >= 12 ? 'PM' : 'AM';
      final formattedTime = '${hour.toString().padLeft(2, '0')}:$minute $period';

      _todayDoses[index] = current.copyWith(
        status: DoseStatus.snoozed,
        time: formattedTime,
      );
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  String _determinePeriod(String timeStr) {
    if (timeStr.contains('AM')) {
      final hour = int.tryParse(timeStr.split(':').first) ?? 8;
      if (hour >= 11) return 'afternoon';
      return 'morning';
    } else {
      final hour = int.tryParse(timeStr.split(':').first) ?? 2;
      if (hour < 5 || hour == 12) return 'afternoon';
      if (hour < 9) return 'evening';
      return 'night';
    }
  }
}
