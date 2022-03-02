import 'package:flutter/material.dart';
import 'package:interestchat/wid/widg.dart';
import 'package:interestchat/service/auth.dart';
import 'package:interestchat/helper/authenticate.dart';
import 'chat.dart';
import 'search.dart';
import 'signin.dart';
import 'signup.dart';
import 'package:interestchat/service/database.dart';
import 'package:interestchat/helper/helperfunctions.dart';
import 'package:interestchat/helper/constants.dart';

class ChatRoom extends StatefulWidget {
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();

  Stream chatRooms;
  int _currentindex = 0;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.docs[index].get('chatroomid').toString().replaceAll("_", "").replaceFirst(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].get('chatroomid'),
                  );
                })
            : Container();
      },
    );
  }

  @override
  void initState() {
    getUserIn();
    super.initState();
  }

  getUserIn() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/images/logof.png",
          height: 30,
        ),
        elevation: 0.0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              AuthMethods().signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: _currentindex == 0
          ? Container(
              child: chatRoomsList(),
            )
          : SearchScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentindex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat_rounded), label: "Recent Chats", backgroundColor: Colors.blue),
          BottomNavigationBarItem(icon: Icon(Icons.sports), label: "Sport Interests", backgroundColor: Colors.blue),
        ],
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName, @required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(30)),
              child: Text(userName.substring(0, 1), textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300)),
            ),
            SizedBox(
              width: 12,
            ),
            Text(userName, textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'OverpassRegular', fontWeight: FontWeight.w300))
          ],
        ),
      ),
    );
  }
}
