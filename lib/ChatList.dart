import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/ChatScreen.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firbase_chat/core/models/friendListInfo.dart';
import 'package:firbase_chat/core/models/userInfo.dart';
import 'package:firbase_chat/ui/shared/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';
import 'package:provider/provider.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:firbase_chat/core/viewmodels/firCrudModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final firModel = locator<FirCrudModel>();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FirCrudModel>(
        create: (context) => firModel,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0.0,
            // backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Chats",
                  style: TextStyle(fontStyle: FontStyle.normal, fontSize: 30)
                      .getStyleBody1(context),
                )
              ],
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: InkWell(
                      child: ClipRRect(
                        child: Image.asset(
                          "icons/user_profilr_pic@3x.png",
                        ).getImageFrom(
                            "https://homepages.cae.wisc.edu/~ece533/images/pool.png",
                            width: 40,
                            height: 45),
                      ),
                      onTap: () {})),
            ],
          ),
          body: AllUserList(),
        ));
  }
}

class AllUserList extends StatefulWidget {
  @override
  _AllUserListState createState() => _AllUserListState();
}

class _AllUserListState extends State<AllUserList> {
  final firModel = locator<FirCrudModel>();
  SharedData sharedData;
  List<UserInfo> allUsers;
  String userID;

  @override
  void initState() {
    super.initState();

    Map currentUserDetails = UserInfo(userName: "Test1").tojson();
    firModel.createNewUser(currentUserDetails).then((value) => userID = value);
  }

  saveUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(userID, userID);
  }

  // Future getUserID() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   userID = pref.getString(userID);
  //   //return pref.getString(userID);
  // }

  setUsersToFriendlists(String selfId, String otherUserId, String chatId) {
    //saving friend to my frient list
    Map othersInfo =
        FriendListInfo(chatId: chatId, userId: otherUserId).tojson();
    Provider.of<FirCrudModel>(context, listen: false)
        .addToFriendList(othersInfo, selfId);

    //saving myself to friends friend list.

    Map selfInfo = FriendListInfo(chatId: chatId, userId: selfId).tojson();
    Provider.of<FirCrudModel>(context, listen: false)
        .addToFriendList(selfInfo, otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    saveUserID();
    //getUserID();
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            height: 60,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      offset: Offset(2, 1),
                      color: Colors.grey[300],
                      blurRadius: 5)
                ],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Image.asset("icons/search.png"),
                    hintText: "Search"),
              ),
            )),
        Expanded(
            child: Consumer<FirCrudModel>(
                builder: (context, model, child) => StreamBuilder(
                    stream: model.fetchAllUser(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        allUsers = snapshot.data.documents
                            .map<UserInfo>((doc) =>
                                UserInfo.fromMap(doc.data, doc.documentID))
                            .toList();
                        return ListView.builder(
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              if (allUsers[index].id == userID) {
                                return Container();
                              }
                              return Column(children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: ListTile(
                                    leading: Image.asset(
                                        "icons/user_profilr_pic@3x.png"),
                                    trailing: Padding(
                                      padding: EdgeInsets.only(top: 30),
                                      child: Image.asset("icons/next@2x.png",
                                          width: 15, height: 15),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(allUsers[index].userName),
                                        Text("2:10 pm")
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Row(
                                        children: <Widget>[
                                          Image.asset("icons/seen@3x.png",
                                              width: 15, height: 15),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Last Message")
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      String uniqueId;
                                      // getUserID().then((value) {
                                      if (allUsers[index].id.hashCode >=
                                          userID.hashCode) {
                                        uniqueId =
                                            "$userID-${allUsers[index].id}";
                                      } else {
                                        uniqueId =
                                            "${allUsers[index].id}-$userID";
                                      }
                                      setUsersToFriendlists(
                                          userID, allUsers[index].id, uniqueId);

                                      Navigator.pushNamed(
                                          context, AppConstants.chatScreen,
                                          arguments: {
                                            "chatId": uniqueId,
                                            "userId": userID
                                          });
                                      // }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  height: 1,
                                  color: Colors.grey[300],
                                )
                              ]);
                            });
                      } else {
                        return Text("Fetching");
                      }
                    })))
      ],
    );
  }
}
