import 'package:catalogoenti/features/enti/providers/enti_providers.dart';
import 'package:catalogoenti/features/enti/ui/ente_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EnteDetailScreen extends ConsumerWidget {
  final int enteId;

  const EnteDetailScreen({required this.enteId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repartiAsync = ref.watch(repartiPerEnteProvider(enteId));
    final materialiAsync = ref.watch(enteEMaterialiProvider(enteId));

    final materiali = materialiAsync.when(
      data: (materiali) => TextButton.icon(
        icon: const Icon(Icons.inventory),
        label: Text('Vedi Materiali (${materiali.$2.length})'),
        onPressed: () {
          context.pushNamed(
            'materialiPerEnte',
            pathParameters: {'enteId': enteId.toString()},
            extra: materiali.$1.nome,
          );
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Errore materiali: $e'),
    );

    final reparti = repartiAsync.when(
      data: (reparti) {
        if (reparti.isEmpty) {
          return const Text('Nessun reparto associato.');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reparti:', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            ...reparti.map(
              (r) => ListTile(
                title: Text(r.nome),
                subtitle: Text('Località: ${r.localita}'),
                onTap: () {
                  // TODO: naviga al dettaglio reparto
                },
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Errore nel caricamento reparti: $e'),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Dettagli Ente')),
      body: materialiAsync.when(
        data: (ente) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome:', style: Theme.of(context).textTheme.labelLarge),
              Text(ente.$1.nome, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text('Zona:', style: Theme.of(context).textTheme.labelLarge),
              Text(
                ente.$1.zona ?? '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              materiali,
              const SizedBox(height: 8),
              reparti,
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Modifica'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EnteForm(ente: ente.$1)),
                  );
                  ref.invalidate(
                    enteByIdProvider(enteId),
                  ); // 🔁 Ricarica dopo modifica
                },
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Errore: $e')),
      ),
    );
  }
}
