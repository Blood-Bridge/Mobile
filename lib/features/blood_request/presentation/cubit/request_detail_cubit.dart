import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blood_bridge/features/blood_request/domain/repositories/blood_request_repository.dart';
import 'package:blood_bridge/features/blood_request/presentation/cubit/request_detail_state.dart';

/// Loads a single blood request's details and ticks down the
/// "expires in" countdown shown at the bottom of the screen.
class RequestDetailCubit extends Cubit<RequestDetailState> {
  RequestDetailCubit(this._repository) : super(const RequestDetailInitial());

  final BloodRequestRepository _repository;
  Timer? _ticker;

  Future<void> loadRequest(String requestId) async {
    emit(const RequestDetailLoading());
    try {
      final request = await _repository.getRequestDetail(requestId);
      final remaining = request.expiresAt.difference(DateTime.now());
      emit(RequestDetailLoaded(request: request, remaining: remaining));
      _startTicker();
    } catch (e) {
      emit(RequestDetailError('Failed to load request: $e'));
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is! RequestDetailLoaded) return;

      final newRemaining = current.remaining - const Duration(seconds: 1);
      if (newRemaining <= Duration.zero) {
        emit(current.copyWith(remaining: Duration.zero));
        _ticker?.cancel();
      } else {
        emit(current.copyWith(remaining: newRemaining));
      }
    });
  }

  Future<void> accept() => _respond(true);

  Future<void> decline() => _respond(false);

  Future<void> _respond(bool accept) async {
    final current = state;
    if (current is! RequestDetailLoaded || current.isResponding) return;

    emit(current.copyWith(isResponding: true));
    try {
      await _repository.respondToRequest(requestId: current.request.id, accept: accept);
      _ticker?.cancel();
      emit(RequestDetailResponded(accept));
    } catch (e) {
      emit(current.copyWith(isResponding: false));
    }
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
