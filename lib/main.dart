import 'package:flutter/material.dart';

void main() {
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce Mock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _authenticate() {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: _toggleAuthMode,
              child: Text(_isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<String> _categories = ['Electronics', 'Clothing', 'Home', 'Books', 'Beauty'];

  final List<Map<String, String>> _products = [
    {'title': 'Smartphone', 'price': '\$999', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Laptop', 'price': '\$1299', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Headphones', 'price': '\$199', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Sneakers', 'price': '\$149', 'image': 'https://via.placeholder.com/150'},
    {'title': 'Blender', 'price': '\$79', 'image': 'https://via.placeholder.com/150'},
  ];

  List<Map<String, String>> _cart = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _addToCart(Map<String, String> product) {
    setState(() {
      _cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['title']} added to cart')),
    );
  }

  void _viewCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartPage(cart: _cart),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
            onTap: _viewCart,
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.all(10),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  product['image']!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product['title']!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                product['price']!,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
              ElevatedButton(
                onPressed: () => _addToCart(product),
                child: Text('Add to Cart'),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('E-commerce Mock'),
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: _selectedIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _viewCart,
        child: Icon(Icons.shopping_cart),
        tooltip: 'View Cart',
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final List<Map<String, String>> cart;

  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: cart.isEmpty
          ? Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          return ListTile(
            leading: Image.network(product['image']!),
            title: Text(product['title']!),
            subtitle: Text(product['price']!),
          );
        },
      ),
    );
  }
}
