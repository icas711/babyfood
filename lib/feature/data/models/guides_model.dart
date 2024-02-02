

import 'package:babyfood/feature/domain/entities/guides_entity.dart';

class GuideModel extends GuideEntity {
  const GuideModel({
    required id,
    required name,
    required description,
    required image,
    required text,

  }) : super(
    id: id,
    name: name,
    description: description,
    image: image,
    text: text,
  );


  factory GuideModel.fromJson(Map<String, dynamic> json) {
    return GuideModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'text': text,
    };
  }
}

