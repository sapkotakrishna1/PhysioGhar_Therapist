import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/dashboard_model.dart';
import '../models/patient_model.dart';
import '../models/booking_model.dart';
import '../models/schedule_model.dart';

class ApiService {
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web running in Chrome
      return 'http://127.0.0.1:8000';
    }

    // Android Emulator
    return 'http://10.0.2.2:8000';
  }

  Future<DashboardModel> getDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl/dashboard/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return DashboardModel.fromJson(data);
    }

    throw Exception('Failed to load dashboard: ${response.statusCode}');
  }

  Future<List<PatientModel>> getPatients() async {
    final response = await http.get(Uri.parse('$baseUrl/patients/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((patient) => PatientModel.fromJson(patient)).toList();
    }

    throw Exception('Failed to load patients: ${response.statusCode}');
  }

  Future<PatientModel> updatePatient(PatientModel patient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/patients/${patient.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': patient.name,
        'age': patient.age,
        'gender': patient.gender,
        'phone': patient.phone,
        'condition': patient.condition,
        'history': patient.history,
        'notes': patient.notes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return PatientModel.fromJson(data);
    }

    throw Exception('Failed to update patient: ${response.statusCode}');
  }

  Future<List<BookingModel>> getBookings() async {
    final response = await http.get(Uri.parse('$baseUrl/bookings/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((booking) => BookingModel.fromJson(booking)).toList();
    }

    throw Exception('Failed to load bookings: ${response.statusCode}');
  }

  Future<BookingModel> updateBooking(BookingModel booking) async {
    final response = await http.put(
      Uri.parse('$baseUrl/bookings/${booking.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient_id': booking.patientId,
        'patient_name': booking.patientName,
        'therapist_name': booking.therapistName,
        'date': booking.date,
        'time': booking.time,
        'status': booking.status,
        'notes': booking.notes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return BookingModel.fromJson(data);
    }

    throw Exception('Failed to update booking: ${response.statusCode}');
  }

  Future<List<ScheduleModel>> getSchedules() async {
    final response = await http.get(Uri.parse('$baseUrl/schedules/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;

      return data.map((schedule) => ScheduleModel.fromJson(schedule)).toList();
    }

    throw Exception('Failed to load schedules: ${response.statusCode}');
  }

  Future<ScheduleModel> updateSchedule(ScheduleModel schedule) async {
    final response = await http.put(
      Uri.parse('$baseUrl/schedules/${schedule.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': schedule.date,
        'time': schedule.time,
        'status': schedule.status,
        'patient_id': schedule.patientId,
        'patient_name': schedule.patientName,
        'notes': schedule.notes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return ScheduleModel.fromJson(data);
    }

    throw Exception('Failed to update schedule: ${response.statusCode}');
  }

  Future<ScheduleModel> createSchedule(ScheduleModel schedule) async {
    final response = await http.post(
      Uri.parse('$baseUrl/schedules/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': schedule.date,
        'time': schedule.time,
        'status': schedule.status,
        'patient_id': schedule.patientId,
        'patient_name': schedule.patientName,
        'notes': schedule.notes,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return ScheduleModel.fromJson(data);
    }

    throw Exception('Failed to create schedule: ${response.statusCode}');
  }

  Future<void> deleteSchedule(int scheduleId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/schedules/$scheduleId'),
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('Failed to delete schedule: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> getTherapist() async {
    final response = await http.get(Uri.parse('$baseUrl/therapist/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load therapist: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> updateTherapist({
    required String name,
    required String phone,
    required String email,
    required String specialization,
    required int experience,
    required String bio,
    required bool isAvailable,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/therapist/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'phone': phone,
        'email': email,
        'specialization': specialization,
        'experience': experience,
        'bio': bio,
        'is_available': isAvailable,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to update therapist: ${response.statusCode}');
  }
}
