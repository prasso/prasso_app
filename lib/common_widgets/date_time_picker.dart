// Dart imports:
import 'dart:async';

// Project imports:
import 'package:delegate_app/common_widgets/format.dart';
import 'package:delegate_app/common_widgets/input_dropdown.dart';
// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key? key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.onSelectedDate,
    this.onSelectedTime,
  }) : super(key: key);

  final String? labelText;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final ValueChanged<DateTime>? onSelectedDate;
  final ValueChanged<TimeOfDay>? onSelectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate!(pickedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime!);
    if (pickedTime != null && pickedTime != selectedTime) {
      onSelectedTime!(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleLarge;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText,
            valueText: Format.date(selectedDate!),
            valueStyle: valueStyle,
            onPressed: () => _selectDate(context),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 4,
          child: InputDropdown(
            valueText: selectedTime!.format(context),
            valueStyle: valueStyle,
            onPressed: () => _selectTime(context),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('labelText', labelText));
    properties.add(DiagnosticsProperty<DateTime>('selectedDate', selectedDate));
    properties
        .add(DiagnosticsProperty<TimeOfDay>('selectedTime', selectedTime));
    properties.add(ObjectFlagProperty<ValueChanged<DateTime>>.has(
        'onSelectedDate', onSelectedDate));
    properties.add(ObjectFlagProperty<ValueChanged<TimeOfDay>>.has(
        'onSelectedTime', onSelectedTime));
  }
}
