const String tablePurchasing = 'purchasing';

class PurchasingFields {
  static final List<String> values = [
    purId,
    orderedDate,
    dealerId,
    shippingId,
    shippingCost,
    amount,
    total,
    isReceive,
  ];

  static final String purId = '_purId';
  static final String orderedDate = 'orderedDate';
  static final String dealerId = 'dealerId';
  static final String shippingId = 'shippingId';
  static final String shippingCost = 'shippingCost';
  static final String amount = 'amount';
  static final String total = 'total';
  static final String isReceive = 'isReceive';
}

class PurchasingModel {
  final int? purId;
  final DateTime orderedDate;
  final int dealerId;
  final int shippingId;
  final int shippingCost;
  final int amount;
  final int total;
  final bool isReceive;

  PurchasingModel(
      {this.purId,
      required this.orderedDate,
      required this.dealerId,
      required this.shippingId,
      required this.shippingCost,
      required this.amount,
      required this.total,
      required this.isReceive});
  PurchasingModel copy({
    int? pruId,
    DateTime? orderedDate,
    int? dealerId,
    int? shippingId,
    int? shippingCost,
    int? amount,
    int? total,
    bool? isReceive,
  }) =>
      PurchasingModel(
          purId: pruId ?? this.purId,
          orderedDate: orderedDate ?? this.orderedDate,
          dealerId: dealerId ?? this.dealerId,
          shippingId: shippingId ?? this.shippingId,
          shippingCost: shippingCost ?? this.shippingCost,
          amount: amount ?? this.amount,
          total: total ?? this.total,
          isReceive: isReceive ?? this.isReceive);
  static PurchasingModel fromJson(Map<String, Object?> json) => PurchasingModel(
        purId: json[PurchasingFields.purId] as int?,
        orderedDate:
            DateTime.parse(json[PurchasingFields.orderedDate] as String),
        dealerId: json[PurchasingFields.dealerId] as int,
        shippingId: json[PurchasingFields.shippingId] as int,
        shippingCost: json[PurchasingFields.shippingCost] as int,
        amount: json[PurchasingFields.amount] as int,
        total: json[PurchasingFields.total] as int,
        isReceive: json[PurchasingFields.isReceive] == 1,
      );
  Map<String, Object?> toJson() => {
        PurchasingFields.purId: purId,
        PurchasingFields.orderedDate: orderedDate.toIso8601String(),
        PurchasingFields.dealerId: dealerId,
        PurchasingFields.shippingId: shippingId,
        PurchasingFields.shippingCost: shippingCost,
        PurchasingFields.amount: amount,
        PurchasingFields.total: total,
        PurchasingFields.isReceive: isReceive ? 1 : 0,
      };
}
