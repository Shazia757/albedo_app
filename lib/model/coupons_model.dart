class Coupons {
  String id;
  String name;
  String code;
  String? discountType;
  String? discount;
  String? startDate;
  String? endDate;

  Coupons({
    required this.code,
    required this.name,
    required this.id,
    this.discountType,
    this.discount,
    this.startDate,
    this.endDate,
  });
}
