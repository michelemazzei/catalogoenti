import 'package:catalogoenti/features/materiali/providers/materiali_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EntiPossessoriWidget extends ConsumerWidget {
  final int materialeId;

  const EntiPossessoriWidget({super.key, required this.materialeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entiAsync = ref.watch(entiPerMaterialeProvider(materialeId));

    return entiAsync.when(
      data: (entiConReparti) {
        if (entiConReparti.isEmpty) {
          return const Text('Nessun ente possiede questo materiale.');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enti e reparti che possiedono questo materiale:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...entiConReparti.map(
              (ecr) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(ecr.ente.nome),
                    subtitle: Text('Zona: ${ecr.ente.zona}'),
                  ),
                  ...ecr.reparti.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: ListTile(
                        title: Text('Reparto: ${r.nome}'),
                        subtitle: Text('Località: ${r.localita}'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Errore nel caricamento: $e'),
    );
  }
}
