import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GdprDialog extends StatelessWidget {
  const GdprDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.handshake_outlined),
      title: const Text('Данные для персонализированной рекламы'),
      content: const Text('Мы не будем собирать ваши данные для персонализированной рекламы.\n'
      'Несмотря на то, что неперсонализированная реклама не использует идентификаторы мобильной рекламы для таргетинга,'
      'она по-прежнему использует идентификаторы мобильной рекламы для ограничения частоты показов, агрегированной отчетности о рекламе, а также для борьбы с мошенничеством и злоупотреблениями'),
      actions: [
        ElevatedButton(
          child: const Text('Privacy Policy', style: TextStyle(
              color: Colors.white),),
          onPressed: () async {
            final Uri _url = Uri.parse('https://babylabpro.ru/privacy-policy');
            if (!await launchUrl(_url)) {
              throw Exception('Could not launch $_url');
            }
          },
        ),
        ElevatedButton(
          child: const Text('Отклонить', style: TextStyle(
              color: Colors.white),),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          child: const Text('Принять', style: TextStyle(
              color: Colors.white),),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
