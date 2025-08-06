import 'package:careerwill/models/kit.dart';
import 'package:careerwill/models/parent.dart';

class Student {
  final String id;
  final String name;
  final String address;
  final String phone;
  final ImageModel imageUrl;
  final List<KitItem> kit;
  final String? feeId;
  final int rollNo;
  final ParentModel? parent;
  final String previousSchoolName,
      medium,
      category,
      state,
      city,
      pinCode,
      permanentAddress,
      tShirtSize,
      howDidYouHearAboutUs,
      programmeName;

  Student({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.imageUrl,
    required this.kit,
    this.feeId,
    required this.rollNo,
    this.parent,
    required this.previousSchoolName,
    required this.medium,
    required this.category,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.permanentAddress,
    required this.tShirtSize,
    required this.howDidYouHearAboutUs,
    required this.programmeName,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      imageUrl: json['image'] != null
          ? ImageModel.fromJson(json['image'])
          : ImageModel(publicId: '', url: ''),
      kit:
          (json['kit'] as List?)
              ?.map((item) => KitItem.fromJson(item))
              .toList() ??
          [],
      feeId: json['fee'],
      rollNo: json['rollNo'] is int
          ? json['rollNo']
          : int.tryParse(json['rollNo'].toString()) ?? 0,
      parent: json['parent'] != null
          ? ParentModel.fromJson(json['parent'])
          : null,
      previousSchoolName: json['previousSchoolName'] ?? '',
      medium: json['medium'] ?? '',
      category: json['category'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
      permanentAddress: json['permanentAddress'] ?? '',
      tShirtSize: json['tShirtSize'] ?? '',
      howDidYouHearAboutUs: json['howDidYouHearAboutUs'] ?? '',
      programmeName: json['programmeName'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, address: $address, phone: $phone, imageUrl: $imageUrl, kit: $kit, feeId: $feeId, rollNo: $rollNo, parent: $parent, previousSchoolName: $previousSchoolName, medium: $medium, category: $category, state: $state, city: $city, pinCode: $pinCode, permanentAddress: $permanentAddress, tShirtSize: $tShirtSize, howDidYouHearAboutUs: $howDidYouHearAboutUs, programmeName: $programmeName)';
  }
}

class ImageModel {
  final String publicId;
  final String url;

  ImageModel({required this.publicId, required this.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
