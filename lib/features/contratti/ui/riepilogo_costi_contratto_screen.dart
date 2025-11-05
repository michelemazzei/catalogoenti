import 'package:flutter/material.dart';

import '../widgets/riepilogo_costi_contratto_widget.dart';

class RiepilogoCostiContrattoScreen extends StatelessWidget {
  final int idContratto;

  const RiepilogoCostiContrattoScreen({required this.idContratto, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riepilogo Costi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RiepilogoCostiContrattoWidget(idContratto: idContratto),
      ),
    );
  }
}
