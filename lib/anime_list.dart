import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'anime_detail.dart';

class AnimeList extends StatefulWidget {
  @override
  _AnimeListState createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  var animes;

  void getData() async {
    var data = await getJson();

    setState(() {
      animes = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    getData();

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: true,
              tabs: [  
                Tab(text: 'Animes'),
                Tab(text: 'Animes Assistidos'),
                Tab(text: 'Animes Para Assistir'),
              ]
            ),
            title: Text('Anime List'),
            centerTitle: true,
          ),
          body: TabBarView(children: [
              _animeTemp(),
              _animeAssistidos(),
              _animeParaAssistir(),
            ],
          ),
        ),
      )
    );
  }
  _animeTemp(){
    // return AnimeCell(animes);    
    return GridView.builder(
      padding: EdgeInsets.all(4.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 8.0 / 12.0 ), 
      itemCount: animes == null ? 0 : animes.length,
      itemBuilder: (contex, i){
        return FlatButton(
          child: AnimeCell(animes, i),
          padding: EdgeInsets.all(0.0),
          onPressed: (){
            Navigator.push(context, 
              MaterialPageRoute(builder: (context){
                return AnimeDetail(animes[i]);
              })
            );
          },
        );
      }
      );
  }
}

Future<Map> getJson() async {
  var apiKey = getApiKey();
  var url = 'http://api.themoviedb.org/3/discover/movie?api_key=${apiKey}';
  var response = await http.get(url);
  return json.decode(response.body);
  
}

   class AnimeCell extends StatelessWidget {
    final animes;
    final i;
     var image_url = 'https://image.tmdb.org/t/p/w500/';

    AnimeCell(this.animes, this.i);
    
    @override
    Widget build(BuildContext context) {
      return InkWell(
      
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child:AspectRatio(
              aspectRatio: 18.0 / 1.0,
              child: Image(
                image: NetworkImage(
                  image_url + animes[i]['poster_path'],
                  
                  
                ),fit: BoxFit.cover,width: 70.0, height: 70.0,
              ),
            ),
            ),
            
            new Padding(
              padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    animes[i]['title'],                  
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFFD73C29),
                      fontWeight: FontWeight.bold,
                    ),
                  ),                
                ],
              ),
            ),
          ],
        ),
      ),
    );


    }
   }

  _animeAssistidos(){
    return Container(child: Icon(Icons.directions_bus),);
  }

    _animeParaAssistir(){
    return Container(child: Icon(Icons.directions_bike),);
  }
