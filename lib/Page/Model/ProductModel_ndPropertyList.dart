const String tableProductModel_ndPropertyList = 'productModel_ndPropertyList';

class ProductModel_ndPropertyListFields {
  static final List<String> values = [
    pmndPropListId,
    pmndPropListName,
    pmndPropId
  ];

  static final String pmndPropListId = 'pmndPropListId';
  static final String pmndPropListName = 'pmndPropListName';
  static final String pmndPropId = 'pmndPropId';
}

class ProductModel_ndPropertyList {
  final int? pmndPropListId;
  final String pmndPropListName;
  final int? pmndPropId;

  ProductModel_ndPropertyList({
    this.pmndPropListId,
    required this.pmndPropListName,
    this.pmndPropId,
  });
  ProductModel_ndPropertyList copy({
    int? pmndPropListId,
    String? pmndPropListName,
    int? pmndPropId,
  }) =>
      ProductModel_ndPropertyList(
        pmndPropListId: pmndPropListId ?? this.pmndPropListId,
        pmndPropListName: pmndPropListName ?? this.pmndPropListName,
        pmndPropId: pmndPropId ?? this.pmndPropId,
      );
  static ProductModel_ndPropertyList fromJson(Map<String, Object?> json) =>
      ProductModel_ndPropertyList(
        pmndPropListId:
            json[ProductModel_ndPropertyListFields.pmndPropListId] as int,
        pmndPropListName:
            json[ProductModel_ndPropertyListFields.pmndPropListName] as String,
        pmndPropId: json[ProductModel_ndPropertyListFields.pmndPropId] as int,
      );
  Map<String, Object?> toJson() => {
        ProductModel_ndPropertyListFields.pmndPropListId: pmndPropListId,
        ProductModel_ndPropertyListFields.pmndPropListName: pmndPropListName,
        ProductModel_ndPropertyListFields.pmndPropId: pmndPropId,
      };
}
