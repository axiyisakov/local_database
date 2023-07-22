import 'package:flutter/material.dart';
import 'package:flutter_g2/model/techno_model.dart';
import 'package:flutter_g2/service/app_data_src.dart';

class TechnoView extends StatefulWidget {
  const TechnoView({super.key});

  @override
  State<TechnoView> createState() => _TechnoViewState();
}

class _TechnoViewState extends State<TechnoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<List<Notebook?>?>(
        future: AppDataSrc.getDataFromLocalSecond(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('You have not data in your local'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('You have an error'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LinearProgressIndicator(),
            );
          }

          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Card(
                    child: ListTile(
                      title: Text(snapshot.data![index]!.model!),
                      subtitle: Text(snapshot.data![index]!.company!),
                    ),
                  ));
        },
      )),
    );
  }
}
