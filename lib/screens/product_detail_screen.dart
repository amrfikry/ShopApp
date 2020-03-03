import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:pinch_zoom_image/pinch_zoom_image.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title , this.price);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final hours = 23 - DateTime.now().hour;
    final mins = 60 - DateTime.now().minute;
    final shippingDate = DateFormat("MMMd").format(DateTime.now().add(
      Duration(days: 2),
    ));
    final shippingDay = DateFormat("E").format(DateTime.now().add(
      Duration(days: 2),
    ));

    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    Widget freeShipping(double fees) {
      if (fees > 20) {
        return Row(
          children: <Widget>[
            Text(
              'Eligible for  ',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              'FREE Shipping',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ' & FREE Returns',
              style: TextStyle(fontSize: 15),
            ),
          ],
        );
      } else {
        return Text(
          'Eligible for FREE Returns',
          style: TextStyle(fontSize: 15, color: Colors.lightGreen),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    loadedProduct.seller,
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: RatingBar(
                    itemSize: 20,
                    initialRating: 3,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {},
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                loadedProduct.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 400,
              width: double.infinity,
              child: Hero(
                tag: loadedProduct.id,
                child: Center(
                  
                  child: PinchZoomImage(
                    zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
                    hideStatusBarWhileZooming: true,
                    image: Image.network(
                      loadedProduct.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: freeShipping(loadedProduct.price),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Order it within $hours hours $mins mins to receive it by ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '$shippingDay, $shippingDate',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 8.0, bottom: 8),
              child: Text(
                'In Stock',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: <Widget>[
                  Text('Ships from and sold by '),
                  Text(
                    '${loadedProduct.seller}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  )
                ],
              ),
            ),
            FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Add to cart',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                    loadedProduct.id,
                    loadedProduct.price,
                    loadedProduct.title,
                    loadedProduct.seller,
                    loadedProduct.imageUrl);
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
