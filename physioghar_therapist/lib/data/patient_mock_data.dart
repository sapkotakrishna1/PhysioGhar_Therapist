import '../models/patient.dart';

class PatientMockData {
  PatientMockData._();

  static final List<Patient> patients = [
    Patient(
      id: 'p1',
      name: 'Sita Sharma',
      age: 32,
      gender: 'Female',
      phone: '+977 9811111111',
      condition: 'Lower Back Pain',
      history: [
        'Initial consultation completed',
        'Mobility assessment completed',
      ],
      notes: ['Patient reports pain while sitting for long periods.'],
    ),
    Patient(
      id: 'p2',
      name: 'Ram Thapa',
      age: 45,
      gender: 'Male',
      phone: '+977 9822222222',
      condition: 'Knee Rehabilitation',
      history: ['Knee injury assessment', 'Range-of-motion exercises started'],
      notes: ['Continue gentle strengthening exercises.'],
    ),
    Patient(
      id: 'p3',
      name: 'Anita Rai',
      age: 28,
      gender: 'Female',
      phone: '+977 9833333333',
      condition: 'Shoulder Rehabilitation',
      history: ['Shoulder pain consultation'],
      notes: [],
    ),
  ];
}
