import 'package:pet_finder/features/home/data/models/breeds_response_model.dart';

/// Test data factory for creating mock Breed objects for testing
class TestDataFactory {
  /// Create a sample breed for testing
  static Breed createBreed({
    String? id,
    String? name,
    String? origin,
    String? lifeSpan,
    String? temperament,
    String? description,
    Weight? weight,
    String? referenceImageId,
  }) {
    return Breed(
        id: id ?? 'test_breed_id',
        name: name ?? 'Test Breed',
        cafaUrl: 'https://test.com/cfa',
        vetstreetUrl: 'https://test.com/vetstreet',
        vcahospitalsUrl: 'https://test.com/vca',
      )
      ..origin = origin ?? 'Test Origin'
      ..lifeSpan = lifeSpan
      ..temperament = temperament ?? 'Friendly, Active'
      ..description = description ?? 'Test breed description'
      ..weight = weight ?? createWeight()
      ..referenceImageId = referenceImageId ?? 'test_image_id'
      ..adaptability = 5
      ..affectionLevel = 4
      ..childFriendly = 3
      ..dogFriendly = 4
      ..energyLevel = 3
      ..grooming = 2
      ..healthIssues = 1
      ..intelligence = 5
      ..sheddingLevel = 2
      ..socialNeeds = 4
      ..strangerFriendly = 3
      ..vocalisation = 2
      ..indoor = 1
      ..lap = 1;
  }

  /// Create a sample weight for testing
  static Weight createWeight({String? imperial, String? metric}) {
    return Weight(imperial: imperial ?? '8 - 12', metric: metric ?? '4 - 5');
  }

  /// Create a list of sample breeds for testing
  static List<Breed> createBreedsList({int count = 3}) {
    return List.generate(count, (index) {
      return createBreed(
        id: 'breed_$index',
        name: 'Breed $index',
        origin: 'Origin $index',
        lifeSpan: '${10 + index} - ${15 + index}',
        temperament: 'Temperament $index',
        description: 'Description for breed $index',
        referenceImageId: 'image_id_$index',
      );
    });
  }

  /// Create an empty breeds list
  static List<Breed> createEmptyBreedsList() {
    return <Breed>[];
  }

  /// Create a breed with minimal data
  static Breed createMinimalBreed() {
    return Breed(id: 'minimal_breed', name: 'Minimal Breed');
  }

  /// Create a breed with null weight
  static Breed createBreedWithNullWeight() {
    return Breed(id: 'null_weight_breed', name: 'Null Weight Breed')
      ..origin = 'Unknown'
      ..lifeSpan = 'Unknown'
      ..weight = null;
  }
}
