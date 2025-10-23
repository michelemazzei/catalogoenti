import 'package:catalogoenti/features/calibrazione/providers/calibrazione_providers.dart';
import 'package:catalogoenti/features/calibrazione/widgets/scadenze_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialiInScadenzaScreen extends ConsumerWidget {
  const MaterialiInScadenzaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialiAsync = ref.watch(materialiInScadenzaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Materiali in scadenza da un anno')),
      body: materialiAsync.when(
        data: (materiali) => ScadenzeWidget(
          materiali: materiali,

          emptyMessage: Text('Nessun materiale calibrato quest\'anno 🎉'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }
}
