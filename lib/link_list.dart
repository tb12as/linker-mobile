import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lnkr_syafiq_afifuddin/components/link_card.dart';
import 'package:lnkr_syafiq_afifuddin/http_helper.dart';
import 'package:lnkr_syafiq_afifuddin/model/link.dart';

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

  Future<void> _fetchMyLinks() async {
    final response = await http.get('/link/mine');
    final res = json.decode(response.body);

    setState(() {
      _links = res['data'].map((i) => Link.fromJson(i)).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Linker')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8),
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
    );
  }
}
