import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:automated_attdance_system/providers/url_providers.dart';

class ChangeBaseURLScreen extends ConsumerStatefulWidget {
  const ChangeBaseURLScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _ChangeBaseURLScreenState();
  }
}

class _ChangeBaseURLScreenState extends ConsumerState<ChangeBaseURLScreen> {

  var _baseURL;

  void _changeBaseURL() {
    print(_baseURL);
    ref.read(baseUrlProvider.notifier).changeURL(_baseURL);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                label: Text("url")
              ),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).colorScheme.onBackground
              ),
              onChanged: (value) {
                _baseURL = value;
              },
            ),
            TextButton(onPressed: _changeBaseURL, child: const Text("update"))
          ],
        )
      ),
    );
  }
}