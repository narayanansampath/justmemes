// To parse this JSON data, do
//
//     final memeResponse = memeResponseFromJson(jsonString);

import 'dart:convert';

MemeResponse memeResponseFromJson(String str) => MemeResponse.fromJson(json.decode(str));

String memeResponseToJson(MemeResponse data) => json.encode(data.toJson());

class MemeResponse {
  int count;
  List<Meme> memes;

  MemeResponse({
    this.count,
    this.memes,
  });

  factory MemeResponse.fromJson(Map<String, dynamic> json) => new MemeResponse(
    count: json["count"],
    memes: new List<Meme>.from(json["memes"].map((x) => Meme.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "memes": new List<dynamic>.from(memes.map((x) => x.toJson())),
  };
}

class Meme {
  String postLink;
  String subreddit;
  String title;
  String url;
  bool isLiked = false;

  Meme({
    this.postLink,
    this.subreddit,
    this.title,
    this.url,
  });

  factory Meme.fromJson(Map<String, dynamic> json) => new Meme(
    postLink: json["postLink"],
    subreddit: json["subreddit"],
    title: json["title"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "postLink": postLink,
    "subreddit": subreddit,
    "title": title,
    "url": url,
  };
}
