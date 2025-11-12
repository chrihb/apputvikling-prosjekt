import 'package:flutter/material.dart';

class Popup extends StatelessWidget {
  const Popup.message({
    super.key,
    required this.title,
    required this.message,
    this.onConfirm,
  })  : textController = null,
        onTextConfirm = null,
        isInput = false;

  const Popup.input({
    super.key,
    required this.title,
    required this.textController,
    this.onTextConfirm,
  })  : message = null,
        onConfirm = null,
        isInput = true;

  final String title;
  final String? message;
  final VoidCallback? onConfirm;
  final void Function(String)? onTextConfirm;
  final TextEditingController? textController;

  final bool isInput;

  // ─────────────── Message popup ───────────────
  static Future<void> showMessage(
      BuildContext context, {
        required String title,
        required String message,
        VoidCallback? onConfirm,
      }) {
    return showDialog<void>(
      context: context,
      builder: (_) => Popup.message(
        title: title,
        message: message,
        onConfirm: onConfirm,
      ),
    );
  }

  // ─────────────── Input popup ───────────────
  static Future<void> showInput(
      BuildContext context, {
        required String title,
        required TextEditingController controller,
        required void Function(String value) onConfirm,
      }) {
    return showDialog<void>(
      context: context,
      builder: (_) => Popup.input(
        title: title,
        textController: controller,
        onTextConfirm: onConfirm,
      ),
    );
  }

  // ─────────────── UI ───────────────
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: scheme.surface,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
      ),
      content: isInput
          ? TextField(
        controller: textController,
        decoration: InputDecoration(
          hintText: 'List Name',
          filled: true,
          fillColor: scheme.surfaceContainerHigh,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.primary),
          ),
        ),
      )
          : Text(
        message ?? '',
        style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: scheme.onSurfaceVariant)),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            if (isInput && onTextConfirm != null) {
              onTextConfirm!(textController!.text);
            } else {
              onConfirm?.call();
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: scheme.surfaceContainerHigh,
            foregroundColor: scheme.onPrimaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text("Confirm"),
        ),
      ],
    );
  }
}
