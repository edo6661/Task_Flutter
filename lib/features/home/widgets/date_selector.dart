import 'package:flutter/material.dart';
import 'package:frontend/core/common/extent.dart';
import 'package:frontend/core/utils/generate_week_date.dart';
import 'package:frontend/core/utils/is_same_date.dart';
import 'package:frontend/ui/components/main_text.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  const DateSelector(
      {super.key,
      required this.selectedDate,
      required this.onSelectDate,
      required this.taskLengthByDate});

  final DateTime selectedDate;
  final void Function(DateTime) onSelectDate;
  final int Function(DateTime) taskLengthByDate;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffSet = 0;
  onBackWeek() {
    setState(() {
      weekOffSet--;
    });
  }

  onForwardWeek() {
    setState(() {
      weekOffSet++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final weekDate = generateWeekDate(weekOffSet);
    String monthName = DateFormat.MMMM().format(weekDate.first);

    return Column(
      spacing: 4,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: onBackWeek, icon: const Icon(Icons.arrow_back_ios)),
            MainText(text: monthName, extent: Medium()),
            IconButton(
                onPressed: onForwardWeek,
                icon: const Icon(Icons.arrow_forward_ios))
          ],
        ),
        SizedBox(
          // so the listview will not take the whole screen
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDate.length,
            key: const PageStorageKey('date_selector'),
            itemBuilder: (context, i) {
              final date = weekDate[i];
              final isSelected = isSameDate(date, widget.selectedDate);
              final textColor = isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface;
              final bgColor = isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent;
              final borderColor =
                  isSelected ? Colors.transparent : Colors.grey.shade200;

              return GestureDetector(
                onTap: () => widget.onSelectDate(date),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 70,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: borderColor,
                      width: 2,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(4, 4)),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MainText(
                              text: date.day.toString(),
                              extent: Medium(),
                              color: textColor),
                          MainText(
                            text: DateFormat.E().format(date),
                            extent: ExtraSmall(),
                            color: textColor,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: -12,
                        child: MainText(
                            text: widget.taskLengthByDate(date).toString(),
                            extent: ExtraSmall(),
                            color: textColor.withValues(alpha: 0.5)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
