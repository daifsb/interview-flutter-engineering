import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:interview_flutter/data/models/cart_item.dart';

import 'cubit/cart_screen_cubit.dart';
import 'cubit/cart_screen_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartScreenView();
  }
}

class CartScreenView extends StatefulWidget {
  const CartScreenView({super.key});

  @override
  State<CartScreenView> createState() => _CartScreenViewState();
}

class _CartScreenViewState extends State<CartScreenView> {
  late final CartScreenCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<CartScreenCubit>();
  }

  void _listener(BuildContext context, CartScreenState state) {
    switch (state.status) {
      case CartScreenStatus.initial:
      case CartScreenStatus.loading:
      case CartScreenStatus.ready:
        break;

      case CartScreenStatus.failure:
        break;
    }
  }

  Future<void> _showEditQuantitySheet(BuildContext context, CartItem item) {
    final TextEditingController remarkController = TextEditingController(
      text: item.remark,
    );

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: BlocBuilder<CartScreenCubit, CartScreenState>(
            builder: (context, state) {
              final currentItem = state.items.firstWhere(
                (i) => i.product.id == item.product.id,
                orElse: () => item,
              );

              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentItem.product.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filledTonal(
                          onPressed: () =>
                              _cubit.removeProduct(currentItem.product),
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '${currentItem.quantity}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () =>
                              _cubit.addProduct(currentItem.product),
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    TextField(
                      controller: remarkController,
                      decoration: const InputDecoration(
                        labelText: 'Remarks',
                        hintText: 'Remarks',
                      ),
                      onChanged: (value) {
                        _cubit.updateRemark(currentItem.product, value);
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ตกลง'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartScreenCubit, CartScreenState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: _listener,
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartScreenCubit, CartScreenState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.items.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return _buildCartItem(item);
                  },
                ),
              ),
              _buildTotalSection(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Slidable(
      key: ValueKey(item.product.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) {
              _cubit.deleteProductCompletely(item.product);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEditQuantitySheet(context, item),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.product.thumbnail,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (item.remark.isNotEmpty)
                      Text(
                        'หมายเหตุ: ${item.remark}',
                        style: TextStyle(
                          color: Colors.red[400],
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    Text(
                      '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              Icon(
                item.hasSent ? Icons.timer_outlined : Icons.arrow_forward_ios,
                size: 18,
                color: item.hasSent ? Colors.orange : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSection(CartScreenState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.totalSentPrice > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ordered Amount (Sent)',
                      style: TextStyle(color: Colors.orange),
                    ),
                    Text(
                      '\$${state.totalSentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pending Amount',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '\$${state.totalPendingPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: state.totalPendingPrice > 0
                      ? () => _cubit.markAsSent()
                      : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Send Order'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
