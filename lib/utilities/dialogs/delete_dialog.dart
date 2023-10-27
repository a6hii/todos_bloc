import 'package:flutter/material.dart';

import 'package:todos_bloc_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'context.loc.delete',
    content: 'context.loc.delete_note_prompt,',
    optionsBuilder: () => {
      'ontext.loc.cancel': false,
      'context.loc.yes': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
