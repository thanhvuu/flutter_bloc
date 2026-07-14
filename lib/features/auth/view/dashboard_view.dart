import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bloc_app_demo/domain/entities/user.dart';
import 'package:bloc_app_demo/features/auth/bloc/auth_bloc.dart';
import 'package:bloc_app_demo/features/order/bloc/order_bloc.dart';
import 'package:bloc_app_demo/core/utils/order_formatter.dart';

class DashboardView extends StatefulWidget {
  final User user;
  const DashboardView({super.key, required this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('profile.title'.tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequestedEvent());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red.shade100,
                          radius: 28,
                          child: Text(
                            widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : 'U',
                            style: const TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const SizedBox(height: 4),
                              Text(widget.user.email, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    _buildInfoRow(Icons.phone_android, 'profile.phone'.tr(), widget.user.phone),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on_outlined, 'profile.address'.tr(), widget.user.address),

                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _showLanguageBottomSheet(context),
                      child: _buildInfoRow(
                        Icons.language,
                        'profile.language'.tr(),
                        context.locale.languageCode == 'vi' ? 'profile.vietnamese'.tr() : 'profile.english'.tr(),

                      ),
                    )
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'profile.order_history'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.2),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.black),
                  onPressed: () {
                    context.read<OrderBloc>().add(LoadOrdersEvent(widget.user.id));
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                if (state is OrderLoading) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }
                
                if (state is OrderError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                }

                if (state is OrderLoaded) {
                  final orders = state.orders;
                  if (orders.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Icon(Icons.history, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 8),
                            Text('profile.no_order_history'.tr(), style:  TextStyle(color: Colors.grey.shade500)),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final double total = order.totalAmount;
                      
                      

                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          title: Text('profile.order'.tr(namedArgs: {'id': order.displayId.toString()}), style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('profile.order_date'.tr(namedArgs: {'date': order.displayDate})),
                          trailing: Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  );
                }
                
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.red),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}

void _showLanguageBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (bottomSheetContext) {
      return SafeArea(
        child: Column (
          mainAxisSize: MainAxisSize.min,
          children: [
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('profile.language'.tr(),style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            ListTile(
              title: const Text('profile.english').tr(),
              trailing: context.locale.languageCode == 'en' ? const Icon(Icons.check, color: Colors.red) : null,
              onTap: () {
                context.setLocale(const Locale('en', 'US'));
                Navigator.pop(bottomSheetContext);
              },
            ),
            ListTile(
              title: const Text('profile.vietnamese').tr(),
              trailing: context.locale.languageCode == 'vi' ? const Icon(Icons.check, color: Colors.red) : null,
              onTap: () {
                context.setLocale(const Locale('vi','VN'));
                Navigator.pop(bottomSheetContext);
              },
            )
          ],
        )
      );
    }
  );
}