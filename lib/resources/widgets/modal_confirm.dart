import 'package:flutter/material.dart';

class ModalConfirm extends StatelessWidget {

    final String title;
    final String content;
    final VoidCallback onConfirm;
    final VoidCallback onCancel;

    const ModalConfirm({
        Key? key,
        required this.title,
        required this.content,
        required this.onConfirm,
        required this.onCancel,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
                ElevatedButton(
                    onPressed: onCancel,
                    child: const Text('Cancelar'),
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.error),
                    ),
                    onPressed: onConfirm,
                    child: Text('Confirmar', style: TextStyle(color: Theme.of(context).colorScheme.onError)),
                ),
            ],
        );
    }
}