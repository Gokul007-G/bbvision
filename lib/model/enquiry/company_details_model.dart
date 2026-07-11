class CompanyDetails {
  final int id;
  final int clientId;
  final String orgName;
  final String website;
  final String itName;
  final String location;
  final String state;
  final String city;
  final String itMob1;
  final String itMob2;
  final String itMail1;
  final String itMail2;
  final String address;

  CompanyDetails({
    required this.id,
    required this.clientId,
    required this.orgName,
    required this.website,
    required this.itName,
    required this.location,
    required this.state,
    required this.city,
    required this.itMob1,
    required this.itMob2,
    required this.itMail1,
    required this.itMail2,
    required this.address,
  });

  factory CompanyDetails.fromJson(Map<String, dynamic> json) {
    return CompanyDetails(
      id: int.tryParse(json['id'].toString()) ?? 0,
      clientId: int.tryParse(json['client_id'].toString()) ?? 0,
      orgName: json['org_name']?.toString().trim() ?? '',
      website: json['website']?.toString().trim() ?? '',
      itName: json['it_name']?.toString().trim() ?? '',
      location: json['location']?.toString().trim() ?? '',
      state: json['state']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      itMob1: json['it_mob1']?.toString().trim() ?? '',
      itMob2: json['it_mob2']?.toString().trim() ?? '',
      itMail1: json['it_mail1']?.toString().trim() ?? '',
      itMail2: json['it_mail2']?.toString().trim() ?? '',
      address: json['address']?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client_id': clientId,
      'org_name': orgName,
      'website': website,
      'it_name': itName,
      'location': location,
      'state': state,
      'city': city,
      'it_mob1': itMob1,
      'it_mob2': itMob2,
      'it_mail1': itMail1,
      'it_mail2': itMail2,
      'address': address,
    };
  }
}
