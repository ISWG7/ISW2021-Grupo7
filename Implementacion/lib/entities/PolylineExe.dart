

import 'package:json_annotation/json_annotation.dart';


part 'PolylineExe.g.dart';
@JsonSerializable()
class PolylineExe {
  List<List<double>> coordinates;
  String type;

  PolylineExe(this.coordinates, this.type);

  factory PolylineExe.fromJson(Map<String,dynamic> data) => _$PolylineExeFromJson(data);

  Map<String,dynamic> toJson() => _$PolylineExeToJson(this);


}
