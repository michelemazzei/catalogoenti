import 'package:catalogoenti/data/database/app_database.dart';
import 'package:catalogoenti/features/enti/providers/enti_providers.dart';
import 'package:catalogoenti/providers/database_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class EnteForm extends ConsumerStatefulWidget {
  final Ente ente;

  const EnteForm({required this.ente, super.key});

  @override
  ConsumerState<EnteForm> createState() => _EnteFormState();
}

class _EnteFormState extends ConsumerState<EnteForm> {
  late TextEditingController nomeController;
  String? zona;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.ente.nome);
    zona = widget
        .ente
        .zona; // Presuppone che zona sia una stringa tipo 'Nord' o 'Sud'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modifica Ente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome ente'),
            ),
            DropdownButtonFormField<String>(
              initialValue: zona,
              decoration: const InputDecoration(labelText: 'Zona'),
              items: const [
                DropdownMenuItem(value: 'Nord', child: Text('Nord')),
                DropdownMenuItem(value: 'Sud', child: Text('Sud')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => zona = value);
              },
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Salva'),
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  final dao = await ref.read(daoSessionCQRSProvider.future);
                  final enteAggiornato = widget.ente.copyWith(
                    nome: nomeController.text,
                    zona: drift.Value(zona),
                  );

                  await dao.entiCommands.updateEnte(enteAggiornato);
                  ref.invalidate(
                    enteByIdProvider(enteAggiornato.id),
                  ); // 🔁 Ricarica dopo modifica

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: const Text('✅ Ente aggiornato con successo'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                        bottom: 40,
                        left: 16,
                        right: 16,
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  if (context.mounted) context.pop(); // Torna al dettaglio
                } catch (e, _) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text('❌ Errore durante il salvataggio: $e'),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(
                        bottom: 40,
                        left: 16,
                        right: 16,
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
