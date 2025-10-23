import 'package:catalogoenti/features/contratti/providers/contratti_providers.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContrattiScreen extends ConsumerWidget {
  const ContrattiScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contrattiAsync = ref.watch(tuttiIContrattiProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Contratti')),
      body: contrattiAsync.when(
        data: (contratti) => ListView.builder(
          itemCount: contratti.length,
          itemBuilder: (context, index) {
            final contratto = contratti[index];
            return ListTile(
              title: Text('Contratto #${contratto.codice}'),
              subtitle: Text('Data: ${formatDate(contratto.dataInizio)}'),
              onTap: () => context.pushNamed(
                'contrattoDettaglio',
                pathParameters: {'id': contratto.id.toString()},
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}
