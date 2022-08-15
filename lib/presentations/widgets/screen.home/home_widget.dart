import 'dart:async';

import 'package:ecommerce_v3/data/model/product_model.dart';
import 'package:ecommerce_v3/logic/category/product_category_cubit.dart';
import 'package:ecommerce_v3/logic/product/product_cubit.dart';
import 'package:ecommerce_v3/presentations/widgets/screen.home/filter_type.dart';
import 'package:ecommerce_v3/presentations/widgets/screen.home/home_category_item.dart';
import 'package:ecommerce_v3/presentations/widgets/screen.home/item.dart';
import 'package:ecommerce_v3/presentations/common/skeloton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../common/theme_helper.dart';

// ignore: must_be_immutable
class HomeWidget extends StatelessWidget {
  HomeWidget({Key? key}) : super(key: key);

  late int currentIndexHome = 0;
  final scrollControllerHome = ScrollController();

  void setupScrollControllerHome(context) {
    scrollControllerHome.addListener(() {
      if (scrollControllerHome.position.atEdge) {
        if (scrollControllerHome.position.pixels != 0) {
          BlocProvider.of<ProductCubit>(context).loadProduct();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollControllerHome(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          // _searchField(),
          const FilterType(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: RaisedButton(
                  elevation: 0,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/product');
                  },
                  child: Text(
                    'Most viewed item ->',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: _productList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Recommended ->',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 300,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      color: Colors.grey[100],
                      elevation: 0.5,
                      child: const ListItem(
                        index: 0,
                      ),
                      onPressed: () {},
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.grey[100],
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
              builder: (context, category) {
                if (category is ProductCategoryLoaded) {
                  return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: category.category.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: HomeCategoryItem(
                            index: index, name: category.category[index].name),
                      );
                    },
                  );
                }
                return ListView.builder(
                    shrinkWrap: true,
                    // scrollDirection: Axis.vertical,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        // padding: const EdgeInsets.all(2.0),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          elevation: .5,
                          color: Colors.white,
                          child: cartSkeleton(),
                          onPressed: () => null,
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  cartSkeleton() {
    return Container(
      color: Colors.grey[150],
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Skeleton(
            height: 150,
            width: 150,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Skeleton(height: 10, width: 50),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Skeleton(height: 10, width: 120),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: Skeleton(height: 10, width: 100),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Skeleton(height: 10, width: 50),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Skeleton(height: 10, width: 80),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: false,
        decoration: ThemeHelper().searchInputDecoration(
            'Search', '', '', false, const Icon(Icons.search)),
        onChanged: (value) {},
      ),
    );
  }

  Widget _productList() {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
      if (state is ProductLoading && state.isFirstFetch) {
        return _loadingIndicator();
      }

      List<Product> products = [];
      bool isLoading = false;

      if (state is ProductLoading) {
        products = state.oldProducts;
        isLoading = true;
      } else if (state is ProductLoaded) {
        products = state.product;
      }

      return ListView.separated(
          controller: scrollControllerHome,
          scrollDirection: Axis.horizontal,
          itemBuilder: ((context, index) {
            if (index < products.length) {
              // ignore: deprecated_member_use
              return RaisedButton(
                  elevation: 1,
                  color: Colors.grey[100],
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/product_detail', arguments: index);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListItem(index: index),
                        ],
                      ),
                    ],
                  ));
            } else {
              Timer(Duration(milliseconds: 200), () {
                scrollControllerHome
                    .jumpTo(scrollControllerHome.position.maxScrollExtent);
              });
              return _loadingIndicator();
            }
            // return _product(products[index], context);
          }),
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.white,
            );
          },
          itemCount: products.length + (isLoading ? 1 : 0));
    });
  }

  Widget _loadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
