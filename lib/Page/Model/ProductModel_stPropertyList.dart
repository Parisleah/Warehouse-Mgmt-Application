const String tableProductModel_stPropertyList = 'productModel_stPropertyList';

class ProductModel_stPropertyListFields {
  static final List<String> values = [
    pmstPropListId,
    pmstPropListName,
    pmstPropId
  ];

  static final String pmstPropListId = 'pmstPropId';
  static final String pmstPropListName = 'pmstPropName';
  static final String pmstPropId = 'prodModelId';
}

class ProductModel_stPropertyList {
  final int? pmstPropListId;
  final String pmstPropListName;
  final int? pmstPropId;

  ProductModel_stPropertyList({
    this.pmstPropListId,
    required this.pmstPropListName,
    this.pmstPropId,
  });
  ProductModel_stPropertyList copy({
    int? pmstPropListId,
    String? pmstPropListName,
    int? pmstPropId,
  }) =>
      ProductModel_stPropertyList(
        pmstPropListId: pmstPropListId ?? this.pmstPropListId,
        pmstPropListName: pmstPropListName ?? this.pmstPropListName,
        pmstPropId: pmstPropId ?? this.pmstPropId,
      );
  static ProductModel_stPropertyList fromJson(Map<String, Object?> json) =>
      ProductModel_stPropertyList(
        pmstPropListId:
            json[ProductModel_stPropertyListFields.pmstPropListId] as int,
        pmstPropListName:
            json[ProductModel_stPropertyListFields.pmstPropListName] as String,
        pmstPropId: json[ProductModel_stPropertyListFields.pmstPropId] as int,
      );
  Map<String, Object?> toJson() => {
        ProductModel_stPropertyListFields.pmstPropId: pmstPropId,
        ProductModel_stPropertyListFields.pmstPropListName: pmstPropListName,
        ProductModel_stPropertyListFields.pmstPropId: pmstPropId,
      };
}
