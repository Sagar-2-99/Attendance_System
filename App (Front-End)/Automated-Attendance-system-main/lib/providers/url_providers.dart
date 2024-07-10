import 'package:flutter_riverpod/flutter_riverpod.dart';

class BaseUrlProvider extends StateNotifier<String> {
  BaseUrlProvider() : super("127.0.0.1:5000");


  void changeURL(String newUrl) {
    state = newUrl;
  }

}


final baseUrlProvider = StateNotifierProvider<BaseUrlProvider, String>((ref) => BaseUrlProvider());