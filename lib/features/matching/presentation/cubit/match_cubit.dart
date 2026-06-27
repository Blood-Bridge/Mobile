import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/matching/data/models/match_donor_model.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit() : super(MatchInitial());

  Future<int> getMatchedDonors(int requestId) async {
    emit(MatchLoading());

    try {
      final response = await DioHelper.getData(path: 'Donors/match/$requestId');

      // Debugging
      print("📡 Match API Status: ${response.statusCode}");
      print("📦 Data Type: ${response.data?['data']?.runtimeType}");

      // Safe & Flexible Parsing
      final dynamic dataField = response.data?['data'];
      List<dynamic> rawList = [];

      if (dataField is List) {
        rawList = dataField;
      } else if (dataField is Map<String, dynamic>) {
        rawList = dataField['items'] as List<dynamic>? ?? [];
      }

      final List<MatchDonorModel> matches = rawList
          .map((e) {
            try {
              return MatchDonorModel.fromJson(e as Map<String, dynamic>);
            } catch (parseError) {
              print('❌ Failed to parse donor: $parseError');
              return null;
            }
          })
          .whereType<MatchDonorModel>()
          .toList();

      emit(MatchSuccess(matches));
      return matches.length;
    } on DioException catch (e) {
      emit(
        MatchError(
          e.response?.data?['message']?.toString() ??
              e.message ??
              'Failed to load matching donors',
        ),
      );
      return 0;
    } catch (e) {
      emit(MatchError('Unexpected error: ${e.toString()}'));
      return 0;
    }
  }
}
