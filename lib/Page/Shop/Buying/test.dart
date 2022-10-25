      // Container(
      //                           decoration: BoxDecoration(
      //                               // color: const Color.fromRGBO(56, 48, 77, 1.0),
      //                               borderRadius: BorderRadius.circular(15)),
      //                           width: 370,
      //                           height: ddModelSelectedItems.length > 1
      //                               ? ddModelSelectedItems.length * 90
      //                               : 200,
      //                           child: ListView.builder(
      //                               shrinkWrap: true,
      //                               scrollDirection: Axis.vertical,
      //                               padding: EdgeInsets.zero,
      //                               itemCount: ddModelSelectedItems.length,
      //                               itemBuilder:
      //                                   (BuildContext context, int index) {
      //                                 List lotSelectedsInEachModel = [];
      //                                 final modelItem =
      //                                     ddModelSelectedItems[index];
      //                                 // add .where .map lotItem.prodModelId == modelItem.prodModelId
      //                                 for (var lotItem in ddLotSelectedItems) {
      //                                   if (lotItem.prodModelId ==
      //                                       modelItem.prodModelId) {
      //                                     lotSelectedsInEachModel.add(lotItem);
      //                                   }
      //                                 }

      //                                 // final getSelectedLot =
      //                                 //     lotSelectedItems.where((element) =>
      //                                 //         element.prodModelId ==
      //                                 //         indModelItem.prodModelId);

      //                                 // var amount;
      //                                 // if (amountControllers[index].text.isEmpty ||
      //                                 //     amountControllers[index].text == null) {
      //                                 //   amountControllers[index].text = '0';
      //                                 //   amount = 1;
      //                                 // } else {
      //                                 //   amount = int.parse(
      //                                 //       amountControllers[index].text);
      //                                 // }

      //                                 // // int.parse(TextEditingController().text);
      //                                 var totalPrice = modelItem.price * 1;
      //                                 return Padding(
      //                                   padding: const EdgeInsets.all(3),
      //                                   child: ClipRRect(
      //                                     borderRadius: BorderRadius.circular(10),
      //                                     child: Container(
      //                                       color:
      //                                           Color.fromRGBO(66, 64, 87, 1.0),
      //                                       child: Padding(
      //                                         padding: const EdgeInsets.all(10.0),
      //                                         child: Row(
      //                                           mainAxisAlignment:
      //                                               MainAxisAlignment.start,
      //                                           children: [
      //                                             const SizedBox(width: 10),
      //                                             Column(
      //                                               crossAxisAlignment:
      //                                                   CrossAxisAlignment.start,
      //                                               children: [
      //                                                 Row(
      //                                                   children: [
      //                                                     Text(
      //                                                       '${modelItem.stProperty} ${(modelItem.ndProperty)}',
      //                                                       style: TextStyle(
      //                                                           fontSize: 11,
      //                                                           color:
      //                                                               Colors.white,
      //                                                           fontWeight:
      //                                                               FontWeight
      //                                                                   .bold),
      //                                                     ),
      //                                                     Text(
      //                                                         ' (${NumberFormat("#,###.##").format(totalPrice)})',
      //                                                         style:
      //                                                             const TextStyle(
      //                                                                 color: Colors
      //                                                                     .grey,
      //                                                                 fontSize:
      //                                                                     12)),
      //                                                   ],
      //                                                 ),
      //                                                 const SizedBox(
      //                                                   width: 10,
      //                                                 ),
      //                                                 Text(
      //                                                     'ต้นทุน ${NumberFormat("#,###.##").format(modelItem.cost)}',
      //                                                     style: const TextStyle(
      //                                                         color: Colors.grey,
      //                                                         fontSize: 12)),
      //                                                 Text(
      //                                                     'ราคา ${NumberFormat("#,###.##").format(modelItem.price)}',
      //                                                     style: const TextStyle(
      //                                                         color: Colors.white,
      //                                                         fontSize: 12)),
      //                                                 Container(
      //                                                   width: 300,
      //                                                   height: 120,
      //                                                   padding:
      //                                                       const EdgeInsets.all(
      //                                                           5),
      //                                                   decoration: BoxDecoration(
      //                                                       color: Color.fromARGB(
      //                                                           255, 52, 51, 71),
      //                                                       borderRadius:
      //                                                           BorderRadius
      //                                                               .circular(
      //                                                                   10)),
      //                                                   child: Column(
      //                                                     crossAxisAlignment:
      //                                                         CrossAxisAlignment
      //                                                             .start,
      //                                                     children: <Widget>[
      //                                                       ListView.builder(
      //                                                           padding:
      //                                                               EdgeInsets
      //                                                                   .zero,
      //                                                           itemCount:
      //                                                               lotSelectedsInEachModel
      //                                                                   .length,
      //                                                           physics:
      //                                                               ClampingScrollPhysics(),
      //                                                           shrinkWrap: true,
      //                                                           itemBuilder:
      //                                                               (BuildContext
      //                                                                       context,
      //                                                                   int index) {
      //                                                             final lotInd =
      //                                                                 lotSelectedsInEachModel[
      //                                                                     index];

      //                                                             final _isSelectedlot =
      //                                                                 lotSelectedsInEachModel
      //                                                                     .contains(
      //                                                                         lotInd);
      //                                                             return Padding(
      //                                                               padding: const EdgeInsets
      //                                                                       .only(
      //                                                                   top: 5),
      //                                                               child:
      //                                                                   InkWell(
      //                                                                 onTap: () {
      //                                                                   _isSelectedlot
      //                                                                       ? ddLotSelectedItems.remove(
      //                                                                           lotInd)
      //                                                                       : ddLotSelectedItems
      //                                                                           .add(lotInd);
      //                                                                   setState(
      //                                                                       () {});
      //                                                                   setState(
      //                                                                       () {});
      //                                                                 },
      //                                                                 child:
      //                                                                     Container(
      //                                                                   decoration:
      //                                                                       BoxDecoration(
      //                                                                     color: Color.fromARGB(
      //                                                                         255,
      //                                                                         40,
      //                                                                         39,
      //                                                                         55),
      //                                                                     borderRadius:
      //                                                                         BorderRadius.circular(30),
      //                                                                   ),
      //                                                                   child:
      //                                                                       Padding(
      //                                                                     padding:
      //                                                                         const EdgeInsets.all(3.0),
      //                                                                     child:
      //                                                                         Row(
      //                                                                       children: [
      //                                                                         _isSelectedlot
      //                                                                             ? Icon(
      //                                                                                 Icons.check_box_rounded,
      //                                                                                 color: Theme.of(context).backgroundColor,
      //                                                                               )
      //                                                                             : Icon(
      //                                                                                 Icons.check_box_outline_blank,
      //                                                                                 color: Theme.of(context).backgroundColor,
      //                                                                               ),
      //                                                                         Text('ล็อตที่ ${NumberFormat("#,###.##").format(lotInd.prodLotId)}',
      //                                                                             style: const TextStyle(color: Colors.grey, fontSize: 12)),
      //                                                                         Text(' (วันที่ ${df.format(lotInd.orderedTime!)})',
      //                                                                             style: const TextStyle(color: Color.fromARGB(255, 247, 55, 55), fontSize: 12)),
      //                                                                         SizedBox(
      //                                                                           width: 10,
      //                                                                         ),
      //                                                                         // Container(
      //                                                                         //   height:
      //                                                                         //       50,
      //                                                                         //   width:
      //                                                                         //       120,
      //                                                                         //   child: TextField(
      //                                                                         //       onChanged: ((value) {
      //                                                                         //         totalPrice = indModelItem.cost * amount;
      //                                                                         //         _calculateTotal(allTotal);

      //                                                                         //         setState(() {});
      //                                                                         //       }),
      //                                                                         //       keyboardType: TextInputType.number,
      //                                                                         //       controller: amountControllers[index],
      //                                                                         //       style: TextStyle(color: Colors.white),
      //                                                                         //       decoration: InputDecoration(
      //                                                                         //         filled: true,
      //                                                                         //         fillColor: Color.fromARGB(255, 46, 44, 62),
      //                                                                         //         border: const OutlineInputBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)), borderSide: BorderSide.none),
      //                                                                         //         hintText: 'จำนวน',
      //                                                                         //         hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      //                                                                         //         suffixIcon: amountControllers[index].text.isEmpty
      //                                                                         //             ? IconButton(
      //                                                                         //                 onPressed: () {
      //                                                                         //                   amountControllers[index].clear();
      //                                                                         //                   amountControllers[index].text = '1';
      //                                                                         //                   setState(() {});
      //                                                                         //                 },
      //                                                                         //                 icon: const Icon(
      //                                                                         //                   Icons.close_sharp,
      //                                                                         //                   size: 10,
      //                                                                         //                   color: Colors.white,
      //                                                                         //                 ),
      //                                                                         //               )
      //                                                                         //             : null,
      //                                                                         //       )),
      //                                                                         // )
      //                                                                       ],
      //                                                                     ),
      //                                                                   ),
      //                                                                 ),
      //                                                               ),
      //                                                             );
      //                                                           }),
      //                                                     ],
      //                                                   ),
      //                                                 )
      //                                               ],
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 );
      //                               }),
      //                         ),
      //                       ],
      //                     ),
      //                   ),
