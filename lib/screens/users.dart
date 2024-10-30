import "package:flutter/material.dart";

import "../extras/reusable.dart";
import "feedback.dart";

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late TabController _tabControllerView;
  late TabController _tabControllerEdit;
  int currentPageIndex = 0;
  final List<String> _viewOptions = ["Not Admin", "Admin"];
  final List<String> _editOptions = ["Add", "Delete"];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _tabControllerView = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabControllerEdit = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Users"),
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
            icon: const Icon(Icons.feedback_rounded),
          ),
        ],
        bottom: currentPageIndex == 0
            ? TabBar(
                tabAlignment: TabAlignment.center,
                splashBorderRadius: BorderRadius.circular(16),
                dividerColor: Colors.transparent,
                controller: _tabControllerView,
                tabs: _viewOptions
                    .map((option) => Tab(
                          text: option,
                        ))
                    .toList())
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
      if (/*_users.isEmpty*/ 1 == 1) {
        return const Center(
          child: Text(
            "No Users found",
          ),
        );
      } else {
        return Scaffold(
          body: _buildBodyView(),
        );
      }
    } else {
      return TabBarView(
        controller: _tabControllerEdit,
        children: _editOptions.map((option) => _buildBodyEdit(option)).toList(),
      );
    }
  }

  Widget _buildBodyView() {
    return const Scaffold();
  }

  Widget _buildBodyEdit(String option) {
    if (option == "Add") {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // uploadUser();
          },
          child: const Icon(Icons.add),
        ),
        body: ListView(
          children: const [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //       "Title", Icons.title, false, _titleTextController),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Patent ID",
            //     Icons.insert_drive_file,
            //     false,
            //     _patentIdTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Year",
            //     Icons.numbers,
            //     false,
            //     _yearTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Authors",
            //     Icons.person,
            //     false,
            //     _authorsTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Inventors Name",
            //     Icons.person,
            //     false,
            //     _inventorsNameTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Inventors Address",
            //     Icons.location_on_outlined,
            //     false,
            //     _inventorsAddressTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Certificate",
            //     Icons.card_membership_outlined,
            //     false,
            //     _certificateTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Student",
            //     Icons.card_membership_outlined,
            //     false,
            //     _studentTextController,
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: reusableTextField(
            //     "Faculty",
            //     Icons.card_membership_outlined,
            //     false,
            //     _facultyTextController,
            //   ),
            // ),
            // ),
          ],
        ),
      );
    } else {
      return const Scaffold();
      // return RefreshIndicator(
      //   onRefresh: _refreshData,
      //   child: _patentsInDelete.isEmpty
      //       ? const Center(
      //     child: Text("No patents to delete"),
      //   )
      //       : ListView.builder(
      //     itemCount: _patentsInDelete.length,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         child: ListTile(
      //           leading: ClipRRect(
      //             borderRadius: const BorderRadius.all(
      //               Radius.circular(8.0),
      //             ),
      //             child: Image.network(
      //               "https://firebasestorage.googleapis.com/v0/b/tasc-app-ae1ac.appspot.com/o/certificates%2F2024%2FEANF.png?alt=media",
      //               fit: BoxFit.cover,
      //               height: 100,
      //             ),
      //           ),
      //           title: Text(
      //             _patentsInDelete[index][3].toString(),
      //           ),
      //           subtitle: Text(
      //             _patentsInDelete[index][2].toString(),
      //           ),
      //           trailing: IconButton(
      //             icon: const Icon(
      //               Icons.delete,
      //               color: Colors.deepPurple,
      //             ),
      //             onPressed: () async {
      //               await deletePatent(
      //                 _patentsInDelete[index][3].toString(),
      //               );
      //             },
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // );
    }
  }
}
