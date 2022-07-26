import 'package:ecommerce_v3/presentations/widgets/screen.home/filter_type.dart';
import 'package:flutter/material.dart';

class HomeTopAppBar extends StatelessWidget {
  HomeTopAppBar({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      // toolbarHeight: 300.0,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'e-shop',
        style: TextStyle(color: Colors.black),
      ),
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          scaffoldKey.currentState!.openDrawer();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed('/search');
          },
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.shopping_cart,
            color: Colors.black,
          ),
        ),
      ],
      // bottom: TabBar(tabs: [FilterType()])
    );
  }
}
