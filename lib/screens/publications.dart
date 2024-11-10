// import 'package:cuid2/cuid2.dart';
// import 'package:flutter/foundation.dart';
import 'package:cuid2/cuid2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tasc/components/drawer.dart';
import 'home.dart';
import 'feedback.dart';
import '../dbms/dbmanager.dart';
import '../dbms/dbcreds.dart';
import '../extras/reusable.dart';

class PublicationsPage extends StatefulWidget {
  const PublicationsPage({super.key});

  @override
  State<PublicationsPage> createState() => _PublicationsPageState();
}

class _PublicationsPageState extends State<PublicationsPage>
    with TickerProviderStateMixin {
  late TabController _tabControllerView;
  late TabController _tabControllerEdit;
  late final DataConnection _dataConnection;
  bool _isLoading = true;
  int currentPageIndex = 0;
  final List<String> _editOptions = ["Add", "Delete"];
  final Map<int, List<List<dynamic>>> _publicationsByYear = {};
  List<String> _years = [];
  List<List<dynamic>> _publicationsInDelete = [];
  String? _errorMessage;

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _publicationIdTextController =
      TextEditingController();
  final TextEditingController _yearTextController = TextEditingController();
  final TextEditingController _authorsTextController = TextEditingController();
  final TextEditingController _publishDateTextController =
      TextEditingController();
  final TextEditingController _publisherTextController =
      TextEditingController();
  final TextEditingController _journalTextController = TextEditingController();
  final TextEditingController _conferenceTextController =
      TextEditingController();
  final TextEditingController _linkTextController = TextEditingController();
  final TextEditingController _rankingTextController = TextEditingController();
  final TextEditingController _impactFactorTextController =
      TextEditingController();
  final TextEditingController _indexedTextController = TextEditingController();
  final TextEditingController _publisherConferenceTextController =
      TextEditingController();
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
          '''SELECT DISTINCT year FROM "Publication" ORDER BY "year" DESC ''');
      List<String> tempYear = [];
      for (var i in completeYearTable) {
        tempYear.add(i[0].toString());
      }
      setState(() {
        _years = tempYear;
        _isLoading = false;
      });
    } catch (e) {
      _handleError('_fetchYears(): $e');
    }
  }

  Future<void> _fetchPublications(String year) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final publications = await _dataConnection
          .fetchData('''SELECT * FROM "Publication" WHERE year='$year' ''');
      setState(() {
        _publicationsByYear[int.parse(year)] = publications;
        // _isLoading = false;
      });
    } catch (e) {
      _handleError(
        'Error fetching patents for year $year: $e',
      );
    }
  }

  Future<void> uploadPublication() async {
    if (_titleTextController.text != "" &&
        _publicationIdTextController.text != "" &&
        _yearTextController.text != "" &&
        _authorsTextController.text != "" &&
        _publishDateTextController.text != "" &&
        _publisherTextController.text != "" &&
        _journalTextController.text != "" &&
        _conferenceTextController.text != "" &&
        _linkTextController.text != "" &&
        _rankingTextController.text != "" &&
        _impactFactorTextController.text != "" &&
        _indexedTextController.text != "" &&
        _publisherConferenceTextController.text != "") {
      try {
        await _dataConnection.fetchData('''
          INSERT INTO "Publication" (id , authors, title, publish_date, publisher, journal, conference, link, ranking, impact_factor, indexed, publisher_conference, year)
          VALUES ('${cuid(25)}', 
            '{${_authorsTextController.text.split(',').map((e) => e.trim()).join(', ')}}',
            '${_titleTextController.text}',
            '${_publishDateTextController.text}',
            '${_publisherTextController.text}',
            '${_journalTextController.text}',
            '${_conferenceTextController.text}',
            '${_linkTextController.text}',
            '${_rankingTextController.text}',
            '${_impactFactorTextController.text}',
            '${_indexedTextController.text}',
            '${_publisherConferenceTextController.text}',
            '${_yearTextController.text}')
        ''');

        _titleTextController.clear();
        _publicationIdTextController.clear();
        _yearTextController.clear();
        _authorsTextController.clear();
        _publishDateTextController.clear();
        _publisherTextController.clear();
        _journalTextController.clear();
        _conferenceTextController.clear();
        _linkTextController.clear();
        _rankingTextController.clear();
        _impactFactorTextController.clear();
        _indexedTextController.clear();
        _publisherConferenceTextController.clear();
        _facultyTextController.clear();

        await _refreshData();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Publication added successfully')),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding publication: $e')),
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

  Future<void> deletePublication(String publication) async {
    try {
      _dataConnection.fetchData(
          '''DELETE FROM "Publication" WHERE title='$publication' ''');

      await _refreshData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "$publication was deleted",
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
              'Error deleting publication: $e',
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
      await _fetchPublications(_years[0]);
    }
    await _fetchPublicationsForDeletion();
    _updateTabControllers();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchPublicationsForDeletion() async {
    try {
      final publications = await _dataConnection.fetchData('''
        SELECT * FROM "Publication"
      ''');
      setState(() {
        _publicationsInDelete = publications;
      });
    } catch (e) {
      _handleError('Error fetching publications for deletion: $e');
    }
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

  void _handleTabChange() {
    if (!_tabControllerView.indexIsChanging) {
      final selectedYear = _years[_tabControllerView.index];
      if (!_publicationsByYear.containsKey(int.parse(selectedYear))) {
        _fetchPublications(selectedYear);
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
    bool themeMode = MediaQuery.of(context).platformBrightness.name == "light";
    if (_isLoading) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Home()));
          return false;
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Publications",
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FeedbackPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.feedback_rounded,
            ),
          ),
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
      drawer: mainDrawer(context, const PublicationsPage(), themeMode),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.view_day_outlined,
            ),
            selectedIcon: Icon(
              Icons.view_day_rounded,
            ),
            label: "View",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.mode_edit_rounded,
            ),
            selectedIcon: Icon(
              Icons.mode_edit_outline_rounded,
            ),
            label: "Edit",
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (currentPageIndex == 0) {
      if (_years.isEmpty) {
        return const Center(
          child: Text("No publications found"),
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
          children:
              _editOptions.map((option) => _buildBodyEdit(option)).toList());
    }
  }

  Widget _buildBodyView(int year) {
    if (_errorMessage != null) {
      return Center(
        child: Text(
          "Fatal Error\n\n$_errorMessage",
        ),
      );
    } else if (!_publicationsByYear.containsKey(year) ||
        _publicationsByYear[year]!.isEmpty) {
      return Center(
        child: Text("No Publications for $year"),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: _publicationsByYear[year]!.length,
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
                  _publicationsByYear[year]![index][3],
                ),
                subtitle: Text(
                  _publicationsByYear[year]![index][2],
                ),
              ),
            );
          },
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
            uploadPublication();
          },
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Title",
                Icons.title,
                false,
                false,
                _titleTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Publication ID",
                Icons.insert_drive_file,
                false,
                false,
                _publicationIdTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Year",
                Icons.numbers,
                false,
                true,
                _yearTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Authors",
                Icons.people_alt,
                false,
                false,
                _authorsTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Publish Date",
                Icons.date_range_rounded,
                false,
                false,
                _publishDateTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(context, "Publisher", Icons.person,
                  false, false, _publisherTextController),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(context, "Journal", Icons.book_rounded,
                  false, false, _journalTextController),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                  context,
                  "Conference",
                  Icons.card_membership_outlined,
                  false,
                  false,
                  _conferenceTextController),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Link",
                Icons.link,
                false,
                false,
                _linkTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Ranking",
                Icons.precision_manufacturing_rounded,
                false,
                false,
                _rankingTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Impact Factor",
                Icons.factory,
                false,
                false,
                _impactFactorTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Indexed",
                Icons.format_indent_decrease_outlined,
                false,
                false,
                _indexedTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Publisher Conference",
                Icons.confirmation_num_rounded,
                false,
                false,
                _publisherConferenceTextController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: reusableTextField(
                context,
                "Faculty",
                Icons.people_alt,
                false,
                false,
                _facultyTextController,
              ),
            ),
          ],
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: _refreshData,
        child: _publicationsInDelete.isEmpty
            ? const Center(
                child: Text("No publications to delete"),
              )
            : ListView.builder(
                itemCount: _publicationsInDelete.length,
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
                        _publicationsInDelete[index][2].toString(),
                      ),
                      subtitle: Text(
                        _publicationsInDelete[index][12].toString(),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () async {
                          await deletePublication(
                            _publicationsInDelete[index][2].toString(),
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
