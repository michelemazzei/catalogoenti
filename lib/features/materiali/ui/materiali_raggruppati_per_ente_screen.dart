import 'package:flutter/material.dart';

import '../widgets/tabella_materiali_per_ente_widget.dart';

class MaterialiRaggruppatiPerEnteScreen extends StatelessWidget {
  final String? enteId;
  const MaterialiRaggruppatiPerEnteScreen({super.key, this.enteId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Materiali per Ente')),
      body: TabellaMaterialiPerEnteWidget(enteId: enteId),
    );
  }
}
