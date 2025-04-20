import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();

  void dispose() {
    //textEditingController 사용시에는 반드시 dispose 호출해줘야 메모리에서 소거됨.
    textEditingController.dispose();
    super.dispose();
  }

  //검색함수
  void onSearch(String text) {
    //
    print('onSearch 호출됨');
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () {},
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

        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(20), //박스 밖 간격 조정
              width: double.infinity,
              height: 110,
              padding: const EdgeInsets.all(16), //박스 안 간격 조정
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'title: 삼성 1동 주민센터',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text('category'),
                  Text('roadAddress'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}