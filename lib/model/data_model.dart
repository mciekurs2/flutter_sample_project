import 'package:json_annotation/json_annotation.dart';

part 'data_model.g.dart';

@JsonSerializable(nullable: true, includeIfNull: false)
class Data {
  String name;
  String image;

  Data({this.name, this.image});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
