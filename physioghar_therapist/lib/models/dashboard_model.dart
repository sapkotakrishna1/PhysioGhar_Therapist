class DashboardModel {
  final int totalPatients;
  final int totalBookings;
  final int openSlots;
  final int completedBookings;
  final int requestedBookings;

  DashboardModel({
    required this.totalPatients,
    required this.totalBookings,
    required this.openSlots,
    required this.completedBookings,
    required this.requestedBookings,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalPatients: json['total_patients'] ?? 0,
      totalBookings: json['total_bookings'] ?? 0,
      openSlots: json['open_slots'] ?? 0,
      completedBookings: json['completed_bookings'] ?? 0,
      requestedBookings: json['requested_bookings'] ?? 0,
    );
  }
}
