//  {
//       "title": "커피해리902",
//       "link": "https://www.instagram.com/coffeeharry902",
//       "category": "음식점>카페,디저트",
//       "description": "",
//       "telephone": "",
//       "address": "인천광역시 서구 원당동 1030-8 검단퍼스트 112호",
//       "roadAddress": "인천광역시 서구 이음5로 80 검단퍼스트 112호",
//       "mapx": "1267163311",
//       "mapy": "375953218"
//     }
//클래스 모델 만들기
import 'dart:convert';

class Location {
  String title;
  String link;
  String category;
  String description;
  String telephone;
  String address;
  String roadAddress;
  String mapx;
  String mapy;

  Location({
    required this.title,
    required this.link,
    required this.category,
    required this.description,
    required this.telephone,
    required this.address,
    required this.roadAddress,
    required this.mapx,
    required this.mapy,
  });

  // 1. fromJson네임드 생성자 만들기
  Location.fromJson(Map<String, dynamic> json)
    : this(
        title: json['title'],
        link: json['link'],
        category: json['category'],
        description: json['description'],
        telephone: json['telephone'],
        address: json['address'],
        roadAddress: json['roadAddress'],
        mapx: json['mapx'],
        mapy: json['mapy'],
      );

  // 2. toJson 메서드 만들기
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'category': category,
      'description': description,
      'telephone': telephone,
      'address': address,
      'roadAddress': roadAddress,
      'mapx': mapx,
      'mapy': mapy,
    };
  }
}
