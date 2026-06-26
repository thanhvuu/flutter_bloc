import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_app_demo/features/network/bloc/network_bloc.dart';

class NoNetworkOverlay extends StatelessWidget {
  const NoNetworkOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Header ELITE ATHLETE
              const Text(
                'ELITE ATHLETE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
          
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54, width: 1),
                  ),
                  child: const Icon(
                    Icons.wifi_off_outlined,
                    size: 60,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              const Text(
                'KHÔNG CÓ KẾT NỐI',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              const Text(
                'Vui lòng kiểm tra lại đường truyền internet\ncủa bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const Spacer(),
             
              ElevatedButton(
                onPressed: () {
                  
                  context.read<NetworkBloc>().add(NetworkRetry());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC00010), 
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, 
                  ),
                ),
                child: const Text(
                  'THỬ LẠI (RETRY)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}