import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(
  //   this.id,
  //   this.title,
  //   this.imageUrl,
  // );
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Hero(
                      tag: product.id ,
                      child: FadeInImage(
                        placeholder:
                            AssetImage('assets/product-placeholder.png'),
                        image: NetworkImage(product.imageUrl),
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Consumer<Product>(
                          builder: (ctx, product, child) => IconButton(
                            icon: product.isFavorite
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            onPressed: () {
                              product.toggleFavoriteStates(
                                  authData.token, authData.userId);
                            },
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                product.seller,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    product.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${product.price.toString()}',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Add to cart',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Icon(Icons.add_shopping_cart)
                  ],
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(
                    product.id,
                    product.price,
                    product.title,
                    product.seller,
                    product.imageUrl,
                  );
                  prefix0.Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Added item to cart'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ));
                },
              ),
            ],
          ),
        ),
        // footer: GridTileBar(
        //   backgroundColor: Colors.black87,
        //   leading: Consumer<Product>(
        //     builder: (ctx, product, child) => IconButton(
        //       icon: product.isFavorite
        //           ? Icon(Icons.favorite)
        //           : Icon(Icons.favorite_border),
        //       onPressed: () {
        //         product.toggleFavoriteStates();
        //       },
        //     ),
        //   ),
        //   title: FittedBox(
        //     child: Text(
        //       product.title,
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
