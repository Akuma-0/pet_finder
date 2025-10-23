// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breeds_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreedsResponseModel _$BreedsResponseModelFromJson(Map<String, dynamic> json) =>
    BreedsResponseModel(
      breeds: (json['breeds'] as List<dynamic>?)
          ?.map((e) => Breed.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BreedsResponseModelToJson(
  BreedsResponseModel instance,
) => <String, dynamic>{'breeds': instance.breeds};

Breed _$BreedFromJson(Map<String, dynamic> json) =>
    Breed(
        id: json['id'] as String?,
        name: json['name'] as String?,
        cafaUrl: json['cfa_url'] as String?,
        vetstreetUrl: json['vetstreet_url'] as String?,
        vcahospitalsUrl: json['vcahospitals_url'] as String?,
      )
      ..weight = json['weight'] == null
          ? null
          : Weight.fromJson(json['weight'] as Map<String, dynamic>)
      ..temperament = json['temperament'] as String?
      ..origin = json['origin'] as String?
      ..countryCode = json['country_codes'] as String?
      ..description = json['description'] as String?
      ..lifeSpan = json['life_span'] as String?
      ..indoor = (json['indoor'] as num?)?.toInt()
      ..lap = (json['lap'] as num?)?.toInt()
      ..altNames = json['alt_names'] as String?
      ..adaptability = (json['adaptability'] as num?)?.toInt()
      ..affectionLevel = (json['affection_level'] as num?)?.toInt()
      ..childFriendly = (json['child_friendly'] as num?)?.toInt()
      ..dogFriendly = (json['dog_friendly'] as num?)?.toInt()
      ..energyLevel = (json['energy_level'] as num?)?.toInt()
      ..grooming = (json['grooming'] as num?)?.toInt()
      ..healthIssues = (json['health_issues'] as num?)?.toInt()
      ..intelligence = (json['intelligence'] as num?)?.toInt()
      ..sheddingLevel = (json['shedding_level'] as num?)?.toInt()
      ..socialNeeds = (json['social_needs'] as num?)?.toInt()
      ..strangerFriendly = (json['stranger_friendly'] as num?)?.toInt()
      ..vocalisation = (json['vocalisation'] as num?)?.toInt()
      ..experimental = (json['experimental'] as num?)?.toInt()
      ..hairless = (json['hairless'] as num?)?.toInt()
      ..natural = (json['natural'] as num?)?.toInt()
      ..rare = (json['rare'] as num?)?.toInt()
      ..rex = (json['rex'] as num?)?.toInt()
      ..suppressedTail = (json['suppressed_tail'] as num?)?.toInt()
      ..shortLegs = (json['short_legs'] as num?)?.toInt()
      ..wikipediaUrl = json['wikipedia_url'] as String?
      ..hypoallergenic = (json['hypoallergenic'] as num?)?.toInt()
      ..referenceImageId = json['reference_image_id'] as String?;

Map<String, dynamic> _$BreedToJson(Breed instance) => <String, dynamic>{
  'weight': instance.weight,
  'id': instance.id,
  'name': instance.name,
  'cfa_url': instance.cafaUrl,
  'vetstreet_url': instance.vetstreetUrl,
  'vcahospitals_url': instance.vcahospitalsUrl,
  'temperament': instance.temperament,
  'origin': instance.origin,
  'country_codes': instance.countryCode,
  'description': instance.description,
  'life_span': instance.lifeSpan,
  'indoor': instance.indoor,
  'lap': instance.lap,
  'alt_names': instance.altNames,
  'adaptability': instance.adaptability,
  'affection_level': instance.affectionLevel,
  'child_friendly': instance.childFriendly,
  'dog_friendly': instance.dogFriendly,
  'energy_level': instance.energyLevel,
  'grooming': instance.grooming,
  'health_issues': instance.healthIssues,
  'intelligence': instance.intelligence,
  'shedding_level': instance.sheddingLevel,
  'social_needs': instance.socialNeeds,
  'stranger_friendly': instance.strangerFriendly,
  'vocalisation': instance.vocalisation,
  'experimental': instance.experimental,
  'hairless': instance.hairless,
  'natural': instance.natural,
  'rare': instance.rare,
  'rex': instance.rex,
  'suppressed_tail': instance.suppressedTail,
  'short_legs': instance.shortLegs,
  'wikipedia_url': instance.wikipediaUrl,
  'hypoallergenic': instance.hypoallergenic,
  'reference_image_id': instance.referenceImageId,
};

Weight _$WeightFromJson(Map<String, dynamic> json) => Weight(
  imperial: json['imperial'] as String?,
  metric: json['metric'] as String?,
);

Map<String, dynamic> _$WeightToJson(Weight instance) => <String, dynamic>{
  'imperial': instance.imperial,
  'metric': instance.metric,
};
