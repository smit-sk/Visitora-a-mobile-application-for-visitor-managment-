import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  final String count;
  final String date;
  final String vaccinated_count;
  final String not_vaccinated_count;

  Data(this.count, this.date, this.vaccinated_count, this.not_vaccinated_count);

  Data.fromMap(Map<String, dynamic> map)
      : assert(map['count'] != null),
        assert(map['date'] != null),
        assert(map['not_vaccinated_count'] != null),
        count = map['count'].toString(),
        vaccinated_count = map['vaccinated_count'].toString(),
        date = map['date'],
        not_vaccinated_count = map['not_vaccinated_count'].toString();

  
  @override
  String toString() =>
      "Record<$count:$date:$vaccinated_count:$not_vaccinated_count>";
}
