import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register_page.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

var dropValue='';

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {

    final logoText = Text(
      "Meu Condomínio",textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.blue[900],
        fontSize: 32,
        
      ),
      );

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('casa.png'),
      ),
    );

    TextEditingController idController = TextEditingController();
    final id = TextFormField(
      controller: idController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'ID',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    TextEditingController passwordController = TextEditingController();
    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    Future<void> entrar(context) async {
      await FirebaseFirestore.instance.collection('condominios').doc(dropValue).get().then((DocumentSnapshot documentSnapshot) {
        if(documentSnapshot.exists){
          if(documentSnapshot.data()['integrantes'][idController.text]!=null){
            if(documentSnapshot.data()['integrantes'][idController.text]['senha']==passwordController.text){
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => HomePage(dropValue),
                  settings: RouteSettings(
                    arguments: HomePage(dropValue)
                  )
                ),
              );
              return ;
            }
          }
        }
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Dados não conferem")));
      });
    }

    Widget loginButton(context){
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            if(idController.text==''){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("ID é um campo obrigatório")));
            }
            else if(passwordController.text==''){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Senha é um campo obrigatório")));
            }
            else{
              entrar(context);
            }
          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('Entrar', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final forgotLabel = FlatButton(
      child: Text(
        'Não tem conta? Clique para se Registrar.',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(RegisterPage.tag);
      },
    );

    CollectionReference users = FirebaseFirestore.instance.collection('condominios');
    
    var condDropDown = StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo deu errado...');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        if (snapshot.hasData){ 
          if(dropValue=='')
            dropValue = snapshot.data.docs.first.id;
          return DropdownButton(
            value: dropValue,
            items: snapshot.data.docs.map((DocumentSnapshot document) {
              return DropdownMenuItem(
                value: document.id,
                child: Text(document.data()['nome']),
              );
            }).toList(),

            onChanged: (value) {
              setState(() {
                dropValue = value;
              });
            },
          );
        }

        return Text('Algo deu errado...');
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: new Text("Login", style: TextStyle(color: Colors.white),),
      //   centerTitle: true,
      // ),
      body: Builder(
        builder: (ctx) => 
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                logoText,
                SizedBox(height: 48.0),
                logo,
                SizedBox(height: 48.0),
                id,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 24.0),
                Text('Selecione seu condominio:', textAlign: TextAlign.center,),
                condDropDown,
                SizedBox(height: 24.0),
                loginButton(ctx),
                forgotLabel
              ],
            ),
          ),
      )
    );
  }
}