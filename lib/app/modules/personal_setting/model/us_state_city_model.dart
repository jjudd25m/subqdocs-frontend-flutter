class StateCityModel {
  String state;
  List<String> cities;

  StateCityModel({required this.state, required this.cities});

  // Method to convert JSON data into a list of StateCityModel objects
  static List<StateCityModel> fromJson(Map<String, dynamic> json) {
    List<StateCityModel> states = [];
    json.forEach((state, cities) {
      states.add(StateCityModel(
        state: state,
        cities: List<String>.from(cities),
      ));
    });
    return states;
  }
}
