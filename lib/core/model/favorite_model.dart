import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

class FavoriteModel extends Equatable {
  final AddressModel addressModel;
  final List<String> tags;
  final String? description;

  const FavoriteModel({
    required this.addressModel,
    this.tags = const [],
    this.description,
  });

  FavoriteModel copyWith({
    AddressModel? addressModel,
    List<String>? tags,
    String? description,
  }) {
    return FavoriteModel(
      addressModel: addressModel ?? this.addressModel,
      tags: tags ?? this.tags,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [addressModel, tags, description];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressModel': addressModel.toJson(),
      'tags': tags,
      'description': description,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      addressModel:
          AddressModel.fromJson(map['addressModel'] as Map<String, dynamic>),
      tags: List<String>.from((map['tags'] as List<String>)),
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteModel.fromJson(String source) =>
      FavoriteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
