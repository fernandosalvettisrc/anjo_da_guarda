
class Localizacao {
double latitude;
double longitude;
 Localizacao();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "latitude" : this.latitude,
      "longitude" : this.longitude
    };

    return map;

  }

  double get long => longitude;

  double get lat => latitude;

  set setLatitude(double lat) {
    latitude = lat;
  }
  set setLongitude(double long) {
    longitude = long;
  }
}