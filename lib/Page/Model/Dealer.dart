const String tableDealer = 'dealer';

class DealerFields {
  static final List<String> values = [dealerId, dName, dAddress, dPhone];

  static final String dealerId = '_dealerId';
  static final String dName = 'dName';
  static final String dAddress = 'dAddress';
  static final String dPhone = 'dPhone';
}

class DealerModel {
  final int? dealerId;
  final String dName;
  final String dAddress;
  final String dPhone;

  DealerModel({
    this.dealerId,
    required this.dName,
    required this.dAddress,
    required this.dPhone,
  });
  DealerModel copy({
    int? dealerId,
    String? dName,
    String? dAddress,
    String? dPhone,
  }) =>
      DealerModel(
        dealerId: dealerId ?? this.dealerId,
        dName: dName ?? this.dName,
        dAddress: dAddress ?? this.dAddress,
        dPhone: dPhone ?? this.dPhone,
      );

  static DealerModel fromJson(Map<String, Object?> json) => DealerModel(
        dealerId: json[DealerFields.dealerId] as int?,
        dName: json[DealerFields.dName] as String,
        dAddress: json[DealerFields.dAddress] as String,
        dPhone: json[DealerFields.dPhone] as String,
      );
  Map<String, Object?> toJson() => {
        DealerFields.dealerId: dealerId,
        DealerFields.dName: dName,
        DealerFields.dAddress: dAddress,
        DealerFields.dPhone: dPhone,
      };
}
