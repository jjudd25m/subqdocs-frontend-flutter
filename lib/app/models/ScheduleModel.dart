import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import 'SelectedDoctorMedicationModel.dart';

class ScheduleModel{

  String? selectedDoctorValueSchedule;

  String? selectedMedicationValueSchedule ;

  // String? selectedVisitTimeValue;
  TextEditingController selectedVisitTimeValue  =TextEditingController();


  TextEditingController visitDateController = TextEditingController();

  Rxn<SelectedDoctorModel> selectedDoctorValueModelSchedulePatient = Rxn();
  Rxn<SelectedDoctorModel> selectedMedicationModelSchedulePatient = Rxn();
  Rxn<SelectedDoctorModel> selectedMedicalValueModelSchedulePatient = Rxn();



  DateTime? visitDate ;

  int? patientId;
  String?  selectedPatient;



  TextEditingController searchController = TextEditingController();
  FocusNode doctorFocusNodeSchedule ;
  FocusNode medicationFocusNodeSchedule ;
  FocusNode searchNodeSchedule;
  FocusNode timeSlotFocusNodeSchedule ;

  ScheduleModel({  this.selectedDoctorValueSchedule, this.selectedMedicationValueSchedule , this.visitDate, required this.doctorFocusNodeSchedule, required this.medicationFocusNodeSchedule,
      required this.searchNodeSchedule, required this.timeSlotFocusNodeSchedule});


}