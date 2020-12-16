import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen();

  @override
  ArticleScreenState createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  ArticleScreenState();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Не вдається завантажити $url';
    }
  }





  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2f3c54),
      appBar: AppBar(
        title: Text(
          'Віртуальне доджо',
        ),
        centerTitle: true,
        backgroundColor: Color(0xff414f69),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '2');
          },
          child: Icon(
            Icons.album_rounded, color: Colors.white, // add custom icons also
          ),
        ),
      ),
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Videos').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map((document) {
                print(document.data()['url'].toString());
                return Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.0,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xff2f3c54),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(document.data()['url']);
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 7),
                            child: Text(document.data()['title'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blueGrey[50],
                                  fontSize: 18.0,
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: CachedNetworkImage(
                                imageUrl: document.data()['image'],
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}

