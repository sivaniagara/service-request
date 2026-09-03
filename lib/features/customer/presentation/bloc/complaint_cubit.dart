import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/complaint_models.dart';
import '../../data/repositories/dashboard_repository_impl.dart';

part 'complaint_state.dart';

class ComplaintCubit extends Cubit<ComplaintState> {
  final DashboardRepository repository;

  ComplaintCubit({required this.repository}) : super(ComplaintInitial());

  Future<void> raiseTicket(RaiseComplaintRequest request) async {
    emit(ComplaintLoading());
    final result = await repository.raiseTicket(request);
    result.fold(
      (failure) => emit(ComplaintFailure(failure.message)),
      (response) => emit(ComplaintSuccess(response)),
    );
  }
}
