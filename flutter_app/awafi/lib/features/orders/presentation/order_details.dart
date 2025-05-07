import 'package:awafi/core/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/cancel_order/cancel_order_bloc.dart';
import '../bloc/order/orders_bloc.dart';
import '../bloc/return_order/return_order_bloc.dart';
import '../domain/purchase_history/order_entity.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  const OrderDetails({super.key, required this.order});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final TextEditingController _reasonController = TextEditingController();
  late Future<Map<String, dynamic>> _orderDetailsFuture;

  @override
  void initState() {
    super.initState();
    _orderDetailsFuture = OrderService().fetchOrderDetails(widget.order.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: BlocListener<ReturnOrderBloc, ReturnOrderState>(
        listener: (context, state) {
            if (state is ReturnOrderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green),
              );
              GetIt.I<OrdersBloc>().add(LoadOrders(
                  page: 1, limit: 10));
              Navigator.pop(context);
            } else if (state is ReturnOrderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
        child: BlocListener<OrderCancellationBloc, OrderCancellationState>(
          listener: (context, state) {
            if (state is OrderCancellationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green),
              );
              print('Order cancellation success: ${state.message}');
              GetIt.I<OrdersBloc>().add(LoadOrders(
                  page: 1, limit: 10));
              Navigator.pop(context);
            } else if (state is OrderCancellationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text("Order ID: ${widget.order.id}"),
                Text("User: ${widget.order.user}"),
                Text("Transaction ID: ${widget.order.transactionId}"),
                Text("Amount: ${widget.order.amount.toStringAsFixed(2)}"),
                Text("Order Status: ${widget.order.orderStatus}"),
                Text("Payment Status: ${widget.order.paymentStatus}"),
                Text("Payment Method: ${widget.order.paymentMethod}"),
                Text(
                    "Discount Amount: ${widget.order.discountAmount.toStringAsFixed(2)}"),
                Text("Currency: ${widget.order.currency}"),
                const SizedBox(height: 16),
                const Text(
                  "Shipping Address",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Full Name: ${widget.order.shippingAddress.fullName}"),
                Text("Address Line 1: ${widget.order.shippingAddress.addressLine1}"),
                Text("Address Line 2: ${widget.order.shippingAddress.addressLine2}"),
                Text("City: ${widget.order.shippingAddress.city}"),
                Text("Postal Code: ${widget.order.shippingAddress.postalCode}"),
                Text("Country: ${widget.order.shippingAddress.country}"),
                Text("Phone: ${widget.order.shippingAddress.phone}"),
                const SizedBox(height: 16),
                const Text(
                  "Items",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                FutureBuilder(
                future: _orderDetailsFuture,
                 builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }
          final order = snapshot.data!;
          final items = order['items'] as List<dynamic>;
          return ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item['name']),
                        subtitle: Column(
                          children: [
                            Text(
                              'Quantity: ${item['quantity']}, Price: ${item['price']} ${order['currency']}',
                            ),if(widget.order.orderStatus == 'delivered')
                            if(item["returnStatus"] !='requested')
                            Row(
                              children: [
                                TextButton(onPressed: (){
                                  showOrderActionSheet(
                          onTap: () {
                            context.read<ReturnOrderBloc>().add(
                                  OrderReturnEvent(
                                    orderId: widget.order.id,
                                    reason: _reasonController.text,
                                    productId: item['productId'],
                                    variantId: item['variantId']
                                  ),
                                );
                            Navigator.pop(context);
                          },
                          context,
                          title: 'Cancel Order',
                          hintText: 'Enter reason for cancellation',
                        );
                                }, child: Text('Return Product')),
                                 TextButton(onPressed: (){
                                  
                                }, child: Text('Rate Product')),
                              ],
                            )
                          ],
                        ),
                        leading: Image.network(item['images']),
                      ),
                    );});
          }
                 ),
                const SizedBox(height: 16),
                Text("Created At: ${widget.order.createdAt}"),
                Text("Updated At: ${widget.order.updatedAt}"),
                Text("Tracking ID: ${widget.order.trackingId}"),
                if (widget.order.cancellationReason.isNotEmpty)
                  Text("Cancellation Reason: ${widget.order.cancellationReason}"),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 50,
          child: widget.order.orderStatus.toLowerCase() == 'cancelled'
              ? Center(
                  child: Text(
                    'Order is Cancelled',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              : 
              widget.order.orderStatus.toLowerCase() == 'processing'?
                   ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF414851),
                      ),
                      onPressed: () {
                        showOrderActionSheet(
                          onTap: () {
                            context.read<OrderCancellationBloc>().add(
                                  CancelOrderEvent(
                                    orderId: widget.order.id,
                                    reason: _reasonController.text,
                                  ),
                                );
                            Navigator.pop(context);
                          },
                          context,
                          title: 'Cancel Order',
                          hintText: 'Enter reason for cancellation',
                        );
                      },
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                    ):SizedBox(),
        ),
      ),
    );
  }

  void showOrderActionSheet(BuildContext context,
      {required String title,
      required String hintText,
      required VoidCallback onTap}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF414851),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onTap,
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class OrderService {

  Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwtToken');
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/orders/order/user/$orderId'),headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }
    );
    print('##############################################');
    print(response.body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }
}