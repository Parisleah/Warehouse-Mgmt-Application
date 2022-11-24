// Container(
//                                       decoration: BoxDecoration(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .background
//                                               .withOpacity(0.9),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       height: 320,
//                                       child: ListView.builder(
//                                           // scrollDirection: Axis.horizontal,
//                                           padding: EdgeInsets.zero,
//                                           itemCount: productModels.length,
//                                           itemBuilder: (context, index) {
//                                             final productModelInd =
//                                                 productModels[index];

//                                             return GestureDetector(
//                                               onTap: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(5.0),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       color: Theme.of(context)
//                                                           .colorScheme
//                                                           .primary,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10)),
//                                                   child: 
//                                                   Column(children: [
//                                                     Row(
//                                                       children: [
//                                                         const SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Text(
//                                                           '${index + 1}',
//                                                           style: TextStyle(
//                                                               fontSize: 15,
//                                                               color: Theme.of(
//                                                                       context)
//                                                                   .backgroundColor),
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               decoration: BoxDecoration(
//                                                                   color: Theme.of(
//                                                                           context)
//                                                                       .colorScheme
//                                                                       .primary,
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10)),
//                                                               child: Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .all(
//                                                                         3.0),
//                                                                 child: Text(
//                                                                     '${productModelInd.stProperty}',
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           15,
//                                                                       color: Colors
//                                                                           .white,
//                                                                     )),
//                                                               ),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Container(
//                                                               decoration: BoxDecoration(
//                                                                   color: Theme.of(
//                                                                           context)
//                                                                       .colorScheme
//                                                                       .primary,
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10)),
//                                                               child: Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .all(
//                                                                         3.0),
//                                                                 child: Text(
//                                                                   '${productModelInd.ndProperty}',
//                                                                   style: const TextStyle(
//                                                                       fontSize:
//                                                                           15,
//                                                                       color: Colors
//                                                                           .white),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Spacer(),
//                                                         Positioned(
//                                                           top: 0.0,
//                                                           right: 0,
//                                                           child: IconButton(
//                                                             icon: const Icon(
//                                                                 Icons.close,
//                                                                 size: 25,
//                                                                 color: Colors
//                                                                     .grey),
//                                                             onPressed: () {
//                                                               DialogSetState(
//                                                                 () {
//                                                                   productModels
//                                                                       .removeAt(
//                                                                           index);
//                                                                 },
//                                                               );
//                                                             },
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       children: [
//                                                         Container(
//                                                           decoration: BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10)),
//                                                           height: 60,
//                                                           width: 130,
//                                                           child: CustomTextField
//                                                               .textField(
//                                                             context,
//                                                             'ต้นทุน',
//                                                             _validate,
//                                                             length: 10,
//                                                             isNumber: true,
//                                                             textController:
//                                                                 editCostControllers[
//                                                                     index],
//                                                           ),
//                                                         ),
//                                                         Container(
//                                                           decoration: BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10)),
//                                                           height: 60,
//                                                           width: 130,
//                                                           child: CustomTextField
//                                                               .textField(
//                                                             context,
//                                                             'ขาย',
//                                                             _validate,
//                                                             isNumber: true,
//                                                             length: 10,
//                                                             textController:
//                                                                 editPriceControllers[
//                                                                     index],
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                   ]),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                     ),


//////////////////////////////////////////////////////////////////////////////////
// Container(
//                                       decoration: BoxDecoration(
//                                           color: Theme.of(context)
//                                               .colorScheme
//                                               .background
//                                               .withOpacity(0.9),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       height: 320,
//                                       child: ListView.builder(
//                                           // scrollDirection: Axis.horizontal,
//                                           padding: EdgeInsets.zero,
//                                           itemCount: productModels.length,
//                                           itemBuilder: (context, index) {
//                                             final productModelInd =
//                                                 productModels[index];

//                                             return GestureDetector(
//                                               onTap: () {
//                                                 Navigator.pop(context);
//                                               },
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(5.0),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       color: Theme.of(context)
//                                                           .colorScheme
//                                                           .primary,
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10)),
//                                                   child: Column(children: [
//                                                     Row(
//                                                       children: [
//                                                         const SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Text(
//                                                           '${index + 1}',
//                                                           style: TextStyle(
//                                                               fontSize: 15,
//                                                               color: Theme.of(
//                                                                       context)
//                                                                   .backgroundColor),
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               decoration: BoxDecoration(
//                                                                   color: Theme.of(
//                                                                           context)
//                                                                       .colorScheme
//                                                                       .primary,
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10)),
//                                                               child: Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .all(
//                                                                         3.0),
//                                                                 child: Text(
//                                                                     '${productModelInd.stProperty}',
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           15,
//                                                                       color: Colors
//                                                                           .white,
//                                                                     )),
//                                                               ),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 10,
//                                                             ),
//                                                             Container(
//                                                               decoration: BoxDecoration(
//                                                                   color: Theme.of(
//                                                                           context)
//                                                                       .colorScheme
//                                                                       .primary,
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               10)),
//                                                               child: Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .all(
//                                                                         3.0),
//                                                                 child: Text(
//                                                                   '${productModelInd.ndProperty}',
//                                                                   style: const TextStyle(
//                                                                       fontSize:
//                                                                           15,
//                                                                       color: Colors
//                                                                           .white),
//                                                                 ),
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                         const SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         Spacer(),
//                                                         Positioned(
//                                                           top: 0.0,
//                                                           right: 0,
//                                                           child: IconButton(
//                                                             icon: const Icon(
//                                                                 Icons.close,
//                                                                 size: 25,
//                                                                 color: Colors
//                                                                     .grey),
//                                                             onPressed: () {
//                                                               DialogSetState(
//                                                                 () {
//                                                                   productModels
//                                                                       .removeAt(
//                                                                           index);
//                                                                 },
//                                                               );
//                                                             },
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceEvenly,
//                                                       children: [
//                                                         Text(
//                                                           'น้ำหนัก',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.grey),
//                                                         ),
//                                                         Container(
//                                                           decoration: BoxDecoration(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           10)),
//                                                           height: 60,
//                                                           width: 130,
//                                                           child: CustomTextField
//                                                               .textField(
//                                                             context,
//                                                             'กรัม',
//                                                             _validate,
//                                                             length: 10,
//                                                             isNumber: true,
//                                                             textController:
//                                                                 weightControllers[
//                                                                     index],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 10,
//                                                     ),
//                                                   ]),
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                     ),