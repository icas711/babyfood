import 'package:equatable/equatable.dart';
class FoodNameEntity extends Equatable {
  final String name;

  const FoodNameEntity({
    required this.name,
  });

  @override
  List<Object?> get props => [
     name,

  ];
}
