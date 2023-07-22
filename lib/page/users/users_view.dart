import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_g2/model/user_model.dart';
import 'package:flutter_g2/service/sql_src.dart';
import 'package:uuid/uuid.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final name = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final sqlSrc = SqlService();
  @override
  void dispose() {
    close();
    super.dispose();
  }

  void close() async {
    try {
      await sqlSrc.closeDb();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showCreateUser({bool? isAdd = true, String? uid}) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('Create User'),
              content: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoTextField(
                      controller: name,
                      placeholder: 'name',
                    ),
                    CupertinoTextField(
                      controller: age,
                      placeholder: 'age',
                    ),
                    CupertinoTextField(
                      controller: email,
                      placeholder: 'email',
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed:
                      isAdd! ? onCreateUser : () => onUpdateUser(uid: uid),
                  child: Text(isAdd ? 'add' : 'update'),
                )
              ],
            ));
  }

  void onUpdateUser({required String? uid}) async {
    try {
      if (email.text.isEmpty || age.text.isEmpty || name.text.isEmpty) return;

      UserModel? user = UserModel(
          name: name.text,
          age: int.tryParse(age.text),
          email: email.text,
          id: uid);
      await sqlSrc.updateUserDataToTable(user: user);
      name.clear();
      age.clear();
      email.clear();
      Navigator.of(context).pop();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  void onCreateUser() async {
    try {
      if (email.text.isEmpty || age.text.isEmpty || name.text.isEmpty) return;

      UserModel? user = UserModel(
          name: name.text,
          age: int.tryParse(age.text),
          email: email.text,
          id: const Uuid().v1());
      await sqlSrc.insertDataToTable(user: user);
      name.clear();
      age.clear();
      email.clear();
      Navigator.of(context).pop();
      debugPrint('USER ADDED TO TABLE');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(builder: (context) {
          return FutureBuilder<List<UserModel?>?>(
              future: sqlSrc.getUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('you have not data'),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('you have an error'),
                  );
                }

                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(snapshot.data![index]!.name!),
                            subtitle: Text(snapshot.data![index]!.email!),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      showCreateUser(
                                          isAdd: false,
                                          uid: snapshot.data![index]!.id);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () async {
                                      await sqlSrc.deleteUser(
                                          id: snapshot.data![index]!.id);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.length);
              });
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showCreateUser,
          label: const Text('add user'),
        ));
  }
}
