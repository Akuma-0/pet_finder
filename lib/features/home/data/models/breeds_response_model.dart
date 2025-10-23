import 'package:json_annotation/json_annotation.dart';

part 'breeds_response_model.g.dart';

@JsonSerializable()
class BreedsResponseModel {
  List<Breed>? breeds;

  BreedsResponseModel({this.breeds});

  factory BreedsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BreedsResponseModelFromJson(json);
}

@JsonSerializable()
class Breed {
  Weight? weight;
  String? id;
  String? name;
  @JsonKey(name: 'cfa_url')
  String? cafaUrl;
  @JsonKey(name: 'vetstreet_url')
  String? vetstreetUrl;
  @JsonKey(name: 'vcahospitals_url')
  String? vcahospitalsUrl;
  String? temperament;
  String? origin;
  @JsonKey(name: 'country_codes')
  String? countryCode;
  String? description;
  @JsonKey(name: 'life_span')
  String? lifeSpan;
  int? indoor;
  int? lap;
  @JsonKey(name: 'alt_names')
  String? altNames;
  int? adaptability;
  @JsonKey(name: 'affection_level')
  int? affectionLevel;
  @JsonKey(name: 'child_friendly')
  int? childFriendly;
  @JsonKey(name: 'dog_friendly')
  int? dogFriendly;
  @JsonKey(name: 'energy_level')
  int? energyLevel;
  int? grooming;
  @JsonKey(name: 'health_issues')
  int? healthIssues;
  int? intelligence;
  @JsonKey(name: 'shedding_level')
  int? sheddingLevel;
  @JsonKey(name: 'social_needs')
  int? socialNeeds;
  @JsonKey(name: 'stranger_friendly')
  int? strangerFriendly;
  int? vocalisation;
  int? experimental;
  int? hairless;
  int? natural;
  int? rare;
  int? rex;
  @JsonKey(name: 'suppressed_tail')
  int? suppressedTail;
  @JsonKey(name: 'short_legs')
  int? shortLegs;
  @JsonKey(name: 'wikipedia_url')
  String? wikipediaUrl;
  int? hypoallergenic;
  @JsonKey(name: 'reference_image_id')
  String? referenceImageId;

  Breed({this.id, this.name, this.cafaUrl, this.vetstreetUrl, this.vcahospitalsUrl});

  factory Breed.fromJson(Map<String, dynamic> json) =>
      _$BreedFromJson(json);
  Map<String, dynamic> toJson() => _$BreedToJson(this);
}

@JsonSerializable()
class Weight {
  String? imperial;
  String? metric;

  Weight({this.imperial, this.metric});

  factory Weight.fromJson(Map<String, dynamic> json) => _$WeightFromJson(json);
  Map<String, dynamic> toJson() => _$WeightToJson(this);
}
/*
[
    {
        "weight": {
            "imperial": "7  -  10",
            "metric": "3 - 5"
        },
        "id": "abys",
        "name": "Abyssinian",
        "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
        "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
        "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
        "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
        "origin": "Egypt",
        "country_codes": "EG",
        "country_code": "EG",
        "description": "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
        "life_span": "14 - 15",
        "indoor": 0,
        "lap": 1,
        "alt_names": "",
        "adaptability": 5,
        "affection_level": 5,
        "child_friendly": 3,
        "dog_friendly": 4,
        "energy_level": 5,
        "grooming": 1,
        "health_issues": 2,
        "intelligence": 5,
        "shedding_level": 2,
        "social_needs": 5,
        "stranger_friendly": 5,
        "vocalisation": 1,
        "experimental": 0,
        "hairless": 0,
        "natural": 1,
        "rare": 0,
        "rex": 0,
        "suppressed_tail": 0,
        "short_legs": 0,
        "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
        "hypoallergenic": 0,
        "reference_image_id": "0XYvRd7oD",
        "image": {
            "id": "0XYvRd7oD",
            "width": 1204,
            "height": 1445,
            "url": "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg"
        }
    },
    {
        "weight": {
            "imperial": "7 - 10",
            "metric": "3 - 5"
        },
        "id": "aege",
        "name": "Aegean",
        "vetstreet_url": "http://www.vetstreet.com/cats/aegean-cat",
        "temperament": "Affectionate, Social, Intelligent, Playful, Active",
        "origin": "Greece",
        "country_codes": "GR",
        "country_code": "GR",
        "description": "Native to the Greek islands known as the Cyclades in the Aegean Sea, these are natural cats, meaning they developed without humans getting involved in their breeding. As a breed, Aegean Cats are rare, although they are numerous on their home islands. They are generally friendly toward people and can be excellent cats for families with children.",
        "life_span": "9 - 12",
        "indoor": 0,
        "alt_names": "",
        "adaptability": 5,
        "affection_level": 4,
        "child_friendly": 4,
        "dog_friendly": 4,
        "energy_level": 3,
        "grooming": 3,
        "health_issues": 1,
        "intelligence": 3,
        "shedding_level": 3,
        "social_needs": 4,
        "stranger_friendly": 4,
        "vocalisation": 3,
        "experimental": 0,
        "hairless": 0,
        "natural": 0,
        "rare": 0,
        "rex": 0,
        "suppressed_tail": 0,
        "short_legs": 0,
        "wikipedia_url": "https://en.wikipedia.org/wiki/Aegean_cat",
        "hypoallergenic": 0,
        "reference_image_id": "ozEvzdVM-",
        "image": {
            "id": "ozEvzdVM-",
            "width": 1200,
            "height": 800,
            "url": "https://cdn2.thecatapi.com/images/ozEvzdVM-.jpg"
        }
    }
]
*/