import 'package:catalogoenti/shared/domain/materiale_con_ultimo_intervento.dart';
import 'package:catalogoenti/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScadenzeWidget extends StatelessWidget {
  final List<MaterialeConUltimoIntervento> materiali;
  final Text? emptyMessage;
  const ScadenzeWidget({super.key, this.emptyMessage, required this.materiali});
  @override
  Widget build(BuildContext context) {
    return materiali.isEmpty
        ? Center(
            child: emptyMessage ?? Text('Nessun materiale da calibrare 🎉'),
          )
        : ListView.separated(
            itemCount: materiali.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final materialeConUltimoIntervento = materiali[index];
              final materiale = materialeConUltimoIntervento.materiale;
              final ultimoIntervento =
                  materialeConUltimoIntervento.ultimoIntervento;

              return ListTile(
                leading: const Icon(Icons.warning_amber, color: Colors.red),
                title: Text(materiale.partNumber),
                subtitle: Text(materiale.denominazione),
                trailing: Text(
                  '⚠️ ultimo intervento: ${formatDate(ultimoIntervento)} ',
                ),
                onTap: () {
                  context.pushNamed(
                    'materialeDettaglio',
                    pathParameters: {'id': '${materiale.id}'},
                  );
                  // Puoi navigare alla scheda del materiale o aprire un dettaglio
                },
              );
            },
          );
  }
}
