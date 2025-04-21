import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_search_app/UI/detail/detail_page.dart';
import 'package:local_search_app/UI/home/home_view_model.dart';
import 'package:local_search_app/core/geolocator_helper.dart';
import 'package:local_search_app/data/repository/vworld_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  TextEditingController textEditingController = TextEditingController();

  void dispose() {
    //textEditingController 사용시에는 반드시 dispose 호출해줘야 메모리에서 소거됨.
    textEditingController.dispose();
    super.dispose();
  }

  //검색함수
  void onSearch(String text) {
    // 홈뷰모델의 sercheLocations메서드 호출
    ref.read(homeViewModelProvider.notifier).searchLocation(text);
    print('onSearch 호출됨');
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);

    //빈 화면 터치 시 키보드가 내려가게
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // gps아이콘 터치시 추후 도전 기능 작성
            GestureDetector(
              onTap: () async {
                try {
                  final position = await GeolocatorHelper.getPosition();

                  if (position == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('위치 권한이 필요합니다. 설정에서 허용해주세요.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  await ref
                      .read(homeViewModelProvider.notifier)
                      .searchByLocation(position.latitude, position.longitude);

                  final addressList = await VworldRepository().findByLatLng(
                    position.latitude,
                    position.longitude,
                  );
                  if (addressList.isNotEmpty) {
                    textEditingController.text = addressList.first;
                  }
                } catch (e) {
                  debugPrint('위치 검색 실패: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('위치 정보를 가져올 수 없습니다.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },

              //버튼의 터치영역은 44디바이스 픽셀 이상 추천
              child: Container(
                width: 50,
                height: 50,
                //컨테이너이 배경색이 없으면 자녀위젯에만 터치 이벤트가 적용됨.
                color: Colors.transparent,
                child: Icon(Icons.gps_fixed),
              ),
            ),
          ],
          title: TextField(
            maxLines: 1, //검색 수 하나

            controller: textEditingController,
            onSubmitted: onSearch,
            //꾸미기
            decoration: InputDecoration(
              hintText: '검색어를 입력해 주세요',
              //focus 받을때마다 테두리 동그랗게
              border: MaterialStateOutlineInputBorder.resolveWith((states) {
                if (states.contains(WidgetState.focused)) {
                  return OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  );
                }
                return OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey),
                );
              }),
            ),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: ListView.builder(
            itemCount: homeState.locations.length,
            itemBuilder: (context, index) {
              final location = homeState.locations[index];

              return GestureDetector(
                onTap: () {
                  final url = location.link.trim();

                  try {
                    // https로 시작하는 유효한 링크일 경우만 DetailPage로 이동
                    if (url.startsWith('https')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(location)),
                      );
                    } else {
                      // 링크가 유효하지 않으면 사용자에게 안내 메시지
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('상세 페이지가 제공되지 않는 장소입니다.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    // 예외 발생 시에도 앱이 죽지 않도록 처리
                    debugPrint('상세페이지 이동 중 오류 발생: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('페이지를 열 수 없습니다.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),

                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ), //박스 밖 간격 조정
                  width: double.infinity,

                  padding: const EdgeInsets.all(16), //박스 안 간격 조정
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        location.address,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                      ),

                      SizedBox(height: 4),
                      Text(location.category, maxLines: 2),
                      Text(location.roadAddress, maxLines: 2),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
