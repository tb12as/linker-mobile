import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lnkr_syafiq_afifuddin/components/link_card.dart';
import 'package:lnkr_syafiq_afifuddin/http_helper.dart';
import 'package:lnkr_syafiq_afifuddin/model/link.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LinkList extends StatefulWidget {
  const LinkList({super.key});

  @override
  State<LinkList> createState() => LinkListState();
}

class LinkListState extends State<LinkList> {
  final HttpHelper http = HttpHelper();

  @override
  void initState() {
    super.initState();
    _fetchMyLinks();
  }

  List<dynamic> _links = [];
  bool _isLoading = true;
  int _page = 1;
  bool _isEnd = false;

  Future<void> _fetchMyLinks() async {
    _isLoading = _page == 1;
    setState(() => {});

    final response = await http.get('/link/mine?page=$_page');
    final res = json.decode(response.body);

    List data = res['data'].map((i) => Link.fromJson(i)).toList();
    _isEnd = data.isEmpty;
    if (_page == 1) {
      _links = data;
    } else {
      _links = [..._links, ...data];
    }

    _isLoading = false;
    setState(() => {});
  }

  // for smart refresher
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _page = 1;
    await _fetchMyLinks();
    _refreshController.refreshCompleted();
  }

  void _onLoad() async {
    _page += 1;
    await _fetchMyLinks();
    _refreshController.loadComplete();
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Linker'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'logout') {
                _logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8),
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: !_isEnd,
                header: const WaterDropMaterialHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoad,
                child: ListView.builder(
                    itemCount: (_links.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final itemIndex1 = index * 2;
                      final itemIndex2 = itemIndex1 + 1;

                      return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: LinkCard(_links[itemIndex1]),
                            ),
                            if (itemIndex2 < _links.length)
                              Expanded(
                                child: LinkCard(_links[itemIndex2]),
                              )
                          ]);
                    }),
              ),
            ),
    );
  }
}
