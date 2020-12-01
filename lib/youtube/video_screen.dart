import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';



class VideoScreen extends StatefulWidget {
  VideoScreen();

  @override
  VideoScreenState createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  VideoScreenState();



  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
        child: OrientationBuilder(builder:
            (BuildContext context, Orientation orientation) {
          if (orientation == Orientation.landscape) {
            return Scaffold(
              body: FullScreen(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(title: Text('Перелік відеоуроків'),
                backgroundColor: Colors.indigo,),
              floatingActionButton: null,
              body: YoutubeList(),
            );
          }
        }));
  }
}

class YoutubeList extends StatefulWidget {
  @override
  _YoutubeListState createState() => _YoutubeListState();
}

class _YoutubeListState extends State<YoutubeList> {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body:   SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Videos')
                .snapshots(),
            builder:
                (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                reverse: false,
                children: snapshot.data.docs.map((document) {
                  var url = document.data()['url'];
                  print("URL: $url");
                  YoutubePlayerController _controller = YoutubePlayerController(
                    initialVideoId: YoutubePlayer.convertUrlToId(url),
                    flags: YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      disableDragSeek: false,
                      loop: false,
                      isLive: false,
                      forceHD: false,
                    ),
                  );

                  return Center(
                    
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.1,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 5,
                            ),
                            child: Text(document.data()['title'],
                                style: GoogleFonts.arsenal(
                                    fontStyle: FontStyle.normal, fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold)),
                          ),
                          YoutubePlayer(
                            controller: _controller,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
      ),
    );
  }



}


class FullScreen extends StatefulWidget {
  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  YoutubePlayerController _controller;







  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url),
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )

;
  }





  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,


      ),
      builder: (context, player) =>
          Scaffold(

            body: ListView(
              children: [
                player,


              ],
            ),
          ),
    );
  }


}