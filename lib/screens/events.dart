import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';
import 'package:tasc/screens/feedback.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  late final DataConnection _dataConnection;
  final Map<int, List<List<dynamic>>> _patentsByYear = {};
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;
  List<String> _years = [];

  @override
  void initState() {
    super.initState();
    _dataConnection = DataConnection();
    _initializeConnection();
  }

  @override
  void dispose() {
    // _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeConnection() async {
    try {
      // await _dataConnection.openConnection(
      //   DBCreds.host,
      //   DBCreds.database,
      //   DBCreds.username,
      //   DBCreds.password,
      //   DBCreds.port,
      // );
      // await _fetchYears();
      // _tabController =
      //     TabController(initialIndex: 0, length: _years.length, vsync: this);
      // _tabController.addListener(_handleTabChange);
      // if (_years.isNotEmpty) {
      //   await _fetchPatents(_years[0]);
      // }
    } catch (e) {
      // _handleError("Error initializing the connection: $e");
    }
  }
  //
  // Future<void> _fetchYears() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final completeYearTable = await _dataConnection
  //         .fetchData('''SELECT year FROM "Patents" ORDER BY "year" DESC ''');
  //     List<String> tempYear = [];
  //     for (var i in completeYearTable) {
  //       tempYear.add(i[0]);
  //     }
  //     setState(() {
  //       _years = tempYear;
  //     });
  //   } catch (e) {
  //     _handleError('_fetchYears(): $e');
  //   }
  // }
  //
  // Future<void> _fetchPatents(String year) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   try {
  //     final placements = await _dataConnection
  //         .fetchData('''SELECT * FROM "Patents" WHERE year='$year' ''');
  //     setState(() {
  //       _patentsByYear[int.parse(year)] = placements;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     _handleError('Error fetching patents for year $year: $e');
  //   }
  // }
  //
  // void _handleTabChange() {
  //   if (!_tabController.indexIsChanging) {
  //     final selectedYear = _years[_tabController.index];
  //     if (!_patentsByYear.containsKey(int.parse(selectedYear))) {
  //       _fetchPatents(selectedYear);
  //     }
  //   }
  // }
  //
  // void _handleError(String message) {
  //   setState(() {
  //     _errorMessage = message;
  //     _isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (_years.isEmpty) {
    //   return const Scaffold(
    //     body: Center(child: CircularProgressIndicator()),
    //   );
    // }
    // return Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     title: const Text("Events"),
    //     actions: [
    //       IconButton(
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const FeedbackPage(),
    //             ),
    //           );
    //         },
    //         icon: const Icon(Icons.feedback_outlined),
    //       ),
    //     ],
    //     bottom: TabBar(
    //       controller: _tabController,
    //       tabs: _years.map((year) => Tab(text: year.toString())).toList(),
    //     ),
    //   ),
    //   bottomNavigationBar: NavigationBar(
    //     selectedIndex: currentPageIndex,
    //     onDestinationSelected: (int index) {
    //       setState(() {
    //         currentPageIndex = index;
    //       });
    //     },
    //     destinations: const <Widget>[
    //       NavigationDestination(
    //           icon: Icon(Icons.view_day_outlined),
    //           selectedIcon: Icon(Icons.view_day_rounded),
    //           label: "View"),
    //       NavigationDestination(
    //           icon: Icon(Icons.mode_edit_rounded),
    //           selectedIcon: Icon(Icons.mode_edit_outline_rounded),
    //           label: "Edit")
    //     ],
    //   ),
    //   body: <Widget>[
    //     TabBarView(
    //       controller: _tabController,
    //       children:
    //           _years.map((year) => _buildBodyView(int.parse(year))).toList(),
    //     ),
    //     const Scaffold(
    //       body: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [],
    //       ),
    //     )
    //   ][currentPageIndex],
    // );
    return const Scaffold();
  }
  //
  // Widget _buildBodyView(int year) {
  //   if (_isLoading) {
  //     return const Center(child: CircularProgressIndicator());
  //   } else if (_errorMessage != null) {
  //     return Center(child: Text("Fatal Error\n\n$_errorMessage"));
  //   } else if (!_patentsByYear.containsKey(year) ||
  //       _patentsByYear[year]!.isEmpty) {
  //     return Center(child: Text("No Patents for $year"));
  //   } else {
  //     return Padding(
  //       padding: const EdgeInsets.all(8),
  //       child: ListView.builder(
  //         itemCount: _patentsByYear[year]!.length,
  //         itemBuilder: (context, index) {
  //           return Card(
  //             child: ListTile(
  //               leading: ClipRRect(
  //                 borderRadius: const BorderRadius.all(Radius.circular(8.0)),
  //                 child: Image.network(
  //                   "https://firebasestorage.googleapis.com/v0/b/tasc-app-ae1ac.appspot.com/o/certificates%2F2024%2FEANF.png?alt=media",
  //                   fit: BoxFit.cover,
  //                   height: 100,
  //                 ),
  //               ),
  //               title: Text(_patentsByYear[year]![index][3]),
  //               subtitle: Text(_patentsByYear[year]![index][2]),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }
}
