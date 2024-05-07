// import 'package:flutter/material.dart';
// import 'package:non_attending/Utils/resources/app_theme.dart';
// import 'package:non_attending/View/Cart%20Screens/cart_provider.dart';
// import 'package:non_attending/View/HomeScreen/homescreen.dart';
// import 'package:non_attending/View/bottomNavBar/nav_view.dart';
// import 'package:provider/provider.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final cart = Provider.of<Cart>(context);
//     return Scaffold(
//       key: _scaffoldKey,
//       bottomNavigationBar: const BottomNav(),
//       appBar: AppBar(
//         backgroundColor: AppTheme.appColor,
//         leading: IconButton(
//           icon: Image.asset('assets/images/drawer.png'),
//           onPressed: () {
//             _scaffoldKey.currentState!.openDrawer();
//           },
//         ),
//       ),
//       drawer: const MyDrawer(),
//       body: Container(
//         width: screenWidth,
//         height: screenHeight,
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 237, 216, 167), // 43%
//               Color.fromARGB(255, 223, 214, 192), // 7.74%
//               Color.fromARGB(255, 231, 221, 198), // 22.45%
//             ],
//           ),
//         ),
//         child:         ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: 10,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.only(
//                             left: 20.0, right: 20, top: 20),
//                         child: Container(
//                           width: 268,
//                           decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                     color: Color.fromARGB(255, 145, 158, 222),
//                                     blurRadius: 3,
//                                     offset: Offset(3, 5))
//                               ],
//                               borderRadius: BorderRadius.circular(27),
//                               color: AppTheme.whiteColor),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     AppText.appText("250 INR",
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w600),
//                                     const StarRating(
//                                       rating: 3.5,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 AppText.appText("Applied Sciences",
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.w600,
//                                     textColor: const Color(0xff0D2393)),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     AppText.appText("Buy Now",
//                                         shadow: true,
//                                         shadowColor: AppTheme.blue,
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.w600),
//                                     GestureDetector(
//                                       onTap: () {
//                                         final product = Product(
//                                           id: 1,
//                                           name: 'Product 1',
//                                           price: 10.0,
//                                           rating: 2.0,
//                                           image: 'null',
//                                         );
//                                         cart.addToCart(product);
//                                       },
//                                       child: Image.asset(
//                                         "assets/images/cart.png",
//                                         height: 40,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   )
         
//       ),
//     );
//   }
// }
