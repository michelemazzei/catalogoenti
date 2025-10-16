import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:catalogoenti/services/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbState = ref.watch(databaseManagerProvider);

    String pathText;
    if (dbState.isLoading) {
      pathText = '⏳ Caricamento...';
    } else if (dbState.hasError) {
      pathText = '❌ Errore: ${dbState.error}';
    } else {
      final path = ref.read(databaseManagerProvider.notifier).path;
      pathText = path ?? 'Nessun database caricato';
    }

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('📁 Database attivo', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(pathText, style: const TextStyle(fontSize: 14)),
          const Divider(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.folder_open),
            label: const Text('Apri database esistente'),
            onPressed: () async {
              final file = await pickDatabaseFile();
              if (file != null) {
                await ref
                    .read(databaseManagerProvider.notifier)
                    .loadFromFile(file);
                final path = ref.read(databaseManagerProvider.notifier).path;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📦 Database caricato: ${path ?? file.path}'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
