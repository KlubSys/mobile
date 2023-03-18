import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/data/repositories/klub-api.repository.dart';
import 'package:klub/presentation/screens/klub/bloc_requests.screen.dart';
import 'package:klub/presentation/screens/klub/blocs.screen.dart';
import 'package:klub/presentation/screens/klub/download.screen.dart';
import 'package:klub/presentation/screens/klub/files.screen.dart';
import 'package:klub/presentation/screens/klub/upload_file.screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2;

  static final List<String> titles = <String>[
    "Upload",
    "Downloads",
    "Files",
    "Blocs",
    "Bloc Requests"
  ];
  static final List<Widget> _widgetOptions = <Widget>[
    const UploadScreen(),
    const DownloadsScreen(),
    const FilesScreen(),
    const BlocsScreen(),
    const BlocRequestsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(titles[_selectedIndex]),
        ),
        body: BlocProvider<KlubCubit>(
            create: (context) =>
                KlubCubit(RepositoryProvider.of<KlubApiRepository>(context)),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: _widgetOptions.elementAt(_selectedIndex),
            )) /*MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ContractProvider()),
              ChangeNotifierProvider(create: (_) => UsagerProvider()),
              ChangeNotifierProvider(create: (_) => PaymentsProvider()),

            ],
            child:   _widgetOptions.elementAt(_selectedIndex)
        )*/
        ,
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.blueAccent, Colors.lightBlueAccent])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 50),
                  Text(
                    "Klub",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "---",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20)
                ],
              )),
          ListTile(
              leading: const Icon(Icons.checklist_rtl_rounded),
              title: const Text("Upload"),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              }),
          ListTile(
              leading: const Icon(Icons.checklist_rtl_rounded),
              title: const Text("Downloads"),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              }),
          ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("Files"),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              }),
          ListTile(
              leading: const Icon(Icons.add_card),
              title: const Text("Blocs"),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              }),
          ListTile(
              leading: const Icon(Icons.payments),
              title: const Text("Bloc Requests"),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(4);
              }),
        ])));
  }
}
