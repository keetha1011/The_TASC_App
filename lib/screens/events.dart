import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';
import 'package:tasc/extras/reusable.dart';
import 'package:tasc/screens/feedback.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  int currentPageIndex = 0;
  final List<String> _eventCategories = ["Upcoming", "Past"];
  final List<String> _editOptions = ["Add", "Delete"];
  late final DataConnection _dataConnection;
  late TabController _tabControllerView;
  late TabController _tabControllerEdit;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dataConnection = DataConnection();
    _initializeConnection();
  }

  @override
  void dispose() {
    // _tabControllerView.removeListener(_handleTabChange);
    _tabControllerEdit.dispose();
    _tabControllerView.dispose();
    _updateTabControllers();
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
      // await _refreshData();
    } catch (e) {
      _handleError("Error initializing the connection: $e");
    }
  }

  void _handleError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  void _updateTabControllers() {
      _tabControllerView =
          TabController(initialIndex: 0, length: _eventCategories.length, vsync: this);
      // _tabControllerView.addListener(_handleTabChange);
    _tabControllerEdit = TabController(
        initialIndex: 0, length: _editOptions.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [feedbackBeggar(context)],
          centerTitle: true,
          title: const Text("Events"),
          bottom: currentPageIndex == 0
              ? TabBar(
            tabAlignment: TabAlignment.center,
            isScrollable: true,
            splashBorderRadius: BorderRadius.circular(16),
            dividerColor: Colors.transparent,
            controller: _tabControllerView,
            tabs: _eventCategories.map((type) => Tab(text: type)).toList(),
          )
              : currentPageIndex == 1
              ? TabBar(
              tabAlignment: TabAlignment.center,
              splashBorderRadius: BorderRadius.circular(16),
              dividerColor: Colors.transparent,
              controller: _tabControllerEdit,
              tabs: _editOptions
                  .map((option) =>
                  Tab(
                    text: option,
                  ))
                  .toList())
              : null,
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (currentPageIndex == 0) {
      return TabBarView(
        controller: _tabControllerView,
        children:
        _eventCategories.map((type) => _buildBodyView()).toList(),
      );
    }
    else {
      return TabBarView(
        controller: _tabControllerEdit,
        children: _editOptions.map((option) => _buildBodyEdit()).toList(),
      );
    }
  }

  Widget _buildBodyView() {
    return Scaffold();
  }

  Widget _buildBodyEdit() {
    return Scaffold();
  }
}