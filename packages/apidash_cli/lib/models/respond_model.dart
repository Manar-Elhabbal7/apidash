import 'name_value_model.dart';

class ResponseModel {
  final int statusCode;
  final dynamic body;
  final List<NameValueModel>? headers;

  ResponseModel({required this.statusCode, this.body, this.headers});

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'body': body,
        'headers': headers?.map((e) => e.toJson()).toList(),
      };

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        statusCode: json['statusCode'],
        body: json['body'],
        headers: (json['headers'] as List<dynamic>?)
            ?.map((e) => NameValueModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
}
