import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:local_search_app/data/model/location.dart';

//7bMkcD3yDQY5xq6IFOLc
//UCfn6sycHy
//https://openapi.naver.com/v1/search/local.json
// X-Naver-Client-Id: {애플리케이션 등록 시 발급받은 클라이언트 아이디 값}
//> X-Naver-Client-Secret: {애플리케이션 등록 시 발급받은 클라이언트 시크릿 값}
class DetailPage extends StatelessWidget {
  DetailPage(this.location);
  Location location;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(location.link)),
        initialSettings: InAppWebViewSettings(
          userAgent:
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36,', //안드로이드 세팅
        ),
      ),
    );
  }
}
