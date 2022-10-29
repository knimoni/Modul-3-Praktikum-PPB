import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mod3_kel30/screens/profile.dart';
import 'package:mod3_kel30/screens/profiles.dart';

import 'detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Show>> shows;
  late Future<List<Manga>> mangas;

  @override
  void initState() {
    super.initState();
    shows = fetchShows();
    mangas = fetchMangas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyAnimeList')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 15, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Manga of All Time',
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profiles(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.account_box_rounded,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 180.0,
                child: FutureBuilder(
                    builder: (context, AsyncSnapshot<List<Manga>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    item: snapshot.data![index].malId,
                                    title: snapshot.data![index].title,
                                    score: snapshot.data![index].score,
                                    image: snapshot
                                        .data![index].images.jpg.image_url,
                                    synopsis: snapshot.data![index].synopsis,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.lightBlueAccent,
                              shadowColor: Colors.lightBlue,
                              elevation: 0,
                              child: Container(
                                height: 150,
                                width: 100,
                                child: Column(
                                  children: [
                                    Container(
                                        height: 150,
                                        child: Image.network(snapshot
                                            .data![index]
                                            .images
                                            .jpg
                                            .image_url)),
                                    Text(
                                      snapshot.data![index].title,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                    future: mangas),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 10),
              child: Text(
                'Top Anime of All Time',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: SizedBox(
                // height: 200.0,
                child: FutureBuilder<List<Show>>(
                    future: shows,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              ListTile(
                            leading: Image.network(
                              snapshot.data![index].images.jpg.image_url,
                            ),
                            title: Text(snapshot.data![index].title),
                            subtitle:
                                Text(snapshot.data![index].score.toString()),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    item: snapshot.data![index].malId,
                                    title: snapshot.data![index].title,
                                    score: snapshot.data![index].score,
                                    image: snapshot
                                        .data![index].images.jpg.image_url,
                                    synopsis: snapshot.data![index].synopsis,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Manga {
  final int malId;
  final String title;
  Images images;
  final num score;
  final String synopsis;

  Manga({
    required this.malId,
    required this.title,
    required this.images,
    required this.score,
    required this.synopsis,
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
        malId: json['mal_id'],
        title: json['title'],
        images: Images.fromJson(json['images']),
        score: json['score'],
        synopsis: json['synopsis']);
  }

  Map<String, dynamic> toJson() => {
        'mal_id': malId,
        'title': title,
        'images': images,
        'score': score,
        'synopsis': synopsis
      };
}

Future<List<Manga>> fetchMangas() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/manga'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((manga) => Manga.fromJson(manga)).toList();
  } else {
    throw Exception('Failed to load mangas');
  }
}

class Show {
  final int malId;
  final String title;
  Images images;
  final double score;
  final String synopsis;

  Show({
    required this.malId,
    required this.title,
    required this.images,
    required this.score,
    required this.synopsis,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
        malId: json['mal_id'],
        title: json['title'],
        images: Images.fromJson(json['images']),
        score: json['score'],
        synopsis: json['synopsis']);
  }

  Map<String, dynamic> toJson() => {
        'mal_id': malId,
        'title': title,
        'images': images,
        'score': score,
        'synopsis': synopsis
      };
}

class Images {
  final Jpg jpg;

  Images({required this.jpg});
  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: Jpg.fromJson(json['jpg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'jpg': jpg.toJson(),
      };
}

class Jpg {
  String image_url;
  String small_image_url;
  String large_image_url;

  Jpg({
    required this.image_url,
    required this.small_image_url,
    required this.large_image_url,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) {
    return Jpg(
      image_url: json['image_url'],
      small_image_url: json['small_image_url'],
      large_image_url: json['large_image_url'],
    );
  }
  //to json
  Map<String, dynamic> toJson() => {
        'image_url': image_url,
        'small_image_url': small_image_url,
        'large_image_url': large_image_url,
      };
}

Future<List<Show>> fetchShows() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
