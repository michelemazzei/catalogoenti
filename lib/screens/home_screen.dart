import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catalogo Enti')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push('/enti'),
              child: const Text('Vai agli Enti'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/materiali'),
              child: const Text('Vai ai Materiali'),
            ),
            ElevatedButton(
              onPressed: () => context.push('/interventi'),
              child: const Text('Vai agli Interventi'),
            ),
          ],
        ),
      ),
    );
  }
}
