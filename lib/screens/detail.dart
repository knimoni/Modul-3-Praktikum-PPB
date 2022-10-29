import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mod3_kel30/screens/home.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final int item;
  final String image;
  final num score;
  final String synopsis;
  const DetailPage(
      {Key? key,
      required this.title,
      required this.item,
      required this.image,
      required this.synopsis,
      required this.score})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<List<Show>> shows;
  late Future<List<Manga>> mangas;

  @override
  void initState() {
    super.initState();
    shows = fetchShows(widget.item);
    mangas = fetchMangas(widget.item);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      color: Colors.lightBlueAccent,
                      shadowColor: Colors.lightBlue,
                      elevation: 0,
                      child: Container(
                        height: 700,
                        width: 500,
                        child: Column(
                          children: [
                            Container(
                                height: 300,
                                child: Image.network(widget.image)),
                            Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text('Score: ' + widget.score.toString()),
                            SizedBox(height: 20),
                            Expanded(
                                child: Text('Synopsis: \n' + widget.synopsis)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ));
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

Future<List<Manga>> fetchMangas(int id) async {
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
  final num score;
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

Future<List<Show>> fetchShows(int id) async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
