import 'package:sahajghara/screens/home/HomePageResponse.dart';

class BrandResponse {
  bool? hasError;
  String? message;
  List<Brands>? data;

  BrandResponse({this.hasError, this.message, this.data});

  BrandResponse.fromJson(Map<String, dynamic> json) {
    hasError = json['HasError'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <Brands>[];
      json['data'].forEach((v) {
        data!.add(new Brands.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasError'] = this.hasError;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  String? id;
  String? name;
  String? photoUrl;


  Brands({this.id, this.name,this.photoUrl});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photoUrl = json['photo_url'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['photo_url'] = this.photoUrl;
    
    return data;
  }
}
