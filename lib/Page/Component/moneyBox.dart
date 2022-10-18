import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoneyBox extends StatelessWidget {
  final Widget mainIcon;
  final Widget trendIcon;
  Color amountFontColor;
  String title;
  int amount;
  Color primaryColor;
  Color secondaryColor;
  double size;

  MoneyBox(this.mainIcon, this.trendIcon, this.title, this.amount,
      this.primaryColor, this.secondaryColor, this.size, this.amountFontColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 120,
        height: size,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.primary,
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
              Row(
                children: [
                  // this.mainIcon,
                  // Spacer(),
                  // this.trendIcon,
                  // Text(
                  //   '${NumberFormat("#,###,###.##").format(amount / 7)} ฿',
                  //   style: TextStyle(fontSize: 15, color: amountFontColor),
                  //   // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                  // )
                ],
              ),
              Text(
                title,
                style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
              Center(
                child: Text(
                  '${NumberFormat("#,###,###.##").format(amount)} ฿',
                  style: TextStyle(fontSize: 15, color: amountFontColor),
                  // color: Theme.of(context).bottomNavigationBarTheme.selectedItemColor),
                ),
              )
            ]),
      ),
    );
  }
}
