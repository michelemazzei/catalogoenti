import 'package:catalogoenti/features/enti/providers/enti_providers.dart';
import 'package:catalogoenti/features/materiali/extensions/materiale_extension.dart';
import 'package:catalogoenti/features/materiali/providers/materiali_providers.dart';
import 'package:catalogoenti/shared/widgets/text_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MaterialiScreen extends ConsumerStatefulWidget {
  final int? enteId;
  final String? enteNome;

  const MaterialiScreen({super.key, this.enteId, this.enteNome = ''});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<MaterialiScreen> {
  String filtro = '';
  @override
  Widget build(BuildContext context) {
    final materialiAsync = widget.enteId == null
        ? ref.watch(tuttiIMaterialiProvider)
        : ref.watch(materialiPerEnteProvider(widget.enteId!));
    return Scaffold(
      appBar: AppBar(title: Text('Materiali ${widget.enteNome}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextSearchBar(
              label: 'Filtra per nome',
              onChanged: (value) =>
                  setState(() => filtro = value.toLowerCase()),
            ),

            const SizedBox(height: 16),
            Expanded(
              child: materialiAsync.when(
                data: (materiali) {
                  final filtrati = filtro.isEmpty
                      ? materiali
                      : materiali.where((e) => e.contiene(filtro)).toList();

                  if (filtrati.isEmpty) {
                    return const Center(
                      child: Text('Nessun materiale trovato.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtrati.length,
                    itemBuilder: (context, index) {
                      final item = filtrati[index];
                      return ListTile(
                        title: Text(item.partNumber),
                        subtitle: Text('Descrizione: ${item.denominazione}'),
                        onTap: () {
                          context.pushNamed(
                            'materialeDettaglio',
                            pathParameters: {'id': '${item.id}'},
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Errore: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
