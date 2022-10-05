class Details {
  late String name;
  late String vaccinated;
  late String number;
  late String address;

  Details({required this.name, required this.vaccinated, required this.number, required this.address});

  Details.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    vaccinated = json['vaccinated'];
    number = json['number'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['vaccinated'] = this.vaccinated;
    data['number'] = this.number;
    data['address'] = this.address;
    return data;
  }
}
