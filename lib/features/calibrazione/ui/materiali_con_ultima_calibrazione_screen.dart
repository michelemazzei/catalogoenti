import 'package:catalogoenti/features/calibrazione/providers/calibrazione_providers.dart';
import 'package:catalogoenti/features/calibrazione/widgets/tabella_scadenze_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialiConUltimaCalibrazioneScreen extends ConsumerWidget {
  const MaterialiConUltimaCalibrazioneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialiAsync = ref.watch(materialiConUltimoInterventoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Materiali con ultimo intervento')),
      body: materialiAsync.when(
        data: (materiali) => TabellaScadenzeWidget(materiali: materiali),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Errore: $err')),
      ),
    );
  }
}
