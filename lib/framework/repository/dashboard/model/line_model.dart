class LineGraphData {
  final String? date;
  final TotalData? total;

  LineGraphData({this.date, this.total});

  factory LineGraphData.fromJson(Map<String, dynamic> json) => LineGraphData(date: json['date'], total: json['total'] == null ? null : TotalData.fromJson(json['total']));
}

class TotalData {
  final String? year;
  final String? subtotal;
  final String? roundtotal;
  final String? grandTotal;

  TotalData({this.year, this.subtotal, this.roundtotal, this.grandTotal});

  factory TotalData.fromJson(Map<String, dynamic> json) =>
      TotalData(year: json['year']?.toString(), subtotal: json['subtotal'].toString(), roundtotal: json['roundtotal'].toString(), grandTotal: json['grandTotal'].toString());
}
