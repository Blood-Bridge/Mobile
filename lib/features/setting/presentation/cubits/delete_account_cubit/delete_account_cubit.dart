import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:blood_bridge/core/services/dio_helper.dart';
import 'package:blood_bridge/features/setting/presentation/cubits/delete_account_cubit/delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      final response = await DioHelper.deleteData(path: 'Users/delete-account');

      if (response.statusCode == 200) {
        emit(DeleteAccountSuccess());
      } else {
        emit(DeleteAccountError(response.data['message'] ?? 'Failed to delete account'));
      }
    } on DioException catch (e) {
      emit(DeleteAccountError(
        e.response?.data?['message'] ?? 'Failed to delete account. Make sure you have no active requests.',
      ));
    } catch (_) {
      emit(const DeleteAccountError('Unexpected error occurred'));
    }
  }
}
