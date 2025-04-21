import 'package:geolocator/geolocator.dart';

class GeolocatorHelper {
  static Future getPosition() async {
    final permission = await Geolocator.checkPermission();
    //1. 현재 권한이 허용되지 않았을 때 권한 요청하기
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      //2. 권한 요청 후 결과가 거부일 때 리턴하기

      final permission2 = await Geolocator.requestPermission();
      if (permission2 == LocationPermission.denied ||
          permission2 == LocationPermission.deniedForever) {
        return null;
      }
    }

    //2. 권한 요청 후 결과가 거부일 때 리턴하기

    //3. Geolocator로 위치 가져와서 리턴
    final position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      ),
    );
    return position; //이부분 리턴안해서 권한 요청이 계속안됨.
  }
}
