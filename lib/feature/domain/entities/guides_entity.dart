import 'package:equatable/equatable.dart';
class GuideEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final String text;


  const GuideEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.text,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    image,
    text,
  ];
}
