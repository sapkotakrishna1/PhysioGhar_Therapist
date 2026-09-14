import '../models/therapist.dart';
import '../models/booking.dart';

class MockData {
  MockData._();

  static final Therapist therapist = Therapist(
    name: 'Dr. Krishna Sharma',
    email: 'krishna@physioghar.com',
    phone: '+977 9800000000',
    specialization: 'Orthopedic Physiotherapy',
    experience: '5 Years',
    address: 'Kathmandu, Nepal',
    avatarUrl: '',
  );

  static final List<Booking> bookings = [
    Booking(
      id: '1',
      patientName: 'Sita Sharma',
      treatment: 'Back Pain Treatment',
      dateTime: DateTime(2026, 9, 14, 10, 0),
      location: BookingLocation.homeVisit,
      status: BookingStatus.upcoming,
    ),
    Booking(
      id: '2',
      patientName: 'Ram Thapa',
      treatment: 'Knee Rehabilitation',
      dateTime: DateTime(2026, 9, 14, 14, 0),
      location: BookingLocation.clinic,
      status: BookingStatus.upcoming,
    ),
    Booking(
      id: '3',
      patientName: 'Anita Rai',
      treatment: 'Shoulder Rehabilitation',
      dateTime: DateTime(2026, 9, 16, 11, 0),
      location: BookingLocation.clinic,
      status: BookingStatus.requested,
    ),
  ];
}
