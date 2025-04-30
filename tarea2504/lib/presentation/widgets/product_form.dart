
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? product;
  final Function(Product) onSubmit;

  ProductForm({this.product, required this.onSubmit});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dataController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _dataController = TextEditingController(text: widget.product?.data.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16, right: 16, top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Wrap(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            TextFormField(
              controller: _dataController,
              decoration: InputDecoration(labelText: 'Data (JSON)'),
              validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                try {
                  final data = Map<String, dynamic>.from(jsonDecode(_dataController.text));
                  final product = Product(
                    id: widget.product?.id ?? '',
                    name: _nameController.text,
                    data: data,
                  );
                  widget.onSubmit(product);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error en el formato JSON')));
                }
              },
              child: Text(widget.product == null ? 'Crear' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
