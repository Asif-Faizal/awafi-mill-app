import 'package:awafi/core/injection/injection.dart';
import 'package:awafi/features/orders/presentation/order_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/order/orders_bloc.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  State<PurchaseHistoryScreen> createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  @override
  void initState() {
    GetIt.I<OrdersBloc>().add(LoadOrders(page: 1, limit: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersBloc>()..add(LoadOrders(page: 1, limit: 10)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF161A1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
          title:  Text("Orders",
          style: GoogleFonts.mulish(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const Center(
                  child:Text(
                        'No orders Found!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetails(order: order,)));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("Order ID: ${order.id}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Amount: ${order.currency}${order.amount}"),
                            Text("Status: ${order.orderStatus}"),
                            Text("Payment: ${order.paymentStatus}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is OrdersError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            return const Center(child: Text("No Data Available"));
          },
        ),
      ),
    );
  }
}
