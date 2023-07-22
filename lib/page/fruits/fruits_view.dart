import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_g2/model/fruit_model.dart';
import 'package:flutter_g2/service/no_sql_src.dart';
import 'package:uuid/uuid.dart';

class FruitsView extends StatefulWidget {
  const FruitsView({super.key});

  @override
  State<FruitsView> createState() => _FruitsViewState();
}

class _FruitsViewState extends State<FruitsView> {
  final dbService = HiveDbSrc();
  final name = TextEditingController();
  final type = TextEditingController();
  final desc = TextEditingController();
  @override
  void initState() {
    addData();
    super.initState();
  }

  void addData() async {
    try {
      final isSaved = await dbService.saveDataToHiveBoxAsJson(fruits: [
        FruitModel(
            name: 'Apple', type: 'Hol meva', desc: 'Zor meva', id: '1234'),
        FruitModel(
            name: 'Melon', type: 'Hol meva', desc: 'Zor meva', id: '123one'),
        FruitModel(
            name: 'Banana', type: 'Hol meva', desc: 'Zor meva', id: '123490'),
        FruitModel(
            name: 'Lemon', type: 'Hol meva', desc: 'Zor meva', id: '123409'),
        FruitModel(
            name: 'Orange', type: 'Hol meva', desc: 'Zor meva', id: '12347'),
      ], key: 'fruits');
      debugPrint(isSaved.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  void close() async {
    try {
      await dbService.close;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void showCreateFruit({bool? isAdd = true, String? uid}) {
    showCupertinoDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => CupertinoAlertDialog(
              title: const Text('Create Fruit'),
              content: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoTextField(
                      controller: name,
                      placeholder: 'name',
                    ),
                    CupertinoTextField(
                      controller: type,
                      placeholder: 'type',
                    ),
                    CupertinoTextField(
                      controller: desc,
                      placeholder: 'desc',
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () =>
                      isAdd ? onCreateFruits() : onUpdateFruit(uid: uid),
                  child: Text(isAdd! ? 'add' : 'update'),
                )
              ],
            ));
  }

  void onUpdateFruit({required String? uid}) async {
    try {
      if (name.text.isEmpty || type.text.isEmpty || desc.text.isEmpty) return;

      FruitModel? fruit = FruitModel(
          name: name.text, type: type.text, desc: desc.text, id: uid);
      final isUpdated =
          await dbService.updateFruitToData(key: 'fruits', fruit: fruit);
      name.clear();
      type.clear();
      desc.clear();
      if (isUpdated) {
        setState(() {
          Navigator.of(context).pop();
          debugPrint('YANGILNDI');
        });
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  void onCreateFruits() async {
    try {
      if (name.text.isEmpty || type.text.isEmpty || desc.text.isEmpty) return;

      FruitModel? fruit = FruitModel(
          name: name.text,
          type: type.text,
          desc: desc.text,
          id: const Uuid().v1());
      final isCreated =
          await dbService.addFruitToData(key: 'fruits', fruit: fruit);
      name.clear();
      type.clear();
      desc.clear();
      if (isCreated) {
        setState(() {
          Navigator.of(context).pop();
          debugPrint('USER ADDED TO TABLE');
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(builder: (context) {
          return FutureBuilder<List<FruitModel?>>(
              future: dbService.getFruits(key: 'fruits'),
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
                    itemBuilder: (context, index) {
                      final FruitModel fruit = snapshot.data![index]!;
                      return Card(
                        child: ListTile(
                          title: Text(fruit.name!),
                          subtitle: Text(fruit.type!),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showCreateFruit(
                                        isAdd: false, uid: fruit.id);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    final bool isDeleted =
                                        await dbService.deleteDataUsingId(
                                            id: fruit.id, key: 'fruits');
                                    if (isDeleted) {
                                      debugPrint('o\'chirildi');
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.length);
              });
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: showCreateFruit,
          label: const Text('add fruit'),
        ));
  }
}
