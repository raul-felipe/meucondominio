import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

var dropValue = '';

class _RegisterPageState extends State<RegisterPage> {
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

    TextEditingController emailController = TextEditingController();
    final email = TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    TextEditingController idController = TextEditingController();
    final id = TextFormField(
      controller: idController,
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

    TextEditingController password2Controller = TextEditingController();
    final password2 = TextFormField(
      controller: password2Controller,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Repita sua Senha',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    void entrar(context){
      FirebaseFirestore.instance.collection('condominios').doc(dropValue).get().then((DocumentSnapshot documentSnapshot) async {
        if(documentSnapshot.data()['integrantes'][idController.text]!=null){
          if(documentSnapshot.data()['integrantes'][idController.text]['email']==emailController.text){
            if(documentSnapshot.data()['integrantes'][idController.text]['senha']==null){
              await FirebaseFirestore.instance.collection('condominios').doc(dropValue).update({
                'integrantes.${idController.text}.senha':passwordController.text
              }).then((value) {
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Conta registrada")));
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(dropValue),
                    settings: RouteSettings(
                      arguments: HomePage(dropValue)
                    )
                  ),
                );
                return;
              });
            }
            else{
              
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Usuário já cadastrado")));
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
            else if(emailController.text==''){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Email é um campo obrigatório")));
            }
            else if(passwordController.text==''){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Senha é um campo obrigatório")));
            }
            else if(passwordController.text.length<4){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Preencha a senha com pelo menos 4 caracteres")));
            }
            else if(passwordController.text!=password2Controller.text){
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Senhas não conferem")));
            }

            else {
              entrar(context);
            }

          },
          padding: EdgeInsets.all(12),
          color: Colors.lightBlueAccent,
          child: Text('Registrar', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    final forgotLabel = FlatButton(
      child: Text(
        'Já possui uma conta? Clique para Entrar.',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(LoginPage.tag);
      },
    );

    CollectionReference users = FirebaseFirestore.instance.collection('condominios');
    
    var condDropDown = StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
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
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: new Text("Registar", style: TextStyle(color: Colors.white),),
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
                email,
                SizedBox(height: 8.0),
                id,
                SizedBox(height: 8.0),
                password,
                SizedBox(height: 8.0),
                password2,
                SizedBox(height: 24.0),
                Text('Selecione seu condominio:', textAlign: TextAlign.center,),
                condDropDown,
                SizedBox(height: 24.0),
                loginButton(ctx),
                forgotLabel
              ],
            ),
          ),
      ),
    );
  }
}