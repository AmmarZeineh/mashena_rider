import 'package:equatable/equatable.dart';

class RatingTag extends Equatable {
  final int id;
  final String code;
  final String? name;

  const RatingTag({required this.id, required this.code, this.name});

  @override
  List<Object?> get props => [id, code, name];
}
