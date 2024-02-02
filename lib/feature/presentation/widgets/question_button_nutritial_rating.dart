import 'package:flutter/material.dart';

class NutritialRatingOwerview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(2.0),
      shape: const CircleBorder(),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Нутритивная польза'),
          content: const Text(
              'Насколько насыщена витаминами и микроэлементами пища, необходимыми младенцам для оптимального роста. Чем питательнее еда, тем больше звезд она получит.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Закрыть'),
              child: const Text('Закрыть'),
            ),
          ],
        ),
      ),
      child: const Icon(
        Icons.question_mark,
        size: 18.0,
      ),
    );
  }
}
