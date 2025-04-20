import 'dart:convert';

import 'package:http/http.dart';
import 'package:local_search_app/data/model/location.dart';

class LocationRepository {
  Future<List<Location>> searchLocation(String query) async {
    final client = Client();
    final encodedQuery = Uri.encodeQueryComponent(query); // ← 인코딩 추가

    final response = await client.get(
      Uri.parse(
        'https://openapi.naver.com/v1/search/local.json?query=$query&display=5', //최대 5개
      ),
      headers: {
        'X-Naver-Client-Id': '7bMkcD3yDQY5xq6IFOLc',
        'X-Naver-Client-Secret': 'UCfn6sycHy',
      },
    );
    //Get 요청 시 성공 => 200
    //응답 코드가 200일 때!
    //body데이터를 jsonDecode 함수 사용해서 map으로 바꾼 후 List<Book>로 반환

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      final items = List.from(map['items']);
      //MappedIterable이라는 클래스에 함수를 넘겨줄테니
      //나중에 요청하면, 그때 리스트아이템들을 하나씩 반복문을 돌면서
      //내가 넘겨준 함수를 실행시켜서 새로운 리스트로 돌려줘.
      final iterable = items.map((e) {
        return Location.fromJson(e);
      });
      final list = iterable.toList();
      return list;
    }
    return [];
    response.body;
    response.statusCode;
  }
}
