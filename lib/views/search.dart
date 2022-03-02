import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interestchat/wid/widg.dart';
import 'package:interestchat/service/database.dart';

import 'package:interestchat/helper/constants.dart';

import 'chat.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEdit = new TextEditingController();

  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  String valueChoose;
  List listitem = [
    'Cricket',
    'Football',
    'Badminton',
    'Tennis'
  ];

  initiateSearch() async {
    if (valueChoose != "") {
      setState(() {
        isLoading = true;
      });
      //Change this to searchByInterest
      await databaseMethods.searchByInterest(valueChoose).then((snapshot) {
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              return userTile(searchResultSnapshot.docs[index].get('name'), searchResultSnapshot.docs[index].get('email'));
            })
        : Container();
  }

  sendMessage(String userName) {
    if (userName != Constants.myName) {
      List<String> users = [
        Constants.myName,
        userName
      ];

      String chatRoomId = getChatRoomId(Constants.myName, userName);

      Map<String, dynamic> chatRoom = {
        "user": users,
        "chatroomid": chatRoomId,
      };

      databaseMethods.addChatRoom(chatRoom, chatRoomId);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chat(
                    chatRoomId: chatRoomId,
                  )));
    } else {
      print("Itself");
    }
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                userEmail,
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //: appBarMAin(context),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    color: Color(0x54FFFFFF),
                    width: MediaQuery.of(context).size.width - 50,
                    child: DropdownButton(
                      hint: Text("Select any interest"),
                      dropdownColor: Colors.black54,
                      icon: Icon(Icons.arrow_drop_down),
                      underline: Container(height: 2, color: Colors.white),
                      iconSize: 36,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      isExpanded: true,
                      value: valueChoose,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue;
                        });
                        initiateSearch();
                      },
                      items: listitem.map((valueitem) {
                        return DropdownMenuItem(
                          value: valueitem,
                          child: Text(valueitem),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            userList()
          ],
        ),
      ),
    );
  }
}
