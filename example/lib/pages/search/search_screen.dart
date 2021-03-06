/*
 * Developed by Nhan Cao on 10/24/19 5:19 PM.
 * Last modified 10/24/19 5:18 PM.
 * Copyright (c) 2019 Beesight Soft. All rights reserved.
 */

import 'package:bflutter_poc/models/remote/net_cache.dart';
import 'package:bflutter_poc/models/remote/user.dart';
import 'package:bflutter_poc/pages/detail/detail_screen.dart';
import 'package:bflutter_poc/pages/search/search_bloc.dart';
import 'package:bflutter_poc/widgets/bapp_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Search screen
/// Get input from user
/// Call api to get data list
/// Render it
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BAppBar(text: "Search screen"),
      body: _SearchInfo(),
    );
  }
}

class _SearchInfo extends StatefulWidget {
  @override
  ___SearchInfoState createState() => ___SearchInfoState();
}

class ___SearchInfoState extends State<_SearchInfo> {
  final bloc = SearchBloc();

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Row(
              children: <Widget>[
                Icon(Icons.search),
                Expanded(
                  child: TextField(
                    onChanged: bloc.searchUser.push,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Please enter a search term',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Divider(
              color: Colors.black,
            ),
          ),
          Container(
            child: StreamBuilder(
              stream: bloc.loading.stream,
              builder: (context, loading) {
                if (loading.hasData && loading.data) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: bloc.searchUser.stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return Text('No data');
                }
                // @nhancv 10/7/2019: Get data
                NetCache<List<User>> netCacheData = snapshot.data;
                if (!netCacheData.hasData ||
                    (netCacheData?.data)?.length == 0) {
                  return Text('No data');
                }
                List<User> users = netCacheData.data;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FlatButton(
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                users[index].avatarUrl),
                            radius: 20.0,
                          ),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                '${users[index].login} (FromNet: ${netCacheData.fromNet})',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(userBase: users[index])));
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
