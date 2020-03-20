import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medigestion/src/pages/chat_page.dart';
import 'package:medigestion/src/pages/profileDoctor_page.dart';
import 'package:medigestion/src/providers/firebaseUser_provider.dart';
import 'package:medigestion/src/search/search_delegate.dart';

class DoctorListPage extends StatefulWidget {
  static final String routeName = 'doctorList';
  DoctorListPage({Key key}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  final firebaseUserProvider = new FirebaseUserProvider();
  String userId;
  

  @override
  Widget build(BuildContext context) {
    final doctorList = new Container(
      child: new StreamBuilder(
        stream: Firestore.instance.collection('doctors').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildItem(context, snapshot.data.documents[index]),
            );
          } else {
            return new Center(
                child: new CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ));
          }
        },
      ),
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Directorio'),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.search), onPressed: () {
            showSearch(
                context: context,
                delegate: new DataSearch(),
                //query: 'Hola Mundo'
            );
          }),
        ],
      ),
      body: doctorList,
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot document) {
    return new GestureDetector(
        onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new ProfilePage(
                          doctorDocument: document,
                        )));
          },
        child: new Card(
          elevation: 10.0,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            child: new ListTile(
              leading: new Material(
                child: document['photoUrl'] != null
                  ? new CachedNetworkImage(
                    placeholder: (context, url) => new Container(
                    padding: EdgeInsets.all(15.0),
                    width: 50.0,
                    height: 50.0,
                    child: new CircularProgressIndicator(
                      strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                  imageUrl: document['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                )
              : new Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: Colors.grey,
             ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
        ),
        title: new Text(document['name']),
        subtitle:new Text(document['about']),
      )
    )
  );

  }
}
