import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';

class PlacementsPage extends StatefulWidget {
  const PlacementsPage({Key? key}) : super(key: key);

  @override
  State<PlacementsPage> createState() => _PlacementsPageState();
}

class _PlacementsPageState extends State<PlacementsPage>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  late final DataConnection _dataConnection;
  Map<int, List<List<dynamic>>> _placementsByYear = {};
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;
  final List<int> _years = [2024, 2023, 2022, 2021];

  @override
  void initState() {
    super.initState();
    _dataConnection = DataConnection();
    _initializeConnection();
    _tabController =
        TabController(initialIndex: 0, length: _years.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeConnection() async {
    try {
      await _dataConnection.openConnection(
        DBCreds.host,
        DBCreds.database,
        DBCreds.username,
        DBCreds.password,
        DBCreds.port,
      );
      await _fetchPlacements(_years[0]);
    } catch (e) {
      _handleError("Error initializing the connection: $e");
    }
  }

  Future<void> _fetchPlacements(int year) async {
    if (_placementsByYear.containsKey(year)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _dataConnection
          .fetchData('''SELECT * FROM "Placement"''');
      setState(() {
        _placementsByYear[year] = results;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error fetching patents for year $year: $e');
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _fetchPlacements(_years[_tabController.index]);
    }
  }

  void _handleError(String message) {
    print(message);
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Placements"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.feedback_rounded))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _years.map((year) => Tab(text: year.toString())).toList(),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.view_day_outlined),
              selectedIcon: Icon(Icons.view_day_rounded),
              label: "View"),
          NavigationDestination(
              icon: Icon(Icons.mode_edit_rounded),
              selectedIcon: Icon(Icons.mode_edit_outline_rounded),
              label: "Edit")
        ],
      ),
      body: <Widget>[
        TabBarView(
          controller: _tabController,
          children: _years.map((year) => _buildBodyView(year)).toList(),
        ),
        Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            ],
          ),
        )
      ][currentPageIndex],
    );
  }

  Widget _buildBodyView(int year) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text("Fatal Error\n\n$_errorMessage"));
    } else if (!_placementsByYear.containsKey(year) ||
        _placementsByYear[year]!.isEmpty) {
      return Center(child: Text("No Placements for $year"));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _placementsByYear[year]!.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/tasc-app-ae1ac.appspot.com/o/certificates%2F2024%2FEANF.png?alt=media",
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                ),
                title: Text(_placementsByYear[year]![index][3] as String),
                subtitle: Text(_placementsByYear[year]![index][2] as String),
              ),
            );
          },
        ),
      );
    }
  }
}
