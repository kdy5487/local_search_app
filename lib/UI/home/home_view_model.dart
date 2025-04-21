import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_search_app/data/model/location.dart';
import 'package:local_search_app/data/repository/location_repository.dart';
import 'package:local_search_app/data/repository/vworld_repository.dart';

// 1. 상태 클래스 만들기
class HomeState {
  List<Location> locations;
  HomeState(this.locations);
}

// 2. 뷰모델 만들기 - Notifier 상속
class HomeViewModel extends Notifier<HomeState> {
  @override
  HomeState build() {
    return HomeState([]);
  }

  final _vworldRepository = VworldRepository();
  final locationRepository = LocationRepository();

  //일반 검색
  Future<void> searchLocation(String query) async {
    final locations = await locationRepository.searchLocation(query);
    state = HomeState(locations);
  }

  Future<void> searchByLocation(double lat, double lng) async {
    try {
      //1. 위도,경도로 주소 가져오기
      final addressList = await _vworldRepository.findByLatLng(lat, lng);

      if (addressList.isNotEmpty) {
        final fullAddress = addressList.first; // 첫 번째 주소만 사용
        await searchLocation(fullAddress); // 네이버 검색
      } else {
        throw Exception("주소 결과가 없습니다.");
      }
    } catch (e) {
      debugPrint("현재 위치 주소 검색 실패: $e");
    }
  }
}

// 3. 뷰모델 관리자 만들기 - NotifierProvider 객체
final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeState>(() {
  return HomeViewModel();
});
