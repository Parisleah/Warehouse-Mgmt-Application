const String tableDeliveryCompany = 'deliveryCompany';

class DeliveryCompanyFields {
  static final List<String> values = [dcId, dcName, shopId];

  static final String dcId = '_dcId';
  static final String dcName = 'dcName';
  static final String shopId = 'shopId';
}

class DeliveryCompanyModel {
  final int? dcId;
  final String dcName;
  final int? shopId;
  DeliveryCompanyModel({
    this.dcId,
    required this.dcName,
    this.shopId,
  });
  DeliveryCompanyModel copy({
    int? dcId,
    String? dcName,
    int? shopId,
  }) =>
      DeliveryCompanyModel(
          dcId: dcId ?? this.dcId,
          dcName: dcName ?? this.dcName,
          shopId: shopId ?? this.shopId);

  static DeliveryCompanyModel fromJson(Map<String, Object?> json) =>
      DeliveryCompanyModel(
        dcId: json[DeliveryCompanyFields.dcId] as int?,
        dcName: json[DeliveryCompanyFields.dcName] as String,
        shopId: json[DeliveryCompanyFields.shopId] as int?,
      );
  Map<String, Object?> toJson() => {
        DeliveryCompanyFields.dcId: dcId,
        DeliveryCompanyFields.dcName: dcName,
        DeliveryCompanyFields.shopId: shopId,
      };
}
