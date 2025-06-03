import 'package:latlong2/latlong.dart';

class Place {
  final int id;
  
  final String name;
  
  final String placeType;
  
  final double? latitude;
  
  final double? longitude;

  final String? address;

  const Place({
    required this.id,
    required this.name,
    required this.placeType,
    this.latitude,
    this.longitude,
    this.address,
  });
  
  Place copyWith({
    int? id,
    String? name,
    String? placeType,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      placeType: placeType ?? this.placeType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }
  
  factory Place.empty() {
    return Place(
      id: DateTime.now().millisecondsSinceEpoch,
      name: 'Имя',
      placeType: 'Место',
    );
  }

  LatLng get coordinates => LatLng(latitude!, longitude!);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'placeType': placeType,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
  };

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    id: json['id'] as int,
    name: json['name'] as String,
    placeType: json['placeType'] as String,
    latitude: json['latitude'] as double?,
    longitude: json['longitude'] as double?,
    address: json['address'] as String?,
  );
}