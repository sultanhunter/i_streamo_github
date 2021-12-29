import 'package:flutter/services.dart';
///
class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // logic for adding "-" on 3th index
    if (oldValue.text.length == 3 && newValue.text.length == 4) {
      var selectionIndex = newValue.selection.end;
      // var newText = oldValue.text + "-" + newValue.text.substring(3);
      var newText = '${oldValue.text}-${newValue.text.substring(3)}';
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selectionIndex + 1),
      );
    }
    // logic for adding "-" on 7th index
    if (oldValue.text.length == 7 && newValue.text.length == 8) {
      var selectionIndex = newValue.selection.end;
      // String newText = oldValue.text + "-" + newValue.text.substring(7);
      var newText = '${oldValue.text}-${newValue.text.substring(7)}';
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selectionIndex + 1),
      );
    }
    // logic for removing "-" on 3th index
    if (oldValue.text.length == 5 && newValue.text.length == 4) {
      var selectionIndex = newValue.selection.end;
      var newText = newValue.text.replaceAll('-', '');
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selectionIndex - 1),
      );
    }
    // logic for removing "-" on 7th index
    if (oldValue.text.length == 9 && newValue.text.length == 8) {
      var selectionIndex = newValue.selection.end;
      var newText = newValue.text.replaceFirst('-', '', 4);
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selectionIndex - 1),
      );
    }
    return newValue;
  }
}
