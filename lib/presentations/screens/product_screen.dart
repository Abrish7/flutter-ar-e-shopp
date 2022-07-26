import 'package:ecommerce_v3/presentations/widgets/screen.product/product_category_widget.dart';
import 'package:ecommerce_v3/presentations/widgets/screen.product/top_app_bar.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: TopAppBar(),
        ),
        body: ProductCategoryWidget());
  }
}
