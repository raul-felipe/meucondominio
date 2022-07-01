import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AtaPage extends StatefulWidget {
  static String tag = 'ata-page';
  final String codCondominio;
  AtaPage(this.codCondominio);
  @override
  _AtaPageState createState() => new _AtaPageState();
}

class _AtaPageState extends State<AtaPage> {

  @override
  void initState() {
    Permission.storage.request();
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    FlutterDownloader.initialize();

    var codCondominio = (ModalRoute.of(context).settings.arguments as AtaPage).codCondominio;
    
    CollectionReference timelineReference = FirebaseFirestore.instance.collection('condominios').doc(codCondominio).collection('atas');
    
    var atas = StreamBuilder(
      stream: timelineReference.orderBy('data').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(28.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.lightBlueAccent,
            ]),
          ),
          child: ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document){
              return Card(
                color: Colors.white70,
                child: ListTile(
                  title: Text(document.data()['nome']),
                  trailing: Icon(Icons.download_sharp),
                  onTap: ()async{

                    var _localPath = (await getExternalStorageDirectory()).path+ Platform.pathSeparator + 'Download';
                    final savedDir = Directory(_localPath);
                    bool hasExisted = await savedDir.exists();
                    if (!hasExisted) {
                      savedDir.create();
                    }

                    FlutterDownloader.enqueue(
                      url: document.data()['url'],
                      savedDir: (_localPath)
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      }
    );


    return Scaffold(
      body: atas,
      appBar: AppBar(
        title: new Text(
          "Meu Condomínio",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
    );

  }
}