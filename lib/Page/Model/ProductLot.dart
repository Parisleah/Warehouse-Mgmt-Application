const String tableProductLot = 'productLot';

class ProductLotFields {
  static final List<String> values = [
    prodLotId,
    orderedTime,
    amount,
    remainAmount,
    prodModelId
  ];
  static final String prodLotId = 'prodLotId';
  static final String orderedTime = 'orderedTime';
  static final String amount = 'amount';
  static final String remainAmount = 'remainAmount';
  static final String prodModelId = 'prodModelId';
}

class ProductLot {
  final int? prodLotId;
  final DateTime orderedTime;
  final int amount;
  final int remainAmount;
  final int? prodModelId;

  ProductLot({
    this.prodLotId,
    required this.orderedTime,
    required this.amount,
    required this.remainAmount,
    this.prodModelId,
  });
  ProductLot copy({
    int? prodLotId,
    DateTime? orderedTime,
    int? amount,
    int? remainAmount,
    int? prodModelId,
  }) =>
      ProductLot(
        prodLotId: prodLotId ?? this.prodLotId,
        orderedTime: orderedTime ?? this.orderedTime,
        amount: amount ?? this.amount,
        remainAmount: remainAmount ?? this.remainAmount,
        prodModelId: prodModelId ?? this.prodModelId,
      );
  static ProductLot fromJson(Map<String, Object?> json) => ProductLot(
        prodLotId: json[ProductLotFields.prodLotId] as int,
        orderedTime:
            DateTime.parse(json[ProductLotFields.orderedTime] as String),
        amount: json[ProductLotFields.amount] as int,
        remainAmount: json[ProductLotFields.remainAmount] as int,
        prodModelId: json[ProductLotFields.prodModelId] as int,
      );
  Map<String, Object?> toJson() => {
        ProductLotFields.prodLotId: prodLotId,
        ProductLotFields.orderedTime: orderedTime.toIso8601String(),
        ProductLotFields.amount: amount,
        ProductLotFields.remainAmount: remainAmount,
        ProductLotFields.prodModelId: prodModelId,
      };
}
