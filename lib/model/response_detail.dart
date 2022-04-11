import 'dart:convert';

ResponseDetail responseDetailFromJson(String string) =>
    ResponseDetail.fromJson(json.decode(string));

String ResponseDetailToJson(ResponseDetail data) => json.encode(data.toJson());

class ResponseDetail {
  List<Map<String, dynamic>> meals;

  ResponseDetail({required this.meals});

  factory ResponseDetail.fromJson(Map<String, dynamic> json) => ResponseDetail(
      meals: List<Map<String, dynamic>>.from(json["meals"].map((x) =>
          Map.from(x)
              .map((key, value) => MapEntry<String, dynamic>(key, value)))));

  Map<String, dynamic> toJson() => {
        "meals": List<dynamic>.from(meals.map((e) => Map.from(e)
            .map((key, value) => MapEntry<String, dynamic>(key, value))))
      };
}
