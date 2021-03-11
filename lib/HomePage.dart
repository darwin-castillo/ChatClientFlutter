import 'package:chatapp/MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
/**
 * Home page
 */
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MessageModel> messages = <MessageModel>[];
  TextEditingController textController = new TextEditingController();
  String username = "guest_${DateTime.now().millisecondsSinceEpoch}";
  ScrollController scrollController = new ScrollController();

  IO.Socket socket;
  String url = 'http://192.168.0.101:3000';

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
  

  _HomePageState() {
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String _username = prefs.getString("username");
      String _url = prefs.getString("url");
      setState(() {
        username = _username != null ? _username : username;
        url = _url != null ? _url : url;
      });
    });

    // Dart client
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket.connect();

    socket.onConnect((handler) {
      print('connect $handler');
      socket.emit('connection', 'app');
    });
    socket.onConnectError((data) {
      print('socket connect error ${data}');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));

    socket.on('chat:message', (data) {
      print(data);
     


      if (data["id"] != socket.id) {
        setState(() {
          messages.add(MessageModel(
              message: data["message"],
              itsMe: false,
              username: data["username"]));
              
 scrollController.jumpTo(scrollController.position.maxScrollExtent);

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatApp")),
      body: Container(
          child: Column(children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: messages != null ? messages.length : 0,
              controller: scrollController,
              itemBuilder: (_, i) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: messages[i].itsMe
                      ? 
                      Container(
                         alignment: Alignment.centerRight,
                        child:
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(20),
                              )),
                         
                          child: Text("${messages[i].message}",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)))
                      )
                      : 
                       Container(
                         alignment: Alignment.centerLeft,
                        child:
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.lime,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                         
                          child: Text("${messages[i].message}",
                              style: TextStyle(fontSize: 15)))))),
        ),
        Container(
            child: Row(
          children: <Widget>[
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.4, color: Colors.blueGrey)),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: "Escriba un mensaje..."),
              ),
            )),
            InkWell(
                onTap: () {
                  setState(() {
                    messages.add(MessageModel(
                        message: textController.text,
                        username: username,
                        itsMe: true));
   scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    socket.emit('chat:message', {
                      // emite el evento chat:message al servidor
                      "message": textController.text,
                      "username": "$username",
                       "file": '',
                      "id": socket.id
                    });
                    textController.clear();
                  });
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                        color: Colors.lime,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    )))
          ],
        ))
      ])),
    );
  }
}
