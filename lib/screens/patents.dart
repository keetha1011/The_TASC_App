import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';

class PatentsPage extends StatefulWidget {
  const PatentsPage({Key? key}) : super(key: key);

  @override
  State<PatentsPage> createState() => _PatentsPageState();
}

class _PatentsPageState extends State<PatentsPage>
    with SingleTickerProviderStateMixin {
  late final DataConnection _dataConnection;
  Map<int, List<List<dynamic>>> _patentsByYear = {};
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
      await _fetchPatents(_years[0]);
    } catch (e) {
      _handleError("Error initializing the connection: $e");
    }
  }

  Future<void> _fetchPatents(int year) async {
    if (_patentsByYear.containsKey(year)) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results =
          await _dataConnection.fetchData('''SELECT * FROM "Patents" WHERE year='$year' ''');
      setState(() {
        _patentsByYear[year] = results;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('Error fetching patents for year $year: $e');
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _fetchPatents(_years[_tabController.index]);
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
        title: const Text("Patents"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.feedback_rounded))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _years.map((year) => Tab(text: year.toString())).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _years.map((year) => _buildBody(year)).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.view_day_rounded), label: "View"),
          BottomNavigationBarItem(
              icon: Icon(Icons.mode_edit_outline_rounded), label: "Edit")
        ],
      ),
    );
  }

  Widget _buildBody(int year) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return Center(child: Text("Fatal Error\n\n$_errorMessage"));
    } else if (!_patentsByYear.containsKey(year) ||
        _patentsByYear[year]!.isEmpty) {
      return Center(child: Text("No Patents for $year"));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _patentsByYear[year]!.length,
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
                title: Text(_patentsByYear[year]![index][3] as String),
                subtitle: Text(_patentsByYear[year]![index][2] as String),
              ),
            );
          },
        ),
      );
    }
  }
}
