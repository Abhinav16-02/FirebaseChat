import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firbase_chat/CommonClasses/CircularImage.dart';
import 'package:firbase_chat/appconstants.dart';
import 'package:firbase_chat/core/models/friendListInfo.dart';
import 'package:firbase_chat/core/models/userInfo.dart';
import 'package:firbase_chat/profile.dart';
import 'package:firbase_chat/ui/shared/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:firbase_chat/Extensions/Extensions.dart';
import 'package:firbase_chat/service_locator.dart';
import 'package:firbase_chat/core/viewmodels/firCrudModel.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> with GetProfilePic {
  final firModel = locator<FirCrudModel>();
  // GetProfilePic userPic ;
  // UserInfo userinfo = UserInfo();
  _getuserInfo() async {
    var name = await SharedData().getCurrentName();
    var image = await SharedData().getCurrentUserImage();
    // setState(() {
    if (name != null) {
      firModel.name = name;
    }
    if (image != null) {
      //firModel.image = image;
    }
    //  });
  }

//abstract method
  getCurrentProfile(pic) {
    setState(() {
      firModel.image = pic;
    });
  }

  Widget _profileImage(String image) {
    if (image != "" && image != null) {
      return Container(
        //height: 35 ,
        width: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          image: DecorationImage(
            image: image != ""
                ? Image.network(image).image
                : FileImage(File(firModel.image)),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return Image.asset("icons/user_profilr_pic@3x.png");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    _getuserInfo();
  }

  void fetchUserDetails() async {
    await firModel.fetchCurrentUserProfilePic().then((value) {
      setState(() {
        UserInfo user = UserInfo.fromMap(value.data, "");
        firModel.image = user.profilePic;
        firModel.name = user.userName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
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
                  padding: EdgeInsets.only(right: 30, top: 10, bottom: 10),
                  child: InkWell(
                      child: _profileImage(
                          firModel.image), //RoundedImage(model.image, 5, 35),
                      onTap: () {
                        Navigator.pushNamed(context, AppConstants.profile,
                            arguments: {
                              "listner": this,
                              "back": true,
                              "name": firModel.name,
                              "image": firModel.image
                            });
                      })),
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
  final _searchController = TextEditingController();
  SharedData sharedData;
  List<UserInfo> allUsers;
  List<UserInfo> placeHolderUsersList;
  String userID;
  bool search = false;

  @override
  void initState() {
    super.initState();
    _getUserID();
    textChanged();
  }

  textChanged() {
    _searchController.addListener(() {
      if (_searchController.text != "") {
        setState(() {
          search = true;
          List<UserInfo> searchResult = allUsers.where((user) {
            return user.userName.toLowerCase().contains(_searchController.text);
          }).toList();
          //if (searchResult != null){
          placeHolderUsersList = searchResult;
          // }
        });
      } else {
        setState(() {
          search = false;
          placeHolderUsersList = [];
        });
      }
    });
    // setState(() {
    //   search = true;
    //   List<UserInfo> searchResult = allUsers.where((user) {
    //     return user.userName.contains(value);
    //   }).toList();
    //   //if (searchResult != null){
    //   placeHolderUsersList = searchResult;
    //   // }
    // });
  }

  _getUserID() async {
    String userId = await SharedData().getCurrentUIID();
    this.userID = userId;
  }

  setUsersToFriendlists(String selfId, String otherUserId, String chatId) {
    //saving friend to my frient list
    Map othersInfo =
        FriendListInfo(chatId: chatId, userId: otherUserId).tojson();
    // Provider.of<FirCrudModel>(context, listen: false)
    firModel.addToFriendList(othersInfo, selfId);

    //saving myself to friends friend list.

    Map selfInfo = FriendListInfo(chatId: chatId, userId: selfId).tojson();
    //Provider.of<FirCrudModel>(context, listen: false)
    firModel.addToFriendList(selfInfo, otherUserId);
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _searchController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Image.asset("icons/search.png"),
                    hintText: "Search"),
              ),
            )),
        Expanded(
            child: (placeHolderUsersList != null && search == true)
                ? getListView()
                : StreamBuilder(
                    stream: firModel.fetchAllUser(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        allUsers = snapshot.data.documents
                            .map<UserInfo>((doc) =>
                                UserInfo.fromMap(doc.data, doc.documentID))
                            .toList();
                        placeHolderUsersList = allUsers;
                        //List view builder
                        return getListView();
                        // return ListView.builder(
                        //     itemCount: placeHolderUsersList.length,
                        //     itemBuilder: (context, index) {
                        //       UserInfo user = placeHolderUsersList[index];
                        //       if (user.id == userID) {
                        //         //firModel.notify(user.profilePic, user.userName);
                        //         return Container();
                        //       }
                        //       return Column(children: <Widget>[
                        //         Padding(
                        //           padding: EdgeInsets.only(top: 20),
                        //           child: ListTile(
                        //             leading:
                        //                 RoundedImage(user.profilePic, 10, 50),
                        //             // Image.asset(
                        //             //     "icons/user_profilr_pic@3x.png"),
                        //             trailing:
                        //                 //  Padding(
                        //                 //   padding: EdgeInsets.only(top: 0),
                        //                 //   child:
                        //                 Image.asset("icons/next@2x.png",
                        //                     width: 15, height: 15),
                        //             // ),
                        //             title: Text(
                        //                 placeHolderUsersList[index].userName),
                        //             //Row(
                        //             //   mainAxisAlignment:
                        //             //       MainAxisAlignment.spaceBetween,
                        //             //   children: <Widget>[
                        //             //     Text(allUsers[index].userName),
                        //             //     Text("2:10 pm")
                        //             //   ],
                        //             // ),
                        //             // subtitle: Padding(
                        //             //   padding: EdgeInsets.only(top: 10),
                        //             //   child: Row(
                        //             //     children: <Widget>[
                        //             //       Image.asset("icons/seen@3x.png",
                        //             //           width: 15, height: 15),
                        //             //       SizedBox(
                        //             //         width: 10,
                        //             //       ),
                        //             //       Text("Last Message")
                        //             //     ],
                        //             //   ),
                        //             // ),
                        //             onTap: () {
                        //               String uniqueId;

                        //               if (placeHolderUsersList[index]
                        //                       .id
                        //                       .hashCode >=
                        //                   userID.hashCode) {
                        //                 uniqueId =
                        //                     "$userID-${placeHolderUsersList[index].id}";
                        //               } else {
                        //                 uniqueId =
                        //                     "${placeHolderUsersList[index].id}-$userID";
                        //               }
                        //               setUsersToFriendlists(
                        //                   userID,
                        //                   placeHolderUsersList[index].id,
                        //                   uniqueId);

                        //               Navigator.pushNamed(
                        //                   context, AppConstants.chatScreen,
                        //                   arguments: {
                        //                     "chatId": uniqueId,
                        //                     "userId": userID,
                        //                     "userInfo":
                        //                         placeHolderUsersList[index]
                        //                   });
                        //             },
                        //           ),
                        //         ),
                        //         SizedBox(
                        //           height: 10,
                        //         ),
                        //         Container(
                        //           margin: EdgeInsets.only(left: 20, right: 20),
                        //           height: 1,
                        //           color: Colors.grey[300],
                        //         )
                        //       ]);
                        //     });
                      } else {
                        return Text("Fetching");
                      }
                    }))
        //)
      ],
    );
  }

  Widget getListView() {
    return ListView.builder(
        itemCount: placeHolderUsersList.length,
        itemBuilder: (context, index) {
          UserInfo user = placeHolderUsersList[index];
          if (user.id == userID) {
            //firModel.notify(user.profilePic, user.userName);
            return Container();
          }
          return Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ListTile(
                leading: RoundedImage(user.profilePic, 10, 50),
                // Image.asset(
                //     "icons/user_profilr_pic@3x.png"),
                trailing:
                    //  Padding(
                    //   padding: EdgeInsets.only(top: 0),
                    //   child:
                    Image.asset("icons/next@2x.png", width: 15, height: 15),
                // ),
                title: Text(placeHolderUsersList[index].userName),
                //Row(
                //   mainAxisAlignment:
                //       MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(allUsers[index].userName),
                //     Text("2:10 pm")
                //   ],
                // ),
                // subtitle: Padding(
                //   padding: EdgeInsets.only(top: 10),
                //   child: Row(
                //     children: <Widget>[
                //       Image.asset("icons/seen@3x.png",
                //           width: 15, height: 15),
                //       SizedBox(
                //         width: 10,
                //       ),
                //       Text("Last Message")
                //     ],
                //   ),
                // ),
                onTap: () {
                  String uniqueId;

                  if (placeHolderUsersList[index].id.hashCode >=
                      userID.hashCode) {
                    uniqueId = "$userID-${placeHolderUsersList[index].id}";
                  } else {
                    uniqueId = "${placeHolderUsersList[index].id}-$userID";
                  }
                  setUsersToFriendlists(
                      userID, placeHolderUsersList[index].id, uniqueId);

                  Navigator.pushNamed(context, AppConstants.chatScreen,
                      arguments: {
                        "chatId": uniqueId,
                        "userId": userID,
                        "userInfo": placeHolderUsersList[index]
                      });
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
  }
}
