import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
              // Top Row: Back, Title, Filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Text(
                    'Search Product',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Fixed Leather Box with icons
              Container(
                height: 48,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text('Leather', style: TextStyle(fontSize: 16)),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Product Cards
              const _SearchProductCard(),
              const SizedBox(height: 16),
              const _SearchProductCard(),

              const SizedBox(height: 24),

              // Filter Fields
              const Text('Category'),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Category',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              const Text('Price'),
              const SizedBox(height: 8),
              Slider(
                min: 0,
                max: 500,
                value: 120,
                divisions: 10,
                onChanged: (value) {},
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // TODO: Apply filter
                  },
                  child: const Text('APPLY'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchProductCard extends StatelessWidget {
  const _SearchProductCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/shoe.jpg',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Derby Leather Shoes',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Men's shoe",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$120',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text('4.0'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
