import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/matching/data/models/match_donor_model.dart';
import 'package:blood_bridge/features/matching/presentation/cubit/match_state.dart';

class MatchCubit extends Cubit<MatchState> {
  MatchCubit() : super(MatchInitial());

  Future<void> getMatchedDonors(int requestId) async {
    emit(MatchLoading());

    try {
      final response = await DioHelper.getData(path: 'Donors/match/$requestId');

      print("📡 Match API Status: ${response.statusCode}");
      print("📦 Full Data: ${response.data}");

      final dynamic dataField = response.data?['data'];

      List<dynamic> rawList = [];

      if (dataField is List) {
        rawList = dataField;
      } else if (dataField is Map<String, dynamic>) {
        // الـ API بيرجع "donors"
        rawList = dataField['donors'] as List<dynamic>? ?? [];

        // في حالة إن كان فيه 'items' في المستقبل
        if (rawList.isEmpty) {
          rawList = dataField['items'] as List<dynamic>? ?? [];
        }
      }

      print("🔍 Found ${rawList.length} donors before parsing");

      final List<MatchDonorModel> matches = rawList
          .map((e) {
            try {
              return MatchDonorModel.fromJson(e as Map<String, dynamic>);
            } catch (parseError) {
              print('❌ Failed to parse donor: $parseError | Data: $e');
              return null;
            }
          })
          .whereType<MatchDonorModel>()
          .toList();

      print("✅ Successfully parsed ${matches.length} donors");

      emit(MatchSuccess(matches));
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data?['message']?.toString() ??
          e.message ??
          'Failed to load matching donors';
      print("❌ Dio Error: $errorMsg");
      emit(MatchError(errorMsg));
    } catch (e) {
      print("❌ Unexpected Error: $e");
      emit(MatchError('Unexpected error: ${e.toString()}'));
    }
  }
}
