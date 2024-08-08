import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../widgets/imagepicktile.dart';
import '../provider/theme_Provider.dart';

class UpdatePage extends StatefulWidget {
  final String name;
  final String price;
  final String gender;
  final String district;
  final File? image;
  final Function(String, String, String, String, File?) onUpdateProduct;
  final VoidCallback onRemoveProduct;

  const UpdatePage({
    Key? key,
    required this.name,
    required this.price,
    required this.gender,
    required this.district,
    this.image,
    required this.onUpdateProduct,
    required this.onRemoveProduct,
  }) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  String? _selectedGender;
  String? _selectedDistrict;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _priceController = TextEditingController(text: widget.price);
    _selectedGender = widget.gender;
    _selectedDistrict = widget.district;
    _image = widget.image;
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  void _updateProduct() {
    final name = _nameController.text;
    final price = _priceController.text;
    final gender = _selectedGender;
    final district = _selectedDistrict;

    if (name.isNotEmpty && price.isNotEmpty && gender != null && district != null) {
      widget.onUpdateProduct(name, price, gender, district, _image);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () {
              widget.onRemoveProduct();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(style: TextStyle(color:  context.watch<ThemeProvider>().isDarkMode
                  ? Colors.white70
                  : Colors.grey.withOpacity(0.10)),
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Name',
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
              TextFormField(style: TextStyle(color:  context.watch<ThemeProvider>().isDarkMode
                  ? Colors.white70
                  : Colors.grey.withOpacity(0.10)),



                controller: _priceController,
                decoration: InputDecoration(
                  hintText: 'Age',
                  filled: true,
                  fillColor: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),                  enabledBorder: OutlineInputBorder(
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
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Gender',
                  filled: true,
                  fillColor: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                value: _selectedGender,
                onChanged: (String? value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                items: ['Male', 'Female', 'Other'].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,  style: TextStyle(
                      color: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.grey
                      : Colors.black),
                  ));
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'District',
                  filled: true,
                  fillColor: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.black
                      : Colors.grey.withOpacity(0.10),                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                value: _selectedDistrict,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                },
                items: ['Malappuram', 'Kozhikode', 'Wayanad', 'Kannur', 'Kasaragod'].map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,  style: TextStyle(
                      color: context.watch<ThemeProvider>().isDarkMode
                      ? Colors.grey
                      : Colors.black)),
                  );
                }).toList(),
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
                  onPressed: _updateProduct,
                  child: Text(
                    'Update Profile',
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
