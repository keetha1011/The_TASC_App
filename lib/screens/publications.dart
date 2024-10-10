import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage>
    with TickerProviderStateMixin {
  int currentPageIndex = 0;
  late final DataConnection _dataConnection;
  final Map<int, List<List<dynamic>>> _publicationsByYear = {};
  bool _isLoading = true;
  String? _errorMessage;
  late TabController _tabController;
  List<String> _years = [];

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
      await _fetchYears();
      await _fetchPublications(int.parse(_years[0]));
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
      await _dataConnection.fetchData('''SELECT year FROM "Patents" ORDER BY "year" DESC ''');
      List<String> tempYear = [];
      for (var i in completeYearTable) {
        tempYear.add(i[0]);
      }
      setState(() {
        _years = tempYear;
        _tabController =
            TabController(initialIndex: 0, length: _years.length, vsync: this);
      });
    } catch (e) {
      _handleError('_fetchYears(): $e');
    }
  }

  Future<void> _fetchPublications(int year) async {
    if (_publicationsByYear.containsKey(year)) {
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
          .fetchData('''SELECT * FROM "Publication" WHERE year='$year' ''');
      setState(() {
        _publicationsByYear[year] = results;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error fetching patents for year $year: $e');
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _fetchPublications(int.parse(_years[_tabController.index]));
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Publications"),
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
          children: _years.map((year) => _buildBodyView(int.parse(year))).toList(),
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
    } else if (!_publicationsByYear.containsKey(year) ||
        _publicationsByYear[year]!.isEmpty) {
      return Center(child: Text("No Patents for $year"));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _publicationsByYear[year]!.length,
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
                title: Text(_publicationsByYear[year]![index][3] as String),
                subtitle: Text(_publicationsByYear[year]![index][2] as String),
              ),
            );
          },
        ),
      );
    }
  }
}
