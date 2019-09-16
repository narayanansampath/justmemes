import 'dart:async';
import 'dart:convert';

import 'package:just_memes/model/meme_response.dart';
import 'package:just_memes/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://meme-api.herokuapp.com/gimme";

  Future<MemeResponse> fetchMemeFromApi() {
    return _netUtil.get(BASE_URL).then((dynamic res){
      print(res.toString());
      return new MemeResponse.fromJson(res);
    });
  }
}
