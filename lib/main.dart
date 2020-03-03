import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/editing_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash-screen.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';

import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
            auth.userId
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth , Orders>(
          builder:(ctx , auth , previousOrders) => Orders(auth.token , previousOrders == null ? [] : previousOrders.orders , auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.redAccent,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android : CustomPageTransBuilder() ,
            })
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx , authResultSnapshot ) => authResultSnapshot.connectionState == ConnectionState.waiting ? SplashScreen()  :  AuthScreen()  ,
          ) ,
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditingScreen.routeName: (ctx) => EditingScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
