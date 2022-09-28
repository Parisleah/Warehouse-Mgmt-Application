import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyBox extends StatelessWidget {
  final Widget icon;
  Color amountFontColor;
  String title;
  double amount;
  Color primaryColor;
  Color secondaryColor;
  double size;

  MoneyBox(this.icon, this.title, this.amount, this.primaryColor,
      this.secondaryColor, this.size, this.amountFontColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 440,
        height: size,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: secondaryColor,
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 4))
          ],
          gradient: LinearGradient(
            colors: [
              primaryColor,
              secondaryColor,
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.1, 0.8],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              this.icon,
              Text(
                title,
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
              Center(
                child: Text(
                  '${NumberFormat("#,###,###.##").format(amount)} ฿',
                  style: TextStyle(fontSize: 30, color: amountFontColor),
                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                ),
              )
            ]),
      ),
    );
  }
}
