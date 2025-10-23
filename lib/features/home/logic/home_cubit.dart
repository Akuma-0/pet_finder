import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_finder/core/networking/api_result.dart';
import 'package:pet_finder/features/home/data/models/breeds_response_model.dart';
import '../data/repos/home_repo.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo _homeRepo;
  HomeCubit(this._homeRepo) : super(const HomeState.initial());

  List<Breed?>? breedsList = [];

  void getBreeds() async {
    emit(const HomeState.loading());
    final response = await _homeRepo.getBreeds();
    response.when(
      success: (breedsList) {
        this.breedsList = breedsList;
        emit(HomeState.success(breedsList));
      },
      failure: (error) {
        emit(HomeState.error(error: error.apiErrorModel.message ?? ''));
      },
    );
  }
}
