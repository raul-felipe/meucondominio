import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'atas_page.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  final String codCondominio;
  HomePage(this.codCondominio);
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {

    var codCondominio = (ModalRoute.of(context).settings.arguments as HomePage).codCondominio;

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: ListView(children: <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.insert_drive_file_rounded),
            title: Text("Atas"),
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => AtaPage(codCondominio),
                  settings: RouteSettings(
                    arguments: AtaPage(codCondominio)
                  )
                ),
              );
            },
          ),
          color: Colors.white54,
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.airport_shuttle),
            title: Text("Entregas"),
          ),
          color: Colors.white54,
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.meeting_room),
            title: Text("Reservas"),
          ),
          color: Colors.white54,
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.family_restroom),
            title: Text("Visitas"),
          ),
          color: Colors.white54,
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.warning),
            title: Text("Avisos"),
          ),
          color: Colors.white54,
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text("Reuniões"),
          ),
          color: Colors.white54,
        ),
      ]),
    );

    final drawer = Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.lightBlueAccent,
              ]),
            ),
            accountName: Text("Seu nome"),
            accountEmail: Text("Seu email"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Conta"),
              subtitle: Text("Acesse e altere os dados da sua conta"),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.info),
              title: Text("Informações"),
              subtitle: Text("Acesse informações sobre o app"),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.help),
              title: Text("Ajuda"),
              subtitle: Text("Tire dúvidas sobre o app"),
              onTap: () {}),
        ],
      ),
    );
    
    CollectionReference timelineReference = FirebaseFirestore.instance.collection('condominios').doc(codCondominio).collection('timeline');

    var timeline = StreamBuilder(
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
                child: Column(children: [
                  ListTile(
                    leading: Icon(Icons.account_circle_sharp),
                    title: Text(document.data()['nome']),
                    subtitle: Text(DateFormat('dd/MM/yyyy – HH:mm').format((document.data()['data'] as Timestamp).toDate())),
                    onTap: (){},
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(document.data()['conteudo'].toString().replaceAll('\\n', '\n')),
                  )
                ],),
              );
            }).toList(),
          ),
        );
      }
    );

  List<Widget> screenBody = <Widget>[
    timeline,
    body
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.white70,
      ),
      body: screenBody.elementAt(_selectedIndex),
      appBar: AppBar(
        title: new Text(
          "Meu Condomínio",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: drawer,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_rows_sharp),
            label: 'Serciços',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      )
    );
  }
}
