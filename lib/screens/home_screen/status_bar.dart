import 'dart:async';

import 'package:buildr_studio/models/prompt_service_connection_status.dart';
import 'package:buildr_studio/screens/home_screen/device_registration_state.dart';
import 'package:buildr_studio/screens/home_screen/export_logs_state.dart';
import 'package:buildr_studio/screens/home_screen/tool_usage/tool_usage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<StatusBar> {
  StreamSubscription? _connectionStatusSubscription;

  @override
  void initState() {
    super.initState();
    _connectionStatusSubscription =
        context.read<ToolUsageManager>().connectionStatusStream.listen((event) {
      context.read<DeviceRegistrationState>().registerDevice();
    });
  }

  @override
  void dispose() {
    _connectionStatusSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final toolUsageManager = context.watch<ToolUsageManager>();
    late final deviceRegistrationState =
        context.watch<DeviceRegistrationState>();
    late final exportLogsState = context.watch<ExportLogsState>();

    return Container(
      height: 32,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          const SizedBox(width: 16),
          switch (toolUsageManager.connectionStatus) {
            Error(:final message) => Tooltip(
                message: message,
                child: const Icon(Icons.error, color: Colors.red)),
            Connected() => const Tooltip(
                message: "Connected to server",
                child: Icon(Icons.check, color: Colors.green)),
            Connecting() => const Tooltip(
                message: "Connecting to server",
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.yellow,
                  ),
                ),
              ),
            Disconnected() => const Icon(Icons.link_off, color: Colors.red),
          },
          const SizedBox(width: 8),
          if (exportLogsState.isRunning)
            const Tooltip(
              message: 'Exporting logs',
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Colors.yellow,
                ),
              ),
            ),
          if (exportLogsState.isRunning) const Text('Exporting...'),
          const Spacer(),
          if (deviceRegistrationState.errorMessage != null)
            const Tooltip(
              message: 'Cannot register device',
              child: Icon(Icons.error, color: Colors.red),
            ),
          if (deviceRegistrationState.accountId != null)
            Tooltip(
              message: 'Click to copy account ID to clipboard',
              child: InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: deviceRegistrationState.accountId!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account ID copied to clipboard'),
                    ),
                  );
                },
                child: Text(
                    "Account ID: ${deviceRegistrationState.accountId!.split("-").first}",
                    style: TextStyle(color: Colors.grey[600])),
              ),
            ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}
