# PhysioGhar — Therapist App

A Flutter-based prototype mobile application for physiotherapists to manage their daily schedule, bookings, patients, profile information, and complaints.

This project was developed as a technical assignment using Flutter and Riverpod.

## Features

### Dashboard
- Therapist profile/header
- Current date
- Availability Available/Unavailable toggle
- Today's schedule
- Upcoming booking requests
- Summary cards
- Session details
- Empty states

### Schedule & Availability
- Weekly date selection
- OPEN, BOOKED, and BLOCKED slots
- Select a date
- Block/unblock available slots
- Add new time slots
- Availability state changes immediately

### Booking Management
- Requests
- Upcoming
- Completed
- Cancelled
- Accept booking requests
- Decline booking requests
- Reschedule upcoming sessions
- Complete sessions
- Add session remarks
- View completed session details
- Edit completed session remarks

The main booking flow is:

`Request → Accept → Upcoming → Complete → Completed`

### Patients
- Patient list
- Patient details
- Patient history
- Add clinical notes
- Edit clinical notes
- View saved notes

### Therapist Profile
- View therapist information
- Edit:
  - Name
  - Phone
  - Email
  - Experience
  - Specialization
  - Address
- Immediate profile updates
- English/Nepali language example

### Complaints
- Complaint category
- Subject
- Description
- Submit complaint
- Submission confirmation

---

## Technology

### Flutter and Dart

- Flutter: **3.38.5**
- Dart: **3.10.4**
- Channel: **stable**

### Packages

| Package | Version | Purpose |
|---|---:|---|
| flutter_riverpod | ^3.3.2 | State management |
| go_router | ^17.5.0 | Application routing |
| google_fonts | ^8.2.1 | Typography |
| shared_preferences | ^2.5.5 | Local preference/storage support |
| intl | ^0.20.3 | Date and time formatting |
| cupertino_icons | ^1.0.8 | iOS-style icons |
| flutter_lints | ^6.0.0 | Dart/Flutter linting |

---

## How to Run

### 1. Install Flutter

Install Flutter and make sure Flutter is available in your system PATH.

Verify the installation:

```bash
flutter --version