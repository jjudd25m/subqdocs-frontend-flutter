import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/home/model/home_past_patient_list_sorting_model.dart';
import '../../modules/home/model/home_patient_list_sorting_model.dart';
import '../../modules/home/model/home_schedule_list_sorting_model.dart';

class AppPreference {
  static final AppPreference _appPreference = AppPreference._internal();

  AppPreference._internal();

  static AppPreference get instance => _appPreference;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setListMap(String key, List<Map<String, dynamic>> value) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the list of maps to a JSON string
    String encodedList = json.encode(value);
    await prefs.setString(key, encodedList); // Save the JSON string
  }

  Future<List<Map<String, dynamic>>> getListMap(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(key);

    if (jsonString != null) {
      // Decode the JSON string back into a List of Maps
      List<dynamic> decodedList = json.decode(jsonString);
      return decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return []; // Return an empty list if the key doesn't exist
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs?.getInt(key) ?? defaultValue;
  }

  String getString(String key, {String defaultValue = ""}) {
    return _prefs?.getString(key) ?? defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  Future<void> clearPreference() async {
    await _prefs?.clear();
  }

  Future<void> removeKey(String key) async {
    await _prefs?.remove(key);
  }

// Set function for HomePastPatientListSortingModel
  Future<void> setHomePastPatientListSortingModel(HomePastPatientListSortingModel model) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedModel = json.encode(model.toJson());
    await prefs.setString('homePastPatientListSortingModel', encodedModel);
  }

// Get function for HomePastPatientListSortingModel
  Future<HomePastPatientListSortingModel?> getHomePastPatientListSortingModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedModel = prefs.getString('homePastPatientListSortingModel');

    if (encodedModel != null) {
      Map<String, dynamic> decoded = json.decode(encodedModel);
      return HomePastPatientListSortingModel.fromJson(decoded);
    }
    return null; // Return null if no model is stored
  }

// Set function for HomePatientListSortingModel
  Future<void> setHomePatientListSortingModel(HomePatientListSortingModel model) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedModel = json.encode(model.toJson());
    await prefs.setString('homePatientListSortingModel', encodedModel);
  }

// Get function for HomePatientListSortingModel
  Future<HomePatientListSortingModel?> getHomePatientListSortingModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedModel = prefs.getString('homePatientListSortingModel');

    if (encodedModel != null) {
      Map<String, dynamic> decoded = json.decode(encodedModel);
      return HomePatientListSortingModel.fromJson(decoded);
    }
    return null; // Return null if no model is stored
  }

// Set function for HomeScheduleListSortingModel
  Future<void> setHomeScheduleListSortingModel(HomeScheduleListSortingModel model) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedModel = json.encode(model.toJson());
    await prefs.setString('homeScheduleListSortingModel', encodedModel);
  }

// Get function for HomeScheduleListSortingModel
  Future<HomeScheduleListSortingModel?> getHomeScheduleListSortingModel() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedModel = prefs.getString('homeScheduleListSortingModel');

    if (encodedModel != null) {
      Map<String, dynamic> decoded = json.decode(encodedModel);
      return HomeScheduleListSortingModel.fromJson(decoded);
    }
    return null; // Return null if no model is stored
  }
}
