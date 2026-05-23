class Coupons {
  String id;
  String name;
  String code;
  String? discountType;
  String? discountPercentage;
  String? discountAmount;
  String? startDate;
  String? endDate;

  Coupons({
    required this.code,
    required this.name,
    required this.id,
    this.discountType,
    this.discountAmount,
    this.discountPercentage,
    this.startDate,
    this.endDate,
  });

  factory Coupons.fromJson(Map<String, dynamic> json) {
    return Coupons(
      id: json['id'] ?? '',
      name: json['coupon_name'] ?? '',
      code: json['coupon_code'] ?? '',
      discountType: json['discount_type'],
      discountPercentage:
          json['discount_percentage']?.toString(),
      discountAmount:
          json['discount_amount']?.toString(),
      startDate: json['valid_from'],
      endDate: json['valid_to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "coupon_name": name,
      "coupon_code": code,
      "discount_type": discountType,
      "discount_percentage": discountPercentage,
      "discount_amount": discountAmount,
      "valid_from": startDate,
      "valid_to": endDate,
    };
  }
}