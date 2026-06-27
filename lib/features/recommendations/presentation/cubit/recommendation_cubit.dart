import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/recommendations/data/models/recommendation_model.dart';
import 'package:blood_bridge/features/recommendations/presentation/cubit/recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  RecommendationCubit() : super(RecommendationInitial());

  Future<void> fetchRecommendation() async {
    emit(RecommendationLoading());
    try {
      final response = await DioHelper.getData(path: 'Users/donation-recommendation');
      
      // Parse the recommendation data
      final dataMap = response.data['data'] as Map<String, dynamic>?;
      if (dataMap == null) {
        emit(const RecommendationError('No recommendation data available'));
        return;
      }
      
      final recommendation = RecommendationModel.fromJson(dataMap);
      emit(RecommendationLoaded(recommendation));
    } on DioException catch (e) {
      emit(RecommendationError(
        e.response?.data?['message'] ?? 'Failed to fetch recommendation',
      ));
    } catch (_) {
      emit(const RecommendationError('Unexpected error occurred'));
    }
  }
}
