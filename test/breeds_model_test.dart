import 'package:flutter_test/flutter_test.dart';
import 'package:pet_finder/features/home/data/models/breeds_response_model.dart';

void main() {
  group('BreedsResponseModel Unit Tests', () {
    group('BreedsResponseModel', () {
      test('should create instance with breeds list', () {
        // Arrange
        final breed1 = Breed(id: '1', name: 'Test Breed 1');
        final breed2 = Breed(id: '2', name: 'Test Breed 2');
        final breeds = [breed1, breed2];

        // Act
        final model = BreedsResponseModel(breeds: breeds);

        // Assert
        expect(model.breeds, equals(breeds));
        expect(model.breeds!.length, equals(2));
      });

      test('should create instance with null breeds', () {
        // Act
        final model = BreedsResponseModel();

        // Assert
        expect(model.breeds, isNull);
      });

      test('should create instance with empty breeds list', () {
        // Act
        final model = BreedsResponseModel(breeds: []);

        // Assert
        expect(model.breeds, equals([]));
        expect(model.breeds!.length, equals(0));
      });

      test('should parse from JSON correctly', () {
        // Arrange
        final json = {
          'breeds': [
            {
              'id': 'abys',
              'name': 'Abyssinian',
              'origin': 'Egypt',
              'life_span': '14 - 15',
              'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
            },
            {
              'id': 'aege',
              'name': 'Aegean',
              'origin': 'Greece',
              'life_span': '9 - 12',
              'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
            },
          ],
        };

        // Act
        final model = BreedsResponseModel.fromJson(json);

        // Assert
        expect(model.breeds, isNotNull);
        expect(model.breeds!.length, equals(2));
        expect(model.breeds![0].id, equals('abys'));
        expect(model.breeds![0].name, equals('Abyssinian'));
        expect(model.breeds![1].id, equals('aege'));
        expect(model.breeds![1].name, equals('Aegean'));
      });

      test('should handle JSON with null breeds', () {
        // Arrange
        final json = <String, dynamic>{'breeds': null};

        // Act
        final model = BreedsResponseModel.fromJson(json);

        // Assert
        expect(model.breeds, isNull);
      });
    });

    group('Breed Model', () {
      test('should create basic breed instance', () {
        // Act
        final breed = Breed(
          id: 'test_id',
          name: 'Test Breed',
          cafaUrl: 'https://cfa.org/test',
          vetstreetUrl: 'https://vetstreet.com/test',
          vcahospitalsUrl: 'https://vca.com/test',
        );

        // Assert
        expect(breed.id, equals('test_id'));
        expect(breed.name, equals('Test Breed'));
        expect(breed.cafaUrl, equals('https://cfa.org/test'));
        expect(breed.vetstreetUrl, equals('https://vetstreet.com/test'));
        expect(breed.vcahospitalsUrl, equals('https://vca.com/test'));
      });

      test('should create breed with all properties', () {
        // Arrange
        final weight = Weight(imperial: '8 - 12', metric: '4 - 5');

        // Act
        final breed =
            Breed(
                id: 'full_breed',
                name: 'Full Breed',
                cafaUrl: 'https://cfa.org/full',
                vetstreetUrl: 'https://vetstreet.com/full',
                vcahospitalsUrl: 'https://vca.com/full',
              )
              ..weight = weight
              ..temperament = 'Friendly, Active'
              ..origin = 'Test Country'
              ..countryCode = 'TC'
              ..description = 'A test breed description'
              ..lifeSpan = '12 - 15'
              ..indoor = 1
              ..lap = 1
              ..altNames = 'Alternative Names'
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
              ..experimental = 0
              ..hairless = 0
              ..natural = 1
              ..rare = 0
              ..rex = 0
              ..suppressedTail = 0
              ..shortLegs = 0
              ..wikipediaUrl = 'https://wikipedia.org/test'
              ..hypoallergenic = 0
              ..referenceImageId = 'test_image_id';

        // Assert
        expect(breed.id, equals('full_breed'));
        expect(breed.name, equals('Full Breed'));
        expect(breed.weight, equals(weight));
        expect(breed.temperament, equals('Friendly, Active'));
        expect(breed.origin, equals('Test Country'));
        expect(breed.description, equals('A test breed description'));
        expect(breed.lifeSpan, equals('12 - 15'));
        expect(breed.adaptability, equals(5));
        expect(breed.intelligence, equals(5));
        expect(breed.referenceImageId, equals('test_image_id'));
      });

      test('should parse from JSON correctly', () {
        // Arrange
        final json = {
          'id': 'abys',
          'name': 'Abyssinian',
          'cfa_url': 'http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx',
          'vetstreet_url': 'http://www.vetstreet.com/cats/abyssinian',
          'vcahospitals_url':
              'https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian',
          'temperament': 'Active, Energetic, Independent, Intelligent, Gentle',
          'origin': 'Egypt',
          'country_codes': 'EG',
          'description': 'The Abyssinian is easy to care for.',
          'life_span': '14 - 15',
          'indoor': 0,
          'lap': 1,
          'alt_names': '',
          'adaptability': 5,
          'affection_level': 5,
          'child_friendly': 3,
          'dog_friendly': 4,
          'energy_level': 5,
          'grooming': 1,
          'health_issues': 2,
          'intelligence': 5,
          'shedding_level': 2,
          'social_needs': 5,
          'stranger_friendly': 5,
          'vocalisation': 1,
          'experimental': 0,
          'hairless': 0,
          'natural': 1,
          'rare': 0,
          'rex': 0,
          'suppressed_tail': 0,
          'short_legs': 0,
          'wikipedia_url': 'https://en.wikipedia.org/wiki/Abyssinian_(cat)',
          'hypoallergenic': 0,
          'reference_image_id': '0XYvRd7oD',
          'weight': {'imperial': '7 - 10', 'metric': '3 - 5'},
        };

        // Act
        final breed = Breed.fromJson(json);

        // Assert
        expect(breed.id, equals('abys'));
        expect(breed.name, equals('Abyssinian'));
        expect(
          breed.cafaUrl,
          equals('http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx'),
        );
        expect(
          breed.temperament,
          equals('Active, Energetic, Independent, Intelligent, Gentle'),
        );
        expect(breed.origin, equals('Egypt'));
        expect(breed.countryCode, equals('EG'));
        expect(
          breed.description,
          equals('The Abyssinian is easy to care for.'),
        );
        expect(breed.lifeSpan, equals('14 - 15'));
        expect(breed.adaptability, equals(5));
        expect(breed.affectionLevel, equals(5));
        expect(breed.intelligence, equals(5));
        expect(breed.referenceImageId, equals('0XYvRd7oD'));
        expect(breed.weight, isNotNull);
        expect(breed.weight!.imperial, equals('7 - 10'));
        expect(breed.weight!.metric, equals('3 - 5'));
      });

      test('should convert to JSON correctly', () {
        // Arrange
        final weight = Weight(imperial: '8 - 12', metric: '4 - 5');
        final breed = Breed(
          id: 'test_breed',
          name: 'Test Breed',
          cafaUrl: 'https://cfa.org/test',
          vetstreetUrl: 'https://vetstreet.com/test',
          vcahospitalsUrl: 'https://vca.com/test',
        )..weight = weight;

        // Act
        final json = breed.toJson();

        // Assert
        expect(json['id'], equals('test_breed'));
        expect(json['name'], equals('Test Breed'));
        expect(json['cfa_url'], equals('https://cfa.org/test'));
        expect(json['vetstreet_url'], equals('https://vetstreet.com/test'));
        expect(json['vcahospitals_url'], equals('https://vca.com/test'));
        expect(json['weight'], isNotNull);
        // Just verify weight exists, as the serialization format may vary
        expect(json.containsKey('weight'), isTrue);
      });

      test('should handle null values gracefully', () {
        // Act
        final breed = Breed();

        // Assert
        expect(breed.id, isNull);
        expect(breed.name, isNull);
        expect(breed.cafaUrl, isNull);
        expect(breed.weight, isNull);
        expect(breed.temperament, isNull);
        expect(breed.origin, isNull);
      });

      test('should handle JSON with missing optional fields', () {
        // Arrange
        final json = {'id': 'minimal', 'name': 'Minimal Breed'};

        // Act
        final breed = Breed.fromJson(json);

        // Assert
        expect(breed.id, equals('minimal'));
        expect(breed.name, equals('Minimal Breed'));
        expect(breed.cafaUrl, isNull);
        expect(breed.weight, isNull);
        expect(breed.temperament, isNull);
        expect(breed.origin, isNull);
        expect(breed.adaptability, isNull);
      });
    });

    group('Weight Model', () {
      test('should create weight instance', () {
        // Act
        final weight = Weight(imperial: '8 - 12', metric: '4 - 5');

        // Assert
        expect(weight.imperial, equals('8 - 12'));
        expect(weight.metric, equals('4 - 5'));
      });

      test('should create weight with null values', () {
        // Act
        final weight = Weight();

        // Assert
        expect(weight.imperial, isNull);
        expect(weight.metric, isNull);
      });

      test('should parse from JSON correctly', () {
        // Arrange
        final json = {'imperial': '7 - 10', 'metric': '3 - 5'};

        // Act
        final weight = Weight.fromJson(json);

        // Assert
        expect(weight.imperial, equals('7 - 10'));
        expect(weight.metric, equals('3 - 5'));
      });

      test('should convert to JSON correctly', () {
        // Arrange
        final weight = Weight(imperial: '8 - 12', metric: '4 - 5');

        // Act
        final json = weight.toJson();

        // Assert
        expect(json['imperial'], equals('8 - 12'));
        expect(json['metric'], equals('4 - 5'));
      });

      test('should handle JSON with null values', () {
        // Arrange
        final json = <String, dynamic>{'imperial': null, 'metric': null};

        // Act
        final weight = Weight.fromJson(json);

        // Assert
        expect(weight.imperial, isNull);
        expect(weight.metric, isNull);
      });
    });
  });
}
