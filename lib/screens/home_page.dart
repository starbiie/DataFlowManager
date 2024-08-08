import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../provider/theme_Provider.dart';
import 'addd.dart';
import 'update.dart';

class WorkersHomePage extends StatefulWidget {
  const WorkersHomePage({Key? key}) : super(key: key);

  @override
  State<WorkersHomePage> createState() => _WorkersHomePageState();
}

class _WorkersHomePageState extends State<WorkersHomePage> {
  final List<Map<String, dynamic>> _productRows = [];
  String? selectedGender = 'All Gender';
  String? selectedDistrict = 'All district';
  String? savedName;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedName = prefs.getString('Name');
    });
  }

  void _addProduct(String name, String price, String gender, String district, File? image) {
    setState(() {
      _productRows.add({
        'name': name,
        'age': price,
        'gender': gender,
        'district': district,
        'image': image,
      });
    });
  }

  void _updateProduct(int index, String name, String price, String gender, String district, File? image) {
    setState(() {
      _productRows[index] = {
        'name': name,
        'age': price,
        'gender': gender,
        'district': district,
        'image': image,
      };
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _productRows.removeAt(index);
    });
  }



  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    final filteredRows = _productRows.where((row) {
      final matchesSearchQuery = row['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesGender = selectedGender == 'All Gender' || row['gender'] == selectedGender;
      final matchesDistrict = selectedDistrict == 'All district' || row['district'] == selectedDistrict;
      return matchesSearchQuery && matchesGender && matchesDistrict;
    }).toList();

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: _isSearching
              ? IconButton(
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchQuery = '';
              });
            },
            icon: Icon(Icons.close),
          )
              : null,
          title: _isSearching
              ? TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
              : Text('Workers Home Page'),
          actions: !_isSearching
              ? [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
              icon: Icon(Icons.search_sharp),
            ),
            SizedBox(
              width: screenWidth * 0.35,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;

                  });
                },
                items: ['All Gender', 'Male', 'Female', 'Other'].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 12, color: context.watch<ThemeProvider>().isDarkMode ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              width: screenWidth * 0.38,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'District',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  isDense: true,
                ),
                value: selectedDistrict,
                onChanged: (String? value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
                items: [
                  'All district',
                  'Malappuram',
                  'Kozhikode',
                  'Wayanad',
                  'Kannur',
                  'Kasaragod'
                ].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 12, color: context.watch<ThemeProvider>().isDarkMode ? Colors.white : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            IconButton(
              icon: Icon(context.watch<ThemeProvider>().isDarkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ]
              : null,
          backgroundColor: context.watch<ThemeProvider>().isDarkMode ? Colors.black : Colors.white,
        ),
        body: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRows.length,
                    itemBuilder: (context, index) {
                      final row = filteredRows[index];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: Container(
                            height: 100,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              color: context.watch<ThemeProvider>().isDarkMode ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    row['image'] != null
                                        ? Image.file(
                                      row['image'],
                                      height: 80,
                                      width: 70,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Placeholder(
                                          fallbackHeight: 80,
                                          fallbackWidth: 80,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                        : const Placeholder(
                                      fallbackHeight: 80,
                                      fallbackWidth: 80,
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          Text(
                                            row['name'] ?? 'No Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: context.watch<ThemeProvider>().isDarkMode ? Colors.grey : Colors.black,
                                            ),
                                          ),
                                          Text(
                                            row['age'] ?? 'No age',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: context.watch<ThemeProvider>().isDarkMode ? Colors.grey : Colors.black,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                row['gender'] ?? 'No Gender',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: context.watch<ThemeProvider>().isDarkMode ? Colors.grey : Colors.black,
                                                ),
                                              ),
                                              Text(","),
                                              Text(
                                                row['district'] ?? 'No District',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: context.watch<ThemeProvider>().isDarkMode ? Colors.grey : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdatePage(
                                                name: row['name'] ?? '',
                                                price: row['age'] ?? '',
                                                gender: row['gender'] ?? '',
                                                district: row['district'] ?? '',
                                                image: row['image'],
                                                onUpdateProduct: (name, price, gender, district, image) {
                                                  _updateProduct(index, name, price, gender, district, image);
                                                },
                                                onRemoveProduct: () {
                                                  _removeProduct(index);
                                                },
                                              ),
                                            ),
                                          ).then((result) {
                                            if (result != null && result) {
                                            }
                                          });
                                        },
                                        child: Container(
                                          width: 65,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: const Color(0xff019744),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Edit Profile",
                                              style: TextStyle(fontSize: 10, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Text('Subtotal: $_subtotal'),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
        floatingActionButton: FloatingActionButton(
          elevation: 20,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPage(onAddProduct: _addProduct),
              ),
            ).then((result) {
              if (result != null && result) {
              }
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          backgroundColor: Colors.black38,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
