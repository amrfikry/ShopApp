import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';

import '../screens/cart_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

import '../providers/auth.dart';
import '../helpers/custom_route.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                color: Colors.red,
                height: 200,
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://icon-library.net/images/avatar-icon-png/avatar-icon-png-1.jpg'),
                        minRadius: 20,
                        maxRadius: 40,
                      ),
                    ),
                    Text(
                      'Amr Fikry',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Amrfikry99@gmail.com',
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('Shop'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              Divider(
                color: Colors.black45,
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text('Your Cart'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(CartScreen.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Your Orders'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrderScreen.routeName);
                  // Navigator.of(context).pushReplacement(CustomRoute(builder: (ctx) => OrderScreen(), ),);
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Manage Products'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(UserProductsScreen.routeName);
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
            ),
          )
        ],
      ),
    );
  }
}
