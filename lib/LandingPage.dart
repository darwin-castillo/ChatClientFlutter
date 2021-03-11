import 'package:chatapp/HomePage.dart';
import 'package:chatapp/SimpleTextField.dart';
import 'package:flutter/material.dart';
import 'package:prompt_dialog/prompt_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String url='http://192.168.0.101:3000';
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar:AppBar()
        body: Container(
            color: Colors.teal,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(15),
                      child: Image.asset(
                        "assets/images/logo_chat.png",
                        width: 100,
                        height: 100,
                      )),
                  SimpleTextFieldWidget(
                    controller: this.controller,
                    hint: "Nombre de usuario",
                  ),
                  InkWell(
                    onTap: ()=>goChatView(controller.text),
                      child: Container(
                        alignment: Alignment.center,
                        margin:EdgeInsets.symmetric(horizontal:10,vertical: 15),
                        padding: EdgeInsets.symmetric(horizontal:10,vertical:15),
                        width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.lime,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("INGRESAR", style: TextStyle( color:Colors.black87, fontSize: 17, fontWeight: FontWeight.bold,)),    
                              )),
                              InkWell(
                                onTap: ()=>setServer(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:<Widget> [
                                  Text(
                                  "Configurar Servidor  ",
                                  style: TextStyle(color:Colors.white,),),
                                  Icon(Icons.settings_input_antenna,
                                  color:Colors.white,
                                  size: 20,
                                  )
                                  
                                  ]),
                              )
                ])));
  }
void goChatView(String username)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString("username",username);
  Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomePage()));
}

  void setServer()async{
  
 SharedPreferences prefs = await SharedPreferences.getInstance();
   
      String _url = prefs.getString("url");
      
        url = _url != null ? _url : url;

 url=   await prompt(
                context,
                initialValue: url,
                title: Text('Configuración'),
                textOK: Text('Aceptar'),
                textCancel: Text('Cancelar'),
                hintText: 'Ingrese dirección del servidor',
                minLines: 1,
                maxLines: 2,
                autoFocus: true,
               
              );


             await prefs.setString("url", url);
  }
}
