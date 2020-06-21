import 'package:flutter/material.dart';
import 'dart:async';
import 'update_userinfo_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mcfreshchat/mcfreshchat.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Item> items = [
    Item(
        text: 'Update User Info',
        onTap: (context) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateUserInfoScreen()));
        }),
    Item(
        text: 'Identify User',
        onTap: (context) async {
          LocalStorage storage = LocalStorage('example_storage');
          //Navigate to update email ID and name screen
          String uid = await storage.getItem('uid');
          String restoreId = await storage.getItem('restoreId');
          if (uid == null) {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Please update the user info")));
          } else if (restoreId == null) {
            String newRestoreId =
            await Mcfreshchat.identifyUser(externalID: uid);
            await storage.setItem('restoreId', newRestoreId);
          } else {
            await Mcfreshchat.identifyUser(
                externalID: uid, restoreID: restoreId);
          }
        }),
    Item(
        text: 'Show Conversation',
        onTap: (context) async {
          await Mcfreshchat.showConversations();
        }),
    Item(
        text: 'Show FAQs',
        onTap: (context) async {
          await Mcfreshchat.showFAQs();
        }),
    Item(
        text: 'Get Unread Message Count',
        onTap: (context) async {
          dynamic val = await Mcfreshchat.getUnreadMsgCount();
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Message count $val")));
        }),
    Item(
        text: 'Setup Notifications',
        onTap: () {
          //Navigate to update email ID and name screen
        }),
    Item(
        text: 'Reset User',
        onTap: (context) async {
          await Mcfreshchat.resetUser();
        }),
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await Mcfreshchat.init(
        appID: "6e164410-ac26-4aea-ac6a-4c0f501ff51d", appKey: "0c881a36-a5ae-401c-a9a0-4b69eef461d0");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Mindcoopers Freshchat Example App'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemBuilder: (context, i) {
            return ListItem(
              item: items[i].text,
              onTap: () => items[i].onTap(context),
            );
          },
          itemCount: items.length,
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  String item;
  Function onTap;

  ListItem({@required String item, @required Function onTap}) {
    this.item = item;
    this.onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              new CircleAvatar(
                child: Text('A'),
              ),
              Padding(padding: EdgeInsets.only(right: 10.0)),
              Text(item)
            ],
          ),
        ),
      ),
    );
  }
}

class Item {
  String text;
  Function onTap;

  Item({@required String text, @required Function onTap}) {
    this.text = text;
    this.onTap = onTap;
  }
}