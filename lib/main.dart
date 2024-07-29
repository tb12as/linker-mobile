import 'package:flutter/material.dart';
import 'package:lnkr_syafiq_afifuddin/link_list.dart';

void main() => runApp(const Linker());

class Linker extends StatelessWidget {
  const Linker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Linker',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const LinkList();
  }
}
