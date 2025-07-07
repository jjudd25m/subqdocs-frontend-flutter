class SelectedDoctorModel {
  int? id;
  String? name;
  String? profileImage;
  bool? isSelected;
  String? isDeleted;

  SelectedDoctorModel({this.id, this.name, this.isSelected = false, this.profileImage, this.isDeleted = ""});
}
