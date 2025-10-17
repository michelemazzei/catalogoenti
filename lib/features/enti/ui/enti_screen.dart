import 'package:catalogoenti/features/enti/providers/enti_providers.dart';
import 'package:catalogoenti/shared/widgets/text_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EntiScreen extends ConsumerStatefulWidget {
  const EntiScreen({super.key});

  @override
  ConsumerState<EntiScreen> createState() => _EntiScreenState();
}

class _EntiScreenState extends ConsumerState<EntiScreen> {
  String filtro = '';

  @override
  Widget build(BuildContext context) {
    final entiAsync = ref.watch(entiListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Elenco Enti')),
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
              child: entiAsync.when(
                data: (enti) {
                  final filtrati = filtro.isEmpty
                      ? enti
                      : enti
                            .where((e) => e.nome.toLowerCase().contains(filtro))
                            .toList();

                  if (filtrati.isEmpty) {
                    return const Center(child: Text('Nessun ente trovato.'));
                  }

                  return ListView.builder(
                    itemCount: filtrati.length,
                    itemBuilder: (context, index) {
                      final ente = filtrati[index];
                      return ListTile(
                        title: Text(ente.nome),
                        subtitle: Text('Zona: ${ente.zona ?? '-'}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          context.pushNamed(
                            'entiDetails',
                            pathParameters: {'id': ente.id.toString()},
                          );
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Errore: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
