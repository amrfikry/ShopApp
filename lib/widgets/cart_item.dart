import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart.dart';

class CartItem extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  final String seller;
  final String imageUrl;
  CartItem(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.seller,
    this.imageUrl,
  );

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    final hours = 23 - DateTime.now().hour;
    final mins = 60 - DateTime.now().minute;
    final shippingDate = DateFormat("MMMd").format(DateTime.now().add(
      Duration(days: 2),
    ));
    final shippingDay = DateFormat("E").format(DateTime.now().add(
      Duration(days: 2),
    ));

    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Are you sure to remove this item?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("Yes"),
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                    )
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.productId);
      },
      key: ValueKey(widget.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        // child: ListTile(
        //   leading: CircleAvatar(
        //     child: Padding(
        //       padding: const EdgeInsets.all(5.0),
        //       child: FittedBox(
        //         child: Text('\$$price'),
        //       ),
        //     ),
        //   ),
        //   title: Text(title),
        //   subtitle: Text('Total : \$${price * quantity}'),
        //   trailing: Text('$quantity x'),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.seller,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '\$${widget.price}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    minRadius: 40,
                    maxRadius: 45,
                    backgroundImage: NetworkImage(widget.imageUrl),
                  )
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'Order it within $hours hours $mins mins to receive it by ',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '$shippingDay, $shippingDate',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.green),
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: <Widget>[
                  Text('Sold by '),
                  Text(
                    widget.seller,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  Text('Quantity'),
                  IconButton(
                    onPressed: () {
                      if (widget.quantity < 2) {
                        return showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you sure?'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Are you sure to delete this item?'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    Provider.of<Cart>(context, listen: false)
                                        .removeItem(widget.productId);
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          },
                        );
                      } else {
                         cart.decrease(widget.productId, widget.price,
                            widget.title, widget.seller, widget.imageUrl);
                      }
                    },
                    icon: Icon(Icons.remove_circle),
                  ),
                  Text(widget.quantity.toString()),
                  IconButton(
                    icon: Icon(Icons.add_circle),
                    onPressed: () {
                      if (widget.quantity > 9) {
                      } else {
                        cart.increase(widget.productId, widget.price,
                            widget.title, widget.seller, widget.imageUrl);
                      }
                    },
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false)
                          .removeItem(widget.productId);
                    },
                    child: Row(
                      children: <Widget>[Icon(Icons.delete), Text('Delete')],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
