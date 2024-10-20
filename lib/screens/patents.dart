import 'package:cuid2/cuid2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tasc/dbms/dbmanager.dart';
import 'package:tasc/dbms/dbcreds.dart';
import 'package:tasc/extras/reusable.dart';
import 'package:tasc/screens/feedback.dart';

class PatentsPage extends StatefulWidget {
  const PatentsPage({super.key});

  @override
  State<PatentsPage> createState() => _PatentsPageState();
}

class _PatentsPageState extends State<PatentsPage>
    with TickerProviderStateMixin {
  late TabController _tabControllerView;
  late TabController _tabControllerEdit;
  late final DataConnection _dataConnection;
  bool _isLoading = true;
  int currentPageIndex = 0;
  final List<String> _editOptions = ["Add", "Delete"];
  final Map<int, List<List<dynamic>>> _patentsByYear = {};
  List<String> _years = [];
  List<List<dynamic>> _patentsInDelete = [];
  String? _errorMessage;

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _patentIdTextController = TextEditingController();
  final TextEditingController _yearTextController = TextEditingController();
  final TextEditingController _authorsTextController = TextEditingController();
  final TextEditingController _inventorsNameTextController =
      TextEditingController();
  final TextEditingController _inventorsAddressTextController =
      TextEditingController();
  final TextEditingController _certificateTextController =
      TextEditingController();
  final TextEditingController _studentTextController = TextEditingController();
  final TextEditingController _facultyTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dataConnection = DataConnection();
    _initializeConnection();
  }

  @override
  void dispose() {
    _tabControllerView.removeListener(_handleTabChange);
    _tabControllerEdit.dispose();
    _tabControllerView.dispose();
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
      await _refreshData();
    } catch (e) {
      _handleError("Error initializing the connection: $e");
    }
  }

  Future<void> _fetchYears() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final completeYearTable = await _dataConnection.fetchData(
          '''SELECT DISTINCT year FROM "Patents" ORDER BY "year" DESC ''');
      List<String> tempYear = [];
      for (var i in completeYearTable) {
        tempYear.add(i[0]);
      }
      setState(() {
        _years = tempYear;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('_fetchYears(): $e');
    }
  }

  Future<void> _fetchPatents(String year) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final placements = await _dataConnection
          .fetchData('''SELECT * FROM "Patents" WHERE year='$year' ''');
      setState(() {
        _patentsByYear[int.parse(year)] = placements;
        // _isLoading = false;
      });
    } catch (e) {
      _handleError('Error fetching patents for year $year: $e');
    }
  }

  Future<void> _fetchPatentsForDeletion() async {
    try {
      final patents = await _dataConnection.fetchData('''
        SELECT * FROM "Patents"
      ''');
      setState(() {
        _patentsInDelete = patents;
      });
    } catch (e) {
      _handleError('Error fetching patents for deletion: $e');
    }
  }

  void _handleTabChange() {
    if (!_tabControllerView.indexIsChanging) {
      final selectedYear = _years[_tabControllerView.index];
      if (!_patentsByYear.containsKey(int.parse(selectedYear))) {
        _fetchPatents(selectedYear);
      }
    }
  }

  void _handleError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  Future<void> uploadPatent() async {
    if (_titleTextController.text != "" &&
        _patentIdTextController.text != "" &&
        _yearTextController.text != "") {
      try {
        await _dataConnection.fetchData('''
      INSERT INTO "Patents" (title, year, id, "patentId") 
      VALUES ('${_titleTextController.text}', '${_yearTextController.text}', '${cuid(25)}', '${_patentIdTextController.text}')
        ''');

        _titleTextController.clear();
        _yearTextController.clear();
        _patentIdTextController.clear();
        _authorsTextController.clear();
        _inventorsNameTextController.clear();
        _inventorsAddressTextController.clear();
        _certificateTextController.clear();
        _studentTextController.clear();
        _facultyTextController.clear();

        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Patent added successfully',
              ),
            ),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error adding patent: $e',
              ),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Something is incomplete in the input data!',
            ),
          ),
        );
      }
    }
  }

  Future<void> deletePatent(String patent) async {
    try {
      await _dataConnection
          .fetchData('''DELETE FROM "Patents" WHERE title='$patent' ''');

      await _refreshData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$patent was deleted',
            ),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error deleting patent: $e',
            ),
          ),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    _isLoading = true;
    await _fetchYears();
    if (_years.isNotEmpty) {
      await _fetchPatents(_years[0]);
    }
    await _fetchPatentsForDeletion();
    _updateTabControllers();
    setState(() {
      _isLoading = false;
    });
  }

  void _updateTabControllers() {
    if (_years.isNotEmpty) {
      _tabControllerView =
          TabController(initialIndex: 0, length: _years.length, vsync: this);
      _tabControllerView.addListener(_handleTabChange);
    }
    _tabControllerEdit = TabController(
        initialIndex: 0, length: _editOptions.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Patents"),
        actions: [
          feedbackBeggar(context)
        ],
        bottom: currentPageIndex == 0 && _years.isNotEmpty
            ? TabBar(
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                splashBorderRadius: BorderRadius.circular(16),
                dividerColor: Colors.transparent,
                controller: _tabControllerView,
                tabs: _years.map((year) => Tab(text: year.toString())).toList(),
              )
            : currentPageIndex == 1
                ? TabBar(
                    tabAlignment: TabAlignment.center,
                    splashBorderRadius: BorderRadius.circular(16),
                    dividerColor: Colors.transparent,
                    controller: _tabControllerEdit,
                    tabs: _editOptions
                        .map((option) => Tab(
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
      if (_years.isEmpty) {
        return const Center(
          child: Text(
            "No patents found",
          ),
        );
      } else {
        return TabBarView(
          controller: _tabControllerView,
          children:
              _years.map((year) => _buildBodyView(int.parse(year))).toList(),
        );
      }
    } else {
      return TabBarView(
        controller: _tabControllerEdit,
        children: _editOptions.map((option) => _buildBodyEdit(option)).toList(),
      );
    }
  }

  Widget _buildBodyView(int year) {
    if (_errorMessage != null) {
      return Center(
        child: Text("Fatal Error\n\n$_errorMessage"),
      );
    } else if (!_patentsByYear.containsKey(year) ||
        _patentsByYear[year]!.isEmpty) {
      return Center(
        child: Text("No Patents for $year"),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: _patentsByYear[year]!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/tasc-app-ae1ac.appspot.com/o/certificates%2F2024%2FEANF.png?alt=media",
                      fit: BoxFit.cover,
                      height: 100,
                    ),
                  ),
                  title: Text(
                    _patentsByYear[year]![index][3],
                  ),
                  subtitle: Text(
                    _patentsByYear[year]![index][2],
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  Widget _buildBodyEdit(String option) {
    if (option == "Add") {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            uploadPatent();
          },
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                  "Title", Icons.title, false, _titleTextController),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Patent ID",
                Icons.insert_drive_file,
                false,
                _patentIdTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Year",
                Icons.numbers,
                false,
                _yearTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Authors",
                Icons.person,
                false,
                _authorsTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Inventors Name",
                Icons.person,
                false,
                _inventorsNameTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Inventors Address",
                Icons.location_on_outlined,
                false,
                _inventorsAddressTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Certificate",
                Icons.card_membership_outlined,
                false,
                _certificateTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Student",
                Icons.card_membership_outlined,
                false,
                _studentTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                "Faculty",
                Icons.card_membership_outlined,
                false,
                _facultyTextController,
              ),
            ),
            // ),
          ],
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _refreshData,
        child: _patentsInDelete.isEmpty
            ? const Center(
                child: Text("No patents to delete"),
              )
            : ListView.builder(
                itemCount: _patentsInDelete.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                        child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/tasc-app-ae1ac.appspot.com/o/certificates%2F2024%2FEANF.png?alt=media",
                          fit: BoxFit.cover,
                          height: 100,
                        ),
                      ),
                      title: Text(
                        _patentsInDelete[index][3].toString(),
                      ),
                      subtitle: Text(
                        _patentsInDelete[index][2].toString(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () async {
                          await deletePatent(
                            _patentsInDelete[index][3].toString(),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
      );
    }
  }
}
