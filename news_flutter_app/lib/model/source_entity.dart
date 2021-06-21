import 'package:json_annotation/json_annotation.dart';

part 'source_entity.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SourceEntity {
  final String? id;
  final String? name;

  SourceEntity(this.id, this.name);

  factory SourceEntity.fromJson(Map<String, dynamic> json) =>
      _$SourceEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SourceEntityToJson(this);
}
