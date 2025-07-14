import 'dart:io';

class Product {
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  // Getters
  String get name => _name;
  String get description => _description;
  double get price => _price;

  // Setters
  set name(String prodName) => _name = prodName;
  set description(String prodDescription) => _description = prodDescription;
  set price(double prodPrice) => _price = prodPrice;

  void display() {
    print('Name: $_name');
    print('Description: $_description');
    print('Price: \$$_price');
  }
}

class ProductManager {
  List<Product> _products = [];

  // Add a new product
  void add() {
    stdout.write('Enter product name: ');
    String? name = stdin.readLineSync();

    stdout.write('Enter product description: ');
    String? description = stdin.readLineSync();

    stdout.write('Enter product price: ');
    double price = double.parse(stdin.readLineSync()!);

    Product product = Product(name!, description!, price);
    _products.add(product);

    print('Product added successfully!');
  }

  // View all products
  void viewAll() {
    if (_products.isEmpty) {
      print(' No products available!');
    } else {
      for (int i = 0; i < _products.length; i++) {
        print('\nProduct ${i + 1}:');
        _products[i].display();
      }
    }
  }

  // View a single product by index
  void viewSingle() {
    stdout.write('Enter product index  ');
    int index = int.parse(stdin.readLineSync()!);

    if (index > 0 && index <= _products.length) {
      _products[index - 1].display();
    } else {
      print('Product not found!');
    }
  }

  // Edit a product by index
  void edit() {
    stdout.write('Enter product index to edit: ');
    int index = int.parse(stdin.readLineSync()!);

    if (index > 0 && index <= _products.length) {
      Product product = _products[index - 1];

      stdout.write('Enter new name (leave blank to keep "${product.name}"): ');
      String? newName = stdin.readLineSync();
      if (newName != null && newName.isNotEmpty) {
        product.name = newName;
      }

      stdout.write(
        'Enter new description (leave blank to keep "${product.description}"): ',
      );
      String? newDescription = stdin.readLineSync();
      if (newDescription != null && newDescription.isNotEmpty) {
        product.description = newDescription;
      }

      stdout.write(
        'Enter new price (leave blank to keep "${product.price}"): ',
      );
      String? priceInput = stdin.readLineSync();
      if (priceInput != null && priceInput.isNotEmpty) {
        double newPrice = double.parse(priceInput);
        product.price = newPrice;
      }

      print('Product updated successfully!');
    } else {
      print(' Product not found!');
    }
  }

  // Delete a product by index
  void delet() {
    stdout.write('Enter product index to delete: ');
    int index = int.parse(stdin.readLineSync()!);

    if (index > 0 && index <= _products.length) {
      _products.removeAt(index - 1);
      print(' Product deleted successfully.');
    } else {
      print(' Product not found.');
    }
  }
}

void main() {
  ProductManager manager = ProductManager();

  while (true) {
    print('    Dart CLI eCommerce  ');
    print('1. Add Product');
    print('2. View All Products');
    print('3. View Single Product');
    print('4. Edit Product');
    print('5. Delete Product');
    print('6. Exit');
    stdout.write('Choose an option: ');

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        manager.add();
        break;
      case '2':
        manager.viewAll();
        break;
      case '3':
        manager.viewSingle();
        break;
      case '4':
        manager.edit();
        break;
      case '5':
        manager.delet();
        break;
      case '6':
        print('Exiting program...');
        return;
      default:
        print(' Invalid,  please try again.');
    }
  }
}
