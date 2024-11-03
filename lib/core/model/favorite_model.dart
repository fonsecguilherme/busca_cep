import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:zip_search/core/model/address_model.dart';

class FavoriteModel extends Equatable {
  final AddressModel addressModel;
  final List<String> tags;
  final String description;

  FavoriteModel({
    required this.addressModel,
    List<String>? tags,
    String? description,
  })  : tags = tags ?? [],
        description = description ?? 'Sem descrição';

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      addressModel: AddressModel.fromJson(json['addressModel']),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((tag) => tag as String)
              .toList() ??
          [],
      description: json['description'] ?? 'Sem descrição',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressModel': addressModel.toJson(),
      'tags': tags,
      'description': description.isNotEmpty ? description : 'Sem descrição',
    };
  }

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
  List<Object?> get props => [
        addressModel,
        tags,
        description,
      ];
}
