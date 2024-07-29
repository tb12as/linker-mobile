class Link {
  late String link;
  late String shortLink;
  late String title;
  late String code;
  late bool isPrivate;
  late String viewCount;
  late String createdAt;
  late String expireAt;

  Link({
    required this.link,
    required this.shortLink,
    required this.title,
    required this.code,
    required this.isPrivate,
    required this.viewCount,
    required this.createdAt,
    required this.expireAt,
  });

  Link.fromJson(Map<String, dynamic> parsedJson) {
    link = parsedJson['link'];
    shortLink = parsedJson['short_link'];
    title = parsedJson['title'];
    code = parsedJson['code'];
    isPrivate = parsedJson['is_private'];
    viewCount = parsedJson['view_count'];
    createdAt = parsedJson['created_at'];
    expireAt = parsedJson['expire_at'];
  }
}
