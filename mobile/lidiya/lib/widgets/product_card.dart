import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final VoidCallback onTap;

  const ProductCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              child: Image.asset('assets/images/shoe.jpg', width: 100, height: 100, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Derby Leather Shoes', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Men\'s shoe', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                Text('\$120', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    ); 
  }
}
