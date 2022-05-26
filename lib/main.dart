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
  final TextEditingController _updateName = TextEditingController();
  final TextEditingController _id = TextEditingController();

  // For Validating Forms
  final _insertForm = GlobalKey<FormState>();
  final _updateForm = GlobalKey<FormState>();
  // final insertForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getDataBase();
  }

  Future<void> getDataBase() async {
    allDatas = await databaseHelper.queryAll();
    debugPrint(allDatas.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sqflite Example'),
        actions: [
          IconButton(
              onPressed: () => getDataBase(), icon: const Icon(Icons.refresh))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'INSERTING :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            insertionRow(context),
            sizedBox,
            const Text(
              'UPDATING :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Form(
              key: _updateForm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Name";
                          }
                          return null;
                        },
                        controller: _updateName,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Enter Updated Name: ',
                        )),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter ID";
                          }
                          return null;
                        },
                        controller: _id,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'ID : ',
                        )),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_updateForm.currentState!.validate()) {
                          debugPrint("Validated");
                          int rowId = await databaseHelper.update({
                            DatabaseHelper.columnName: _updateName.text,
                            DatabaseHelper.columnId: _id.text,
                          });
                          debugPrint(rowId.toString());
                          _updateName.clear();
                          _id.clear();
                          getDataBase();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ))
                ],
              ),
            ),
            sizedBox,
            const Text(
              'Datas :',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            dataList()
          ],
        ),
      ),
    );
  }

  insertionRow(BuildContext context) {
    return Form(
      key: _insertForm,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
                controller: _name,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Name";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enter New Name: ',
                )),
          ),
          ElevatedButton(
              onPressed: () => onInsert(),
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
    );
  }

  Future<void> onInsert() async {
    if (_insertForm.currentState!.validate()) {
      int rowId = await databaseHelper.insert({
        DatabaseHelper.columnName: _name.text,
      });
      debugPrint(rowId.toString());
      _name.clear();
      getDataBase();
    }
  }

  StatelessWidget dataList() {
    return allDatas.isNotEmpty
        ? ListView.separated(
            itemCount: allDatas.length,
            padding: const EdgeInsets.symmetric(vertical: 5),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Text.rich(
                TextSpan(text: 'Name: ', children: [
                  TextSpan(
                    text: allDatas[index][DatabaseHelper.columnName],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.purple,
                    ),
                  ),
                  const TextSpan(
                    text: '\t ID : \t',
                  ),
                  TextSpan(
                    text: allDatas[index][DatabaseHelper.columnId].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.green,
                    ),
                  ),
                ]),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          )
        : const Text('No Datas Found');
  }
}
