// To parse this JSON data, do
//
//     final memeResponse = memeResponseFromJson(jsonString);

import 'dart:convert';

MemeResponse memeResponseFromJson(String str) => MemeResponse.fromJson(json.decode(str));

String memeResponseToJson(MemeResponse data) => json.encode(data.toJson());

class MemeResponse {
  String postLink;
  String subreddit;
  String title;
  String url;

  MemeResponse({
    this.postLink,
    this.subreddit,
    this.title,
    this.url,
  });

  factory MemeResponse.fromJson(Map<String, dynamic> json) => new MemeResponse(
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
