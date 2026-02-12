import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Achte Pwodwi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// ==================== SÈVIS STOKAJ ====================
class StockageService {
  static const String _achatsKey = 'achats_list';

  // Ekri yon lyen imaj nan stokaj
  static Future<void> write(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Li lis ki egziste deja
    List<String> achats = prefs.getStringList(_achatsKey) ?? [];
    
    // Ajoute nouvo lyen an si li pa deja nan lis la
    if (!achats.contains(imageUrl)) {
      achats.add(imageUrl);
      await prefs.setStringList(_achatsKey, achats);
    }
  }

  // Li tout lyen imaj ki anrejistre
  static Future<List<String>> readAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_achatsKey) ?? [];
  }

  // Efase yon lyen nan lis la
  static Future<void> delete(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> achats = prefs.getStringList(_achatsKey) ?? [];
    achats.remove(imageUrl);
    await prefs.setStringList(_achatsKey, achats);
  }

  // Efase tout lis la
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_achatsKey);
  }
}

// ==================== MODÈL PWODWI ====================
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
  });
}

// ==================== EKRAN PRENSIPAL ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const ProductsScreen(),
    const ShoppingListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achte Pwodwi'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Pwodwi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Lis Achte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Pwofil',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

// ==================== EKRAN PWODWI YO ====================
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Lis pwodwi ak imaj depi entènèt
  final List<Product> products = [
    Product(
      id: '1',
      name: 'Laptop HP Pavilion',
      imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=500',
      price: 45000,
      description: 'Laptop HP Pavilion 15.6", 8GB RAM, 256GB SSD',
    ),
    Product(
      id: '2',
      name: 'Smartphone Samsung',
      imageUrl: 'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=500',
      price: 35000,
      description: 'Samsung Galaxy A54, 128GB, 5G',
    ),
    Product(
      id: '3',
      name: 'Écouteurs Sans Fil',
      imageUrl: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500',
      price: 2500,
      description: 'Écouteurs Bluetooth, réduction de bruit',
    ),
    Product(
      id: '4',
      name: 'Montre Connectée',
      imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
      price: 8500,
      description: 'Smartwatch, suivi d\'activité, GPS',
    ),
    Product(
      id: '5',
      name: 'Tablette iPad',
      imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500',
      price: 65000,
      description: 'iPad 10ème génération, 64GB',
    ),
    Product(
      id: '6',
      name: 'Clavier Mécanique',
      imageUrl: 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=500',
      price: 3500,
      description: 'Clavier gaming RGB, switches bleus',
    ),
  ];

  // Mesaj konfimasyon
  void _showSuccessMessage(BuildContext context, String productName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✓ $productName ajoute nan lis achte'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Wè',
          textColor: Colors.white,
          onPressed: () {
            // Chanje tab pou ale nan lis achte
            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
            homeState?.setState(() {
              homeState._currentIndex = 1;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onBuy: () async {
                // Anrejistre lyen imaj la nan stokaj lokal
                await StockageService.write(product.imageUrl);
                _showSuccessMessage(context, product.name);
              },
            );
          },
        ),
      ),
    );
  }
}

// ==================== KAT PWODWI ====================
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onBuy;

  const ProductCard({
    super.key,
    required this.product,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imaj pwodwi
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Enfòmasyon pwodwi
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'G${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  // Bouton Achte
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onBuy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Achte',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

// ==================== EKRAN LIS ACHTE ====================
class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<String> _shoppingItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShoppingList();
  }

  Future<void> _loadShoppingList() async {
    setState(() => _isLoading = true);
    final items = await StockageService.readAll();
    setState(() {
      _shoppingItems = items;
      _isLoading = false;
    });
  }

  Future<void> _removeItem(String imageUrl) async {
    await StockageService.delete(imageUrl);
    await _loadShoppingList();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pwodwi retire nan lis la'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Efase tout?'),
        content: const Text('Èske ou sèten ou vle efase tout pwodwi yo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Anile'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Efase', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await StockageService.clearAll();
      await _loadShoppingList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lis Achte',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        '${_shoppingItems.length} pwodwi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (_shoppingItems.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.red),
                      onPressed: _clearAll,
                      tooltip: 'Efase tout',
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            
            // Lis pwodwi yo
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _shoppingItems.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _shoppingItems.length,
                          itemBuilder: (context, index) {
                            final imageUrl = _shoppingItems[index];
                            return ShoppingItemCard(
                              imageUrl: imageUrl,
                              onDelete: () => _removeItem(imageUrl),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Lis achte vid',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ale nan tab Pwodwi pou ajoute atik',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final homeState = context.findAncestorStateOfType<_HomeScreenState>();
              homeState?.setState(() {
                homeState._currentIndex = 0;
              });
            },
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Ale achte'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== KAT PWODWI NAN LIS ACHTE ====================
class ShoppingItemCard extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;

  const ShoppingItemCard({
    super.key,
    required this.imageUrl,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Imaj pwodwi
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Enfòmasyon
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pwodwi ${imageUrl.substring(imageUrl.lastIndexOf('/') + 1, imageUrl.indexOf('?'))}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ajoute nan lis achte',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            // Bouton efase
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== EKRAN PWOFIL ====================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Pwofil Itilizatè',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aplikasyon Achte Pwodwi v1.0',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.shopping_cart, 'Pwodwi nan lis', context),
                  const Divider(),
                  _buildInfoRow(Icons.storage, 'Stokaj lokal', context),
                  const Divider(),
                  _buildInfoRow(Icons.update, 'Dènye mizajou', context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}