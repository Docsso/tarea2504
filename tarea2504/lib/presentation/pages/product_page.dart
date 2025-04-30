
import 'package:flutter/material.dart';
import '../../api/api_service_product.dart';
import '../../models/product.dart';
import '../widgets/product_form.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ApiServiceProduct apiService = ApiServiceProduct();

  Future<List<Product>>? _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _futureProducts = apiService.getProducts();
    });
  }

  void _showForm({Product? product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ProductForm(
        product: product,
        onSubmit: (Product p) async {
          if (product == null) {
            await apiService.createProduct(p);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto creado')));
          } else {
            await apiService.updateProduct(product.id, p);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto actualizado')));
          }
          Navigator.pop(context);
          _loadProducts();
        },
      ),
    );
  }

  void _deleteProduct(String id) async {
    await apiService.deleteProduct(id);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto eliminado')));
    _loadProducts();
  }

  void _showDetails(Product product) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(product.data.toString()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos')),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: \${snapshot.error}'));

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ListTile(
                title: Text(p.name),
                onTap: () => _showDetails(p),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () => _showForm(product: p)),
                    IconButton(icon: Icon(Icons.delete), onPressed: () => _deleteProduct(p.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
