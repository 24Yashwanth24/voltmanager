import 'package:flutter/material.dart';
import 'helpers/database_helper.dart';

void main() => runApp(MyApp());

//my app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.visibility),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UseComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.shopping_cart),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalcComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.calculate_sharp),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//my app

// addcomp page
class AddComp extends StatefulWidget {
  const AddComp({super.key});

  @override
  State<AddComp> createState() => AddCompState();
}

class AddCompState extends State<AddComp> {
  final _formKey = GlobalKey<FormState>();
  final rangeController = TextEditingController();
  final valueController = TextEditingController();
  final quantityController = TextEditingController();
  String? _selectedComp;
  bool? _componentTypeornot;
  String? _selectedType;
  int _selectedValue = 0;
  String? _selectedUnit;
  List<String> units = [];
  void _saveData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String cmp = _selectedComp!;
      String typ = _selectedType!;
      int val = _selectedValue;
      int qty = int.parse(quantityController.text);
      String unt = _selectedUnit!;
      var dbHelper = DatabaseHelper.instance;

      // Check if the component already exists
      var existingRow = await dbHelper.queryRowWhere({
        'comp': cmp,
        'type': typ,
        'valu': val,
        'unit': unt,
      });

      if (existingRow != null) {
        // If exists, update the quantity
        int newQty = existingRow['quanty'] + qty;
        await dbHelper.updateRow({
          'id': existingRow['id'], // Assuming your table has an ID column
          'quanty': newQty,
        });
      } else {
        // If it doesn't exist, insert a new row
        await dbHelper.insert({
          'comp': cmp,
          'type': typ,
          'valu': val,
          'unit': unt,
          'quanty': qty,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedComp == 'Resistor') {
      units = ['mΩ', 'Ω', 'kΩ', 'MΩ'];
    } else if (_selectedComp == 'Capacitor') {
      units = ['pF', 'nF', 'μF', 'mF'];
    } else if (_selectedComp == 'Inductor') {
      units = ['μH', 'mH', 'H'];
    } else {
      _selectedUnit = 'Unknown';
      units = ['Unknown'];
    }
    return Scaffold(
      // Add Scaffold here
      appBar: AppBar(title: Text('Add Component')),
      body: SingleChildScrollView(
        // Enables scrolling
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              16.0, // Adapts for keyboard and screen size
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Component'),
                items:
                    [
                      'Resistor',
                      'Capacitor',
                      'Inductor',
                      'Diode',
                      'Transistor',
                      'IC',
                      'LED',
                      'PCB',
                      'Battery',
                      'Others',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    // Handle value change
                    _selectedComp = value;
                    _componentTypeornot = [
                      'Resistor',
                      'Capacitor',
                      'Inductor',
                      'IC',
                    ].contains(value);
                  });
                },
                validator: (value) {
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_componentTypeornot == true)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Component Type'),
                  items:
                      ['SMD', 'Through-Hole'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    // Handle value change
                    _selectedType = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please declare component Type';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Range',
                  hintText: 'Enter component Range',
                ),

                validator: (value) {
                  return null;
                },
                controller: rangeController,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Value',
                        hintText: 'Component Value',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedValue = int.parse(value);
                        });
                      },
                      validator: (value) {
                        return null;
                      },
                      keyboardType: TextInputType.number, // Numeric keyboard
                      controller: valueController,
                    ),
                  ),
                  SizedBox(height: 10, width: 10),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items:
                          units.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) {
                        // Handle value change
                        setState(() {
                          // Update the selected value
                          _selectedUnit =
                              value; // You might want to store this value and use it later
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Component Quantity',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter component Quantity';
                  }
                  return null;
                },
                keyboardType: TextInputType.number, // Numeric keyboard
                controller: quantityController,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save data to database
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Components added to database successfully!!',
                        ),
                      ),
                    );
                    //send the data to db
                    _saveData(context);
                    // reset the form
                    _formKey.currentState!.reset();
                    rangeController.clear();
                    valueController.clear();
                    quantityController.clear();
                  }
                },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//addcomp page

//viewcomp page
class ViewComp extends StatefulWidget {
  const ViewComp({super.key});
  @override
  ViewCompState createState() => ViewCompState();
}

class ViewCompState extends State<ViewComp> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    var dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> rows = await dbHelper.fetchAllRows();
    setState(() {
      dataList = rows;
    });
  }

  Future<void> deleteData(int id) async {
    var dbHelper = DatabaseHelper.instance;
    await dbHelper.database.then((db) {
      db!.delete('my_table', where: 'id = ?', whereArgs: [id]);
    });
    fetchData(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Data')),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    '${dataList[index]['comp']}(${dataList[index]['type']})',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  '${dataList[index]['quanty']}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              '${dataList[index]['valu']}${dataList[index]['unit']}',
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                // Confirm delete action
                bool? confirmDelete = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Confirmation'),
                      content: Text(
                        'Are you sure you want to delete this item?',
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop(false); // Cancel delete
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Navigator.of(context).pop(true); // Confirm delete
                          },
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
                  // Perform delete
                  int id = dataList[index]['id'];
                  await deleteData(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Item deleted successfully')),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

// viewcomp page

//usecomp page
class UseComp extends StatelessWidget {
  const UseComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Sorryii, this page is not developed yet'));
  }
}

//calccomp page
class CalcComp extends StatelessWidget {
  const CalcComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Sorryii, this page is not developed yet'));
  }
}
