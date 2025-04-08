import 'dart:ffi';

class SelectedDoctorModel {
  int? id;
  String? name;
  String? profileImage;
  bool? isSelected;

  SelectedDoctorModel({this.id, this.name, this.isSelected = false, this.profileImage});
}
