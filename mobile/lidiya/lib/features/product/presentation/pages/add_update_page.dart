import 'package:flutter/material.dart';

class AddUpdatePage extends StatefulWidget {
  const AddUpdatePage({super.key});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final Color boxColor = const Color(0xFFF5F5F5); // white-grey background

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFEFE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Row(
                children: [
                  Icon(Icons.arrow_back_ios_new, color: Colors.black),
                  Spacer(),
                  Text(
                    'Add Product',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Spacer(flex: 2),
                ],
              ),

              const SizedBox(height: 30),

              // Image Upload Box
              GestureDetector(
                onTap: () {
                  // TODO: Handle image picker
                },
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 40, color: Colors.black54),
                        SizedBox(height: 8),
                        Text(
                          'upload image',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Name
              const Text('Name', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ),

              const SizedBox(height: 20),

              // Category
              const Text('Category', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: categoryController,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ),

              const SizedBox(height: 20),

              // Price
              const Text('Price', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration.collapsed(
                          hintText: '',
                        ),
                      ),
                    ),
                    const Text('\$', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description
              const Text('Description', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.topLeft,
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                ),
              ),

              const SizedBox(height: 40),

              // ADD Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: handle add
                },
                child: const Center(child: Text('ADD')),
              ),

              const SizedBox(height: 12),

              // DELETE Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: handle delete
                },
                child: const Center(child: Text('DELETE')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
