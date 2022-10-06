const String tablePurchasingItems = 'purchasingItems';

class PurchasingItemsFields {
  static final List<String> values = [purItemsId, prodId, amount, total, purId];

  static final String purItemsId = '_purItemsId';
  static final String prodId = 'prodId';
  static final String amount = 'amount';
  static final String total = 'total';
  static final String purId = 'purId';
}

class PurchasingItemsModel {
  final int? purItemsId;
  final int amount;
  final int prodId;
  final int total;
  final int purId;

  PurchasingItemsModel({
    this.purItemsId,
    required this.prodId,
    required this.amount,
    required this.total,
    required this.purId,
  });
  PurchasingItemsModel copy({
    int? pruItemsId,
    int? prodId,
    int? amount,
    int? total,
    int? purId,
  }) =>
      PurchasingItemsModel(
        purItemsId: purItemsId ?? this.purItemsId,
        prodId: prodId ?? this.prodId,
        amount: amount ?? this.amount,
        total: total ?? this.total,
        purId: purId ?? this.purId,
      );

  static PurchasingItemsModel fromJson(Map<String, Object?> json) =>
      PurchasingItemsModel(
        purItemsId: json[PurchasingItemsFields.purItemsId] as int?,
        prodId: json[PurchasingItemsFields.prodId] as int,
        amount: json[PurchasingItemsFields.amount] as int,
        total: json[PurchasingItemsFields.total] as int,
        purId: json[PurchasingItemsFields.purId] as int,
      );
  Map<String, Object?> toJson() => {
        PurchasingItemsFields.purItemsId: purItemsId,
        PurchasingItemsFields.prodId: prodId,
        PurchasingItemsFields.amount: amount,
        PurchasingItemsFields.total: total,
        PurchasingItemsFields.purId: purId,
      };
}
