import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;

        return AboutPage(
          title: const Text('Informazioni sull\'app'),
          applicationName: 'Catalogo Materiali e Calibrazioni',
          applicationVersion: info?.version ?? '?.?.?',
          applicationIcon: const FlutterLogo(),
          applicationLegalese: '© ${DateTime.now().year} COMLOG 2^ Div',
          children: const <Widget>[
            MarkdownPageListTile(
              icon: Icon(Icons.description),
              title: Text('Descrizione'),
              filename: 'assets/about.md',
            ),
            LicensesPageListTile(icon: Icon(Icons.favorite)),
          ],
        );
      },
    );
  }
}
