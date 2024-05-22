import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
//import 'package:list_view_api_project/product.dart';
import 'package:list_view_api_project/product_model.dart';
import 'package:list_view_api_project/update_product_screen.dart';

import 'add_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  bool _getProductListInProgress = false;

  List<ProductModel> productList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: RefreshIndicator(
        onRefresh: _getProductList,
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(child: CircularProgressIndicator()),
          child: ListView.separated(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return _buildProductItem(productList[index]);
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    _getProductListInProgress = true;
    setState(() {});
    productList.clear();

    const String productListUrl =
        'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productListUrl);
    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      // data decode
      final decodedData = jsonDecode(response.body);

      //get the list
      final jsonProductList = decodedData['data'];

      //loop for the list
      for (Map<String, dynamic> json in jsonProductList) {
       ProductModel productModel = ProductModel.fromJson(json);
        productList.add(productModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get product list')),
      );
    }

    _getProductListInProgress = false;
    setState(() {});
  }

  Widget _buildProductItem(ProductModel product) {
    return ListTile(
      /*leading: Image.network(
        product.image??'',
        height: 60,
        width: 60,
      ),*/
      title: Text(product.productName??'Unknown'),
      subtitle: Wrap(
        children: [
          Text('Unit Price: ${product.unitPrice}'),
          Text(' Quantity: ${product.quantity}'),
          Text('Total Price: ${product.totalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProductScreen(
                    product: product,
                  ),
                ),
              );
              if (result == true) {
                _getProductList();
              }
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(product.id!);
            },
            icon: const Icon(Icons.delete_outline_sharp),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String productID) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    _deleteProduct(productID);
                    Navigator.pop(context);
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  Future<void> _deleteProduct(String productID) async {
    _getProductListInProgress = true;
    setState(() {});
    String deleteProductUrl =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productID';
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      _getProductList();
    } else {
      _getProductListInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete')),
      );
    }
  }
}
