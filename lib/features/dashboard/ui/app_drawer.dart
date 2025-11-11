import 'package:catalogoenti/data/database/database_manager.dart';
import 'package:catalogoenti/services/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
        padding: EdgeInsets.zero,
        children: [
          Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Image.asset(
                      'assets/icon/app_icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Catalogo Enti',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '📁 Database attivo',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(pathText, style: const TextStyle(fontSize: 14)),
                const Divider(height: 32),
                TextButton.icon(
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Apri database esistente'),
                  onPressed: () async {
                    final file = await pickDatabaseFile();
                    if (file != null) {
                      await ref
                          .read(databaseManagerProvider.notifier)
                          .loadOrCreate(file);
                      final path = ref
                          .read(databaseManagerProvider.notifier)
                          .path;
                      if (context.mounted) {
                        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                          SnackBar(
                            content: Text(
                              '📦 Database caricato: ${path ?? file.path}',
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Informazioni'),
                  onPressed: () {
                    context.pushNamed('about');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
