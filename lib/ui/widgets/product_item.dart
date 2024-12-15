import 'package:flutter/material.dart';
import 'package:module14_assignments/models/product.dart';
import 'package:module14_assignments/ui/screens/update_product_screen.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key, required this.product});

  final Product product;
  static const String name = '/delete-product';

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _deleteProductInProgress = false;
  List<Product> productList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        widget.product.image ?? '',
        width: 40,
      ),
      title: Text(widget.product.productName ?? 'Unknown'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${widget.product.productCode ?? 'Unknown'}'),
          Text('Quantity: ${widget.product.quantity ?? 'Unknown'}'),
          Text('Price: ${widget.product.unitPrice ?? 'Unknown'}'),
          Text('Total Price: ${widget.product.totalPrice ?? 'Unknown'}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: (){
              // TODO: complete the delete function
                    _deleteProductInList();
                  },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: widget.product,
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }

  /// need to refresh the screen to See the effect of deletion
  Future<void> _deleteProductInList() async {
    setState(() {
      _deleteProductInProgress = true;
    });

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/${widget.product.id}');

    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      if (decodedData['status'] == 'success') {
        setState(() {
          productList.removeWhere((p) => p.id == widget.product.id);
        });
      } else {
        print('Deletion failed: ${decodedData['message']}');
      }
    } else {
      print('Failed to delete the product: ${response.body}');
    }

    setState(() {
      _deleteProductInProgress = false;
    });
  }

}

