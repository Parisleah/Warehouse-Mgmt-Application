const String tableProductModel = 'productModel';

class ProductModelFields {
  static final List<String> values = [
    prodModelId,
    prodModelname,
    stProperty,
    ndProperty,
    cost,
    price,
    prodId,
  ];

  static final String prodModelId = 'prodModelId';
  static final String prodModelname = 'prodModelname';
  static final String stProperty = 'stProperty';
  static final String ndProperty = 'ndProperty';
  static final String cost = 'cost';
  static final String price = 'price';
  static final String prodId = 'prodId';
}

class ProductModel {
  final int? prodModelId;
  final String prodModelname;
  final String? stProperty;
  final String? ndProperty;
  final int cost;
  final int price;
  final int? prodId;

  ProductModel({
    this.prodModelId,
    required this.prodModelname,
    this.stProperty,
    this.ndProperty,
    required this.cost,
    required this.price,
    this.prodId,
  });
  ProductModel copy({
    int? prodModelId,
    String? prodModelname,
    String? stProperty,
    String? ndProperty,
    int? cost,
    int? price,
    int? prodId,
  }) =>
      ProductModel(
        prodModelId: prodModelId ?? this.prodModelId,
        prodModelname: prodModelname ?? this.prodModelname,
        stProperty: stProperty ?? this.stProperty,
        ndProperty: ndProperty ?? this.ndProperty,
        cost: cost ?? this.cost,
        price: price ?? this.price,
        prodId: prodId ?? this.prodId,
      );
  static ProductModel fromJson(Map<String, Object?> json) => ProductModel(
        prodModelId: json[ProductModelFields.prodModelId] as int,
        prodModelname: json[ProductModelFields.prodModelname] as String,
        stProperty: json[ProductModelFields.stProperty] as String,
        ndProperty: json[ProductModelFields.ndProperty] as String,
        cost: json[ProductModelFields.cost] as int,
        price: json[ProductModelFields.price] as int,
        prodId: json[ProductModelFields.prodId] as int,
      );
  Map<String, Object?> toJson() => {
        ProductModelFields.prodModelId: prodModelId,
        ProductModelFields.prodModelname: prodModelname,
        ProductModelFields.stProperty: stProperty,
        ProductModelFields.ndProperty: ndProperty,
        ProductModelFields.cost: cost,
        ProductModelFields.price: price,
        ProductModelFields.prodId: prodId,
      };
}
