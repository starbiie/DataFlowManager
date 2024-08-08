import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../widgets/imagepicktile.dart';
import '../provider/theme_Provider.dart';

class AddPage extends StatefulWidget {
  final Function(String, String, String, String, File?) onAddProduct;

  const AddPage({Key? key, required this.onAddProduct}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String selectedGender = 'Male';
  String selectedDistrict = 'Malappuram';
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _addProduct() {
    final name = _nameController.text;
    final age = _ageController.text;
    if (name.isNotEmpty && age.isNotEmpty) {
      widget.onAddProduct(name, age, selectedGender, selectedDistrict, _image);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name ',
                  filled: true,
                  fillColor: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  hintText: 'Age ',
                  filled: true,
                  fillColor: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedGender,
                    hint: Text("Gender"),
                    items: ['Male', 'Female', 'Other'].map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                              color: context.watch<ThemeProvider>().isDarkMode
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedDistrict,
                    hint: Text("District"),
                    items: [
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
                          style: TextStyle(
                              color: context.watch<ThemeProvider>().isDarkMode
                                  ? Colors.grey
                                  : Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDistrict = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ImagePickTile(
                onPressed: _pickImage,
                subtitile: _image == null ? 'Nothing Selected' : _image!.path,
                title: 'Product Photo',
              ),
              const SizedBox(height: 16),
              Card(elevation: 4,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                      minimumSize:
                          MaterialStatePropertyAll(Size(double.infinity, 50))),
                  onPressed: _addProduct,
                  child: Text(
                    'Add Product',
                    style: TextStyle(
                        color: context.watch<ThemeProvider>().isDarkMode
                            ? Colors.grey
                            : Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
