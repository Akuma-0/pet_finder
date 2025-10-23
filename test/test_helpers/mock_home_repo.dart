import 'package:mockito/mockito.dart';
import 'package:pet_finder/core/networking/api_result.dart';
import 'package:pet_finder/features/home/data/models/breeds_response_model.dart';
import 'package:pet_finder/features/home/data/repos/home_repo.dart';

class MockHomeRepo extends Mock implements HomeRepo {
  @override
  Future<ApiResult<List<Breed>>> getBreeds() => super.noSuchMethod(
    Invocation.method(#getBreeds, []),
    returnValue: Future.value(ApiResult.success(<Breed>[])),
  );
}
