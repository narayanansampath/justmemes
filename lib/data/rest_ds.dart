import 'dart:async';
import 'dart:convert';

import 'package:just_memes/model/meme_response.dart';
import 'package:just_memes/utils/network_util.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "https://meme-api.herokuapp.com/gimme/30";

  //static final BASE_URL = "https://dog.ceo/api/breeds/image/random/50"; dogs

  /*Future<List<MemeResponse>> fetchMemeFromApi() async {
    List<MemeResponse> list = [];
     for(int i=0;i<20;i++){
       await _netUtil.get(BASE_URL).then((dynamic res) {
        list.add(MemeResponse.fromJson(res));
      });
    }
    return list;
  }*/
  Future<MemeResponse> fetchMemeFromApi() {
    return _netUtil.get(BASE_URL).then((dynamic res){
      print(res.toString());
      return new MemeResponse.fromJson(res);
    });
  }
}
