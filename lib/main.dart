import 'package:flutter/material.dart';
import 'package:sqflite_example/services/database_helper.dart';

void main(List<String> args) {
  runApp(const MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> allDatas = [];
  final TextEditingController _name = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDataBase;
  }

  getDataBase() async {
    allDatas = await databaseHelper.queryAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite Example'),
        actions: [
          IconButton(
              onPressed: () => getDataBase, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextFormField(
                      controller: _name,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter Name: ',
                      )),
                ),
                ElevatedButton(
                    onPressed: () async {
                      int rowId = await databaseHelper.insert({
                        DatabaseHelper.columnName: _name.text,
                      });
                      debugPrint(rowId.toString());
                      _name.clear();
                      getDataBase();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                    ),
                    child: const Text(
                      'Insert',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Datas :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            //
            allDatas.isNotEmpty
                ? ListView.builder(
                    itemCount: allDatas.length,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                        'Id ${allDatas[index][DatabaseHelper.columnName]}',
                      );
                    },
                  )
                : const Text('No Datas Found')
          ],
        ),
      ),
    );
  }
}
