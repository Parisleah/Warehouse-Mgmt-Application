// Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
// 	                      Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: DropdownButtonFormField2(
//                           validator: (value) {
//                             if (value == null) {
//                               return 'โปรดเลือกรูปแบบสินค้า';
//                             }
//                           },
//                           onChanged: (value) {
//                             selectedValue = value as ProductModel;
//                             if (prodAmountController.text.isNotEmpty) {
//                               int amount = int.parse(prodAmountController.text);
//                               _calculateTotal(selectedValue, amount);
//                             }

//                             setState(() {});
//                           },
//                           onSaved: (value) {
//                             selectedValue = value as ProductModel;

//                             setState(() {});
//                           },
//                           dropdownMaxHeight: 200,
//                           itemHeight: 80,
//                           buttonDecoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.transparent,
//                             ),
//                             color: Color.fromRGBO(66, 64, 87, 1.0),
//                           ),
//                           decoration: InputDecoration(
//                             isDense: true,
//                             contentPadding: EdgeInsets.zero,
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           isExpanded: true,
//                           hint: Text(
//                             productModels.isEmpty
//                                 ? 'ไม่มีรูปแบบสินค้า'
//                                 : 'โปรดเลือกรูปแบบสินค้า',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           icon: const Icon(
//                             Icons.arrow_drop_down,
//                             color: Colors.white,
//                           ),
//                           iconSize: 30,
//                           buttonHeight: 80,
//                           buttonPadding:
//                               const EdgeInsets.only(left: 20, right: 10),
//                           dropdownDecoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             border: Border.all(
//                               color: Colors.transparent,
//                             ),
//                             color: const Color.fromRGBO(56, 54, 76, 1.0),
//                           ),
//                           items: productModels
//                               .map((item) => DropdownMenuItem<ProductModel>(
//                                     value: item,
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(bottom: 5),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(10),
//                                         child: Container(
//                                           height: 100,
//                                           color:
//                                               Color.fromRGBO(66, 64, 87, 1.0),
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(10.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Icon(
//                                                   Icons
//                                                       .check_box_outline_blank_rounded,
//                                                   color: Theme.of(context)
//                                                       .backgroundColor,
//                                                 ),
//                                                 Column(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       '${item.stProperty} ${(item.ndProperty)}',
//                                                       style: TextStyle(
//                                                           fontSize: 11,
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     const SizedBox(
//                                                       width: 10,
//                                                     ),
//                                                     Text(
//                                                         'ต้นทุน ${NumberFormat("#,###.##").format(item.cost)}',
//                                                         style: const TextStyle(
//                                                             color: Colors.grey,
//                                                             fontSize: 12)),
//                                                     Text(
//                                                         ' ราคา ${NumberFormat("#,###.##").format(item.price)}',
//                                                         style: const TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize: 12)),
//                                                   ],
//                                                 ),
//                                                 Container(
//                                                   decoration: BoxDecoration(
//                                                       color: _getLotRemainAmount(item
//                                                                   .prodModelId) ==
//                                                               0
//                                                           ? Colors.redAccent
//                                                           : Theme.of(context)
//                                                               .colorScheme
//                                                               .background,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               15)),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             5.0),
//                                                     child: Row(
//                                                       children: [
//                                                         _getLotRemainAmount(item
//                                                                     .prodModelId) ==
//                                                                 0
//                                                             ? Container()
//                                                             : Text('คงเหลือ ',
//                                                                 style:
//                                                                     const TextStyle(
//                                                                   fontSize: 12,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 )),
//                                                         Text(
//                                                             _getLotRemainAmount(item
//                                                                         .prodModelId) ==
//                                                                     0
//                                                                 ? 'สินค้าหมด'
//                                                                 : '${NumberFormat("#,###.##").format(_getLotRemainAmount(item.prodModelId))}',
//                                                             style: const TextStyle(
//                                                                 fontSize: 12,
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold)),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Spacer(),
//                                                 Container(
//                                                   width: 120,
//                                                   child: TextFormField(
//                                                       keyboardType:
//                                                           TextInputType.number,
//                                                       controller:
//                                                           TextEditingController(),
//                                                       style: TextStyle(
//                                                           color: Colors.white),
//                                                       decoration:
//                                                           InputDecoration(
//                                                         filled: true,
//                                                         fillColor:
//                                                             Theme.of(context)
//                                                                 .colorScheme
//                                                                 .background,
//                                                         border: const OutlineInputBorder(
//                                                             borderRadius: BorderRadius.only(
//                                                                 topLeft: Radius
//                                                                     .circular(
//                                                                         20),
//                                                                 topRight: Radius
//                                                                     .circular(
//                                                                         20),
//                                                                 bottomLeft: Radius
//                                                                     .circular(
//                                                                         20),
//                                                                 bottomRight: Radius
//                                                                     .circular(
//                                                                         20)),
//                                                             borderSide:
//                                                                 BorderSide
//                                                                     .none),
//                                                         hintText: 'จำนวน',
//                                                         hintStyle:
//                                                             const TextStyle(
//                                                                 color:
//                                                                     Colors.grey,
//                                                                 fontSize: 14),
//                                                         suffixIcon:
//                                                             TextEditingController()
//                                                                     .text
//                                                                     .isEmpty
//                                                                 ? IconButton(
//                                                                     onPressed: () =>
//                                                                         TextEditingController()
//                                                                             .clear(),
//                                                                     icon:
//                                                                         const Icon(
//                                                                       Icons
//                                                                           .close_sharp,
//                                                                       size: 10,
//                                                                       color: Colors
//                                                                           .white,
//                                                                     ),
//                                                                   )
//                                                                 : null,
//                                                       )),
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ))
//                               .toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),