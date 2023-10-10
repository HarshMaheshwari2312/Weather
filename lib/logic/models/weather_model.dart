class WeatherModel {
  final String temp;
  final String pressure;
  final String humidity;
  final String city;
  final String desc;
  final String icon;
  final double windSpeed;

  WeatherModel.fromMap(Map<String, dynamic> json)
      : temp = json['main']['temp'].toString(),
        pressure = json['main']['pressure'].toString(),
        humidity = json['main']['humidity'].toString(),
        city = json['name'],
        desc = json['weather'][0]['description'],
        icon = json['weather'][0]['icon'],
        windSpeed = json['wind']['speed'];

}
