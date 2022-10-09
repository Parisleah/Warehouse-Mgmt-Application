import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

// Components
import 'package:warehouse_mnmt/Page/Component/searchBox.dart';
import 'package:warehouse_mnmt/Page/Model/Customer.dart';
import 'package:warehouse_mnmt/Page/Model/CustomerAdress.dart';
import 'package:warehouse_mnmt/Page/Shop/Selling/nav_chooseCusAddress.dart';
// Page
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_nav_createCustomer.dart';

import '../../../db/database.dart';
import '../../Model/Shop.dart';

class SellingNavChooseCustomer extends StatefulWidget {
  final Shop shop;
  final ValueChanged<CustomerModel> updateCustomer;
  final ValueChanged<CustomerAddressModel> updateCustomerAddress;
  const SellingNavChooseCustomer(
      {required this.shop,
      required this.updateCustomer,
      required this.updateCustomerAddress,
      Key? key})
      : super(key: key);

  @override
  State<SellingNavChooseCustomer> createState() =>
      _SellingNavChooseCustomerState();
}

class _SellingNavChooseCustomerState extends State<SellingNavChooseCustomer> {
  List<CustomerModel> customers = [];

  @override
  void initState() {
    super.initState();
    refreshCustomers();
  }

  Future refreshCustomers() async {
    customers = await DatabaseManager.instance.readAllCustomerInShop(widget.shop.shopid!);
    setState(() {});
  }

  _getCustomerAddress(CustomerAddressModel address) {
    setState(() {
      widget.updateCustomerAddress(address);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          title: Column(
            children: [
              Text(
                "เลือกลูกค้า",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => selling_nav_createCustomer(
                              shop: widget.shop,
                            )));
                refreshCustomers();
              },
              icon: Icon(Icons.add),
            )
          ],
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Baseline(
              child: SearchBox("ชื่อลูกค้า หรือ เบอร์โทรศัพท์"),
              baselineType: TextBaseline.alphabetic,
              baseline: 120,
            ),
          ),
          backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(29, 29, 65, 1.0),
              Color.fromRGBO(31, 31, 31, 1.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Column(children: [
            SizedBox(height: 180),
            customers.isEmpty
                ? Container(
                    width: 440,
                    height: 560,
                    child: Center(
                        child: Text(
                      'ไม่มีลูกค้า',
                      style: TextStyle(color: Colors.grey, fontSize: 25),
                    )),
                  )
                : Container(
                    width: 440,
                    height: 560,
                    child: RefreshIndicator(
                      onRefresh: refreshCustomers,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: customers.length,
                          itemBuilder: (context, index) {
                            final customer = customers[index];
                            return Dismissible(
                              background: Container(
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              resizeDuration: Duration(seconds: 1),
                              key: UniqueKey(),
                              onDismissed: (direction) async {
                                await DatabaseManager.instance
                                    .deleteCustomer(customer.cusId!);
                                refreshCustomers();
                                setState(() {});
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.redAccent,
                                  content: Text("ลบลูกค้า ${customer.cName}"),
                                  duration: Duration(seconds: 2),
                                ));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color.fromRGBO(56, 54, 76, 1.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                SellingNavCreateCustomerAddress(
                                                  customer: customer,
                                                  update: _getCustomerAddress,
                                                )));
                                    widget.updateCustomer(customer);
                                  },
                                  child: Row(children: [
                                    Icon(Icons.person_pin_circle),
                                    Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(customer.cName,
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                  ]),
                                ),
                              ),
                            );
                            // Choose Customer Button;
                          }),
                    ),
                  ),
          ]),
        ),
      ),
    );
  }
}
