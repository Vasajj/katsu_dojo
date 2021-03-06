import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';



class PhilosophyScreen extends StatefulWidget {
  PhilosophyScreen();

  @override
  PhilosophyScreenState createState() => PhilosophyScreenState();
}

class PhilosophyScreenState extends State<PhilosophyScreen> {
  PhilosophyScreenState();

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
        backgroundColor: Color(0xff414F69),
        leading: BackButton(
            color: Colors.white
        ),
        title: Text("Новини"),
        centerTitle: true,
      ),
      floatingActionButton: null,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Philosophy').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data.docs.map((document) {
                print(document.data()['title'].toString());
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Color(0xff2f3c54),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        _launchURL(document.data()['title']);
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(document.data()['title'],
                                style: TextStyle(
                                  color: Colors.white54,fontSize: 18.0,
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
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
