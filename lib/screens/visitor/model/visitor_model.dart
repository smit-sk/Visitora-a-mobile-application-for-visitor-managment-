import 'package:hive/hive.dart';

part 'visitor_model.g.dart';

@HiveType(typeId: 0)
class Visitor {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String vaccinated;
  @HiveField(2)
  final String number;
  @HiveField(3)
  final String address;

  Visitor(this.name, this.vaccinated, this.number, this.address);
}
