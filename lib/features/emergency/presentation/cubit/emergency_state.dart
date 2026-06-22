import 'package:equatable/equatable.dart';
import 'package:blood_bridge/features/emergency/domain/entities/emergency_request_entity.dart';

abstract class EmergencyState extends Equatable {
  const EmergencyState();

  @override
  List<Object?> get props => [];
}

/// Blood-type selection screen state. Holds the currently selected
/// type (nullable until the user picks one) and the fixed location
/// label shown under "Current Location".
class EmergencySelecting extends EmergencyState {
  const EmergencySelecting({this.selectedBloodType, required this.location});

  final String? selectedBloodType;
  final String location;

  EmergencySelecting copyWith({String? selectedBloodType, String? location}) {
    return EmergencySelecting(
      selectedBloodType: selectedBloodType ?? this.selectedBloodType,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [selectedBloodType, location];
}

/// Alert is being sent to the backend.
class EmergencySending extends EmergencyState {
  const EmergencySending();
}

/// Donors are being searched/notified (the "Finding Donors" screen).
class EmergencySearching extends EmergencyState {
  const EmergencySearching(this.request);

  final EmergencyRequestEntity request;

  @override
  List<Object?> get props => [request];
}

/// Request has been sent and donors notified (the "Request Sent" screen).
class EmergencySent extends EmergencyState {
  const EmergencySent(this.request);

  final EmergencyRequestEntity request;

  @override
  List<Object?> get props => [request];
}

class EmergencyError extends EmergencyState {
  const EmergencyError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
