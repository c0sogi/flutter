class WebtoonIndex {
  WebtoonIndex.fromJson({required Map<String, dynamic> json})
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
  final String title, thumb, id;
}

class WebtoonDetail {
  WebtoonDetail.fromJson({required Map<String, dynamic> json})
      : title = json['title'],
        about = json['about'],
        genre = json['genre'],
        age = json['age'];
  final String title, about, genre, age;
}

class WebtoonEpisode {
  WebtoonEpisode.fromJson({required Map<String, dynamic> json})
      : id = json['id'],
        title = json['title'],
        rating = json['rating'],
        date = json['date'];
  final String id, title, rating, date;
}
