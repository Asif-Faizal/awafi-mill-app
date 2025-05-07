import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_bloc.dart';
import '../presentation/networkError_screen.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget connectedPage;

  const ConnectivityWrapper({super.key, required this.connectedPage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConectivityState>(
      builder: (context, state) {
        if (state is ConnectivityConnected) {
          return connectedPage;
        } else if (state is ConnectivityDisconnected) {
          return NetworkErrorScreen(
            onRetry: () {
              context.read<ConnectivityBloc>().add(RetryConnectivity());
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}