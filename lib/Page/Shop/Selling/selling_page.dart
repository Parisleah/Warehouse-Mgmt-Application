import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Navigator Page
// /// Edit Page
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_nav_edit.dart';
// Add Page
import 'package:warehouse_mnmt/Page/Shop/Selling/selling_nav_add.dart';
// Component
import 'package:warehouse_mnmt/Page/Component/searchBox.dart';
// Models
import 'package:warehouse_mnmt/Page/Model/SellingPage/customers.dart';

class SellingPage extends StatelessWidget {
  List<Customer> customers = [
    const Customer(
        username: "Thejasvee",
        email: "Thejasvee.jagg@bumail.net",
        urlAvatar: "assets/images/profiles/Tj.png",
        cost: 699.12165,
        sellingDate: "14 เม.ย. 2022"),
    const Customer(
        username: "Pisit Janthawee",
        email: "Pisit.jant@bumail.net",
        urlAvatar: "assets/images/profiles/Aum.png",
        cost: 890.12165,
        sellingDate: "14 เม.ย. 2022"),
    const Customer(
        username: "Nattapat Kongpanya",
        email: "Nattapat.Kong@bumail.net",
        urlAvatar: "assets/images/profiles/Mark.png",
        cost: 1890.12165,
        sellingDate: "14 เม.ย. 2022"),
    const Customer(
        username: "Phongsiri Chaisrida",
        email: "Dong.chai@bumail.net",
        urlAvatar: "assets/images/profiles/Dong.png",
        cost: 990.12165,
        sellingDate: "14 เม.ย. 2022"),
    const Customer(
        username: "Phongsiri Chaisrida",
        email: "Dong.chai@bumail.net",
        urlAvatar: "assets/images/profiles/Dong.png",
        cost: 990.12165,
        sellingDate: "14 เม.ย. 2022"),
    const Customer(
        username: "Phongsiri Chaisrida",
        email: "Dong.chai@bumail.net",
        urlAvatar: "assets/images/profiles/Dong.png",
        cost: 990.12165,
        sellingDate: "14 เม.ย. 2022"),
    const Customer(
        username: "Phongsiri Chaisrida",
        email: "Dong.chai@bumail.net",
        urlAvatar: "assets/images/profiles/Dong.png",
        cost: 990.12165,
        sellingDate: "14 เม.ย. 2022"),
  ];

  @override
  Widget build(BuildContext context) => DefaultTabController(
      length: 5,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(160),
          child: AppBar(
            shadowColor: Colors.black.withOpacity(1.0),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
            title: const Text(
              " ขายสินค้า",
              style: TextStyle(fontSize: 25),
            ),

            backgroundColor: Color.fromRGBO(30, 30, 65, 1.0),
            // leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => SellingNavAdd()));
                },
                icon: Icon(Icons.add),
              )
            ],
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Baseline(
                child: SearchBox("ชื่อลูกค้า หรือ เบอร์โทรศัพท์"),
                baselineType: TextBaseline.alphabetic,
                baseline: 90,
              ),
            ),

            // backgroundColor: Colors.indigo.shade900,

            // shape: RoundedRectangleBorder(
            //     borderRadius:
            //         BorderRadius.vertical(bottom: Radius.circular(16))),

            bottom: TabBar(
                indicatorColor: Colors.transparent,
                unselectedLabelColor: Colors.white,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color.fromRGBO(37, 35, 53, 1.0)),
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(56, 54, 76, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(" ทั้งหมด "),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(56, 54, 76, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("วันนี้"),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(56, 54, 76, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                          alignment: Alignment.center, child: Text("สัปดาห ์")),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(56, 54, 76, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("เดือน "),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(56, 54, 76, 1.0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("ระบุวัน"),
                      ),
                    ),
                  ),
                ]),

            elevation: 0,
            titleSpacing: 4,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color.fromRGBO(29, 29, 65, 1.0),
              Color.fromRGBO(31, 31, 31, 1.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  shadowColor: Colors.grey.withOpacity(0.5),
                  color: Color.fromRGBO(56, 54, 76, 1.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,

                      // backgroundImage: NetworkImage(user.urlAvatar),

                      backgroundImage: AssetImage(customer.urlAvatar),
                    ),

                    // leading: Container(
                    //   width: 50.0,
                    //   height: 90.0,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     image: const DecorationImage(
                    //       fit: BoxFit.cover,
                    //       image: AssetImage('assets/images/ga.png'),
                    //     ),
                    //   ),
                    // ),

                    title: Text(
                      customer.username,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 80),
                        child: Text(
                          customer.email,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      Text(
                        customer.sellingDate,
                        style: TextStyle(color: Colors.grey),
                      )
                    ]),
                    trailing: Text(
                      '${NumberFormat("#,###.##").format(customer.cost)} ฿',
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              sellingNavEdit(customer: customer)));
                    },
                  ),
                );
              }),
        ),
      ));
}