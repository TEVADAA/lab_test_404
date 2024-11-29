import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Management App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const ProductFormPage(),
    );
  }
}

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController expiredDateController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController unitPriceInController = TextEditingController();
  final TextEditingController unitPriceOutController = TextEditingController();
  String? selectedCategoryID;

  // Function to handle product addition
  Future<void> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('http://your-server-url/add_product.php'), // Replace with your API URL
        body: productData.map((key, value) => MapEntry(key, value.toString())),
      );

      if (response.statusCode == 200) {
        // Use Future.delayed to ensure context is available
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
        });
      } else {
        // Handle failure response
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add product.')),
          );
        });
      }
    } catch (error) {
      // Handle errors gracefully
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }

  // Function to handle expired date selection
  Future<void> _selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      expiredDateController.text = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter product name' : null,
              ),
              const SizedBox(height: 16),

              // Product Description
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: selectedCategoryID,
                items: ['0001', '0002', '0003']
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text('Category $category'),
                ))
                    .toList(),
                onChanged: (value) => setState(() => selectedCategoryID = value),
                decoration: const InputDecoration(labelText: 'Category ID'),
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // Barcode
              TextFormField(
                controller: barcodeController,
                decoration: const InputDecoration(labelText: 'Barcode'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a barcode' : null,
              ),
              const SizedBox(height: 16),

              // Expiry Date Picker
              TextFormField(
                controller: expiredDateController,
                decoration: const InputDecoration(
                  labelText: 'Expired Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) => value == null || value.isEmpty ? 'Please select a date' : null,
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: qtyController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || int.tryParse(value) == null ? 'Please enter a valid quantity' : null,
              ),
              const SizedBox(height: 16),

              // Unit Price In
              TextFormField(
                controller: unitPriceInController,
                decoration: const InputDecoration(labelText: 'Unit Price In'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Please enter a valid price' : null,
              ),
              const SizedBox(height: 16),

              // Unit Price Out
              TextFormField(
                controller: unitPriceOutController,
                decoration: const InputDecoration(labelText: 'Unit Price Out'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Please enter a valid price' : null,
              ),
              const SizedBox(height: 20),

              // Submit Button
              Builder(
                builder: (context) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          Map<String, dynamic> productData = {
                            'ProductName': nameController.text,
                            'Description': descriptionController.text,
                            'CategoryID': selectedCategoryID,
                            'Barcode': barcodeController.text,
                            'ExpiredDate': expiredDateController.text,
                            'Qty': int.tryParse(qtyController.text),
                            'UnitPriceIn': double.tryParse(unitPriceInController.text),
                            'UnitPriceOut': double.tryParse(unitPriceOutController.text),
                            'ProductImage': 'default.png',
                          };

                          addProduct(productData);
                        }
                      },
                      child: const Text('Add Product'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
