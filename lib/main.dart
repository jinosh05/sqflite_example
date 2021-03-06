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
  // Instance of DatabaseHelper
  DatabaseHelper databaseHelper = DatabaseHelper.instance;

  // Variable to Store Datas from Database
  List<Map<String, dynamic>> allDatas = [];

  // Text Controllers
  final TextEditingController _name = TextEditingController();
  final TextEditingController _updateName = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _deleteId = TextEditingController();

  // For Validating Forms
  final _insertForm = GlobalKey<FormState>();
  final _updateForm = GlobalKey<FormState>();
  final _deleteForm = GlobalKey<FormState>();

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sqflite Example'),
        actions: [
          IconButton(
              onPressed: () => getDataBase(), icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingText('INSERTING :'),
              insertionRow(context),
              sizedBox,
              headingText('UPDATING :'),
              updationRow(context),
              sizedBox,
              headingText('DELETING :'),
              deletionRow(context),
              const Text(
                'Database :',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              sizedBox,
              dataList()
            ],
          ),
        ),
      ),
    );
  }

  Form deletionRow(BuildContext context) {
    return Form(
      key: _deleteForm,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
                controller: _deleteId,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter ID";
                  }
                  return null;
                },
                style: const TextStyle(
                  fontSize: 16,
                ),
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enter ID to Delete: ',
                )),
          ),
          ElevatedButton(
              onPressed: () => onDelete(),
              style: ElevatedButton.styleFrom(
                primary: Colors.pink,
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 14,
                ),
              ))
        ],
      ),
    );
  }

  Future<void> onDelete() async {
    if (_deleteForm.currentState!.validate()) {
      int rowId = await databaseHelper.delete(int.parse(_deleteId.text));
      debugPrint(rowId.toString());
      _deleteId.clear();
      getDataBase();
    }
  }

  Text headingText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }

  Form updationRow(BuildContext context) {
    return Form(
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
              onPressed: () => onUpdate(),
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
    );
  }

  Future<void> onUpdate() async {
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
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 5),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(text: 'Name : ', children: [
                      TextSpan(
                        text: allDatas[index][DatabaseHelper.columnName],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.purple,
                        ),
                      ),
                    ]),
                  ),
                  Text.rich(
                    TextSpan(text: '\t ID : \t', children: [
                      TextSpan(
                        text:
                            allDatas[index][DatabaseHelper.columnId].toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.green,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox()
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 5,
              );
            },
          )
        : const Text(
            'No Datas Found',
            style: TextStyle(
              fontSize: 15,
              color: Colors.deepOrange,
            ),
          );
  }
}
