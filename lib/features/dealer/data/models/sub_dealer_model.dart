import 'package:equatable/equatable.dart';

class SubDealer extends Equatable {
  final String id;
  final String branchName;
  final String location;
  final int technicianCount;
  final double rating;
  final bool isActive;
  final DateTime createdAt;
  final String contactNumber;
  final String managerName;

  const SubDealer({
    required this.id,
    required this.branchName,
    required this.location,
    required this.technicianCount,
    required this.rating,
    required this.isActive,
    required this.createdAt,
    required this.contactNumber,
    required this.managerName,
  });

  factory SubDealer.fromJson(Map<String, dynamic> json) {
    return SubDealer(
      id: json['id'],
      branchName: json['branchName'],
      location: json['location'],
      technicianCount: json['technicianCount'],
      rating: (json['rating'] as num).toDouble(),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      contactNumber: json['contactNumber'],
      managerName: json['managerName'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        branchName,
        location,
        technicianCount,
        rating,
        isActive,
        createdAt,
        contactNumber,
        managerName,
      ];
}
