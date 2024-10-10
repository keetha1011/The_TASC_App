import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';

class PlacementsPage extends StatefulWidget {
  const PlacementsPage({super.key});

  @override
  State<PlacementsPage> createState() => _PlacementsPageState();
}

class _PlacementsPageState extends State<PlacementsPage>
    with TickerProviderStateMixin {
  int currentPageIndex = 0;
  late final DataConnection _dataConnection;
  final Map<int, List<List<dynamic>>> _placementsByYear = {};

  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;
  List<String> _years = [];
  Map<int, List<List<dynamic>>> placementData = {};

  @override
  void initState() {
    super.initState();
    _dataConnection = DataConnection();
    _initializeConnection();
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
      await _fetchYears();
      _tabController =
          TabController(initialIndex: 0, length: _years.length, vsync: this);
      _tabController.addListener(_handleTabChange);
      if (_years.isNotEmpty) {
        await _fetchPlacements(_years[0]);
        await _fetchNamesAndCompany(_years[0]);
      }
    } catch (e) {
      _handleError("Error initializing the connection: $e");
    }
  }

  Future<void> _fetchYears() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final completeYearTable =
          await _dataConnection.fetchData('''SELECT * FROM "Year" ORDER BY "year" DESC''');
      List<String> tempYear = [];
      for (var i in completeYearTable) {
        tempYear.add(i[1]);
      }
      setState(() {
        _years = tempYear;
      });
    } catch (e) {
      _handleError('_fetchYears(): $e');
    }
  }

  Future<void> _fetchPlacements(String year) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final placements = await _dataConnection.fetchData(
          '''SELECT * FROM "Placement" WHERE "yearId"=(SELECT "id" FROM "Year" WHERE "year"='$year') ''');
      setState(() {
        _placementsByYear[int.parse(year)] = placements;
      });
    } catch (e) {
      _handleError('Error fetching placements for year $year: $e');
    }
  }

  Future<void> _fetchNamesAndCompany(String year) async {
    try {
      if (_placementsByYear[int.parse(year)] == null) return;

      List<List<dynamic>> tempList = [];
      for (var i in _placementsByYear[int.parse(year)]!) {
        final id = i[2];
        final name = await _dataConnection.fetchData(
            '''SELECT "name" FROM "User" WHERE "id"=(SELECT "userId" FROM "Student" WHERE "id"='${i[2]}') ''');
        final image = await _dataConnection.fetchData(
            '''SELECT "image" FROM "Student" WHERE "id"='${i[2]}' ''');
        // final companies = await _dataConnection.fetchData(
        //     ''' SELECT "" ''');
        tempList.add([id, name[0], image[0]]);
      }
      setState(() {
        _placementsByYear[int.parse(year)] = tempList;
        _isLoading = false;
      });
    } catch (e) {
      _handleError("Error while fetching names and images: $e");
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final selectedYear = _years[_tabController.index];
      if (!_placementsByYear.containsKey(int.parse(selectedYear))) {
        _fetchPlacements(selectedYear).then((_) {
          _fetchNamesAndCompany(selectedYear);
        });
      }
    }
  }

  void _handleError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_years.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          body: Container(),
        ),
      ][currentPageIndex],
    );
  }

  Widget _buildBodyView(String year) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text("Fatal Error\n\n$_errorMessage"));
    } else if (!_placementsByYear.containsKey(int.parse(year)) ||
        _placementsByYear[int.parse(year)]!.isEmpty) {
      return Center(child: Text("No Placements for $year"));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _placementsByYear[int.parse(year)]!.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Image.network(
                    "${_placementsByYear[int.parse(year)]![index][2][0]}",
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                ),
                title: Text(_placementsByYear[int.parse(year)]![index][1][0]),
                subtitle: Text(_placementsByYear[int.parse(year)]![index][1][0]),
              ),
            );
          },
        ),
      );
    }
  }
}
