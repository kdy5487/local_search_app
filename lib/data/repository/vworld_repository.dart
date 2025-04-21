import 'package:dio/dio.dart';

class VworldRepository {
  final Dio _client = Dio(
    BaseOptions(
      //설정 안할 시 실패 응답오면 스로우 던져서 에러남.
      validateStatus: (status) => true,
    ),
  );

  //네이버로 검색해서 안쓸 듯
  Future<List<String>> findByName(String query) async {
    final response = await _client.get(
      'https://api.vworld.kr/req/search',
      queryParameters: {
        'request': 'search',
        'key': '1458A225-D1A1-34C0-AC46-2971120602CF',
        'query': query,
        'type': 'DISTRICT',
        'category': 'L4',
        'size': 100, // Optional
      },
    );

    if (response.statusCode == 200 &&
        response.data['response']['status'] == 'OK') {
      // 행정주소 외 정보는 쓰지 않아서 모델생성 X(개인취향)
      // 써드파티 API(외부 API) 모델링 시 프로젝트에 외부 모델이 추가가되어 관리 힘듦
      return List.of(
        response.data['response']['result']['items'],
      ).map((e) => e['title'].toString()).toList();
    }

    return [];
  }

  //위도 경도 받아오기
  Future<List<String>> findByLatLng(double lat, double lng) async {
    final response = await _client.get(
      'https://api.vworld.kr/req/data',
      queryParameters: {
        'request': 'GetFeature',
        'key': '1458A225-D1A1-34C0-AC46-2971120602CF',
        'data': 'LT_C_ADEMD_INFO',
        'geomFilter': 'POINT($lng $lat)',
        'geometry': false,
        'size': 100,
      },
    );
    if (response.statusCode == 200 &&
        response.data['response']['status'] == 'OK') {
      //Response > result > featureCollection > features > properties > full_nm
      return List.of(
        response.data['response']['result']['featureCollection']['features'],
      ).map((e) => e['properties']['full_nm'].toString()).toList();
    }

    return [];
  }
}
