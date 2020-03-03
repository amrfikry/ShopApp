import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/order_item.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occurred'),
              );
            } else if (Provider.of<Orders>(context).orders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 100),
                child: Container(
                  height: double.infinity,
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          'assets/emptycart.png',
                          fit: BoxFit.fitHeight,
                        ),
                        Text(
                          'No orders yet',
                          style: TextStyle(fontSize: 35, color: Colors.black54),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          'No orders yet , create a new order in the shop',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16
                          ),
                        )
                      ],
                    ),
                    elevation: 0,
                  ),
                ),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(
                    orderData.orders[i],
                  ),
                ),
              );
            }
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}
