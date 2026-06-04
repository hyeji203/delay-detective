import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/sync_banner.dart';

// 한국 공휴일
final Set<DateTime> _holidays = {
  DateTime(2026, 1, 1),
  DateTime(2026, 1, 28), DateTime(2026, 1, 29), DateTime(2026, 1, 30),
  DateTime(2026, 3, 1),
  DateTime(2026, 5, 5),
  DateTime(2026, 5, 24),
  DateTime(2026, 6, 6),
  DateTime(2026, 8, 15),
  DateTime(2026, 9, 24), DateTime(2026, 9, 25), DateTime(2026, 9, 26),
  DateTime(2026, 10, 3),
  DateTime(2026, 10, 9),
  DateTime(2026, 12, 25),
};

bool _isHoliday(DateTime day) =>
    _holidays.any((h) => h.year == day.year && h.month == day.month && h.day == day.day);

bool _isRedDay(DateTime day) =>
    day.weekday == DateTime.sunday || _isHoliday(day);

bool _isSaturday(DateTime day) => day.weekday == DateTime.saturday;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) context.read<TaskProvider>().loadTasks();
    });
  }

  List<Task> _getTasksForDay(List<Task> allTasks, DateTime day) {
    return allTasks.where((task) {
      if (task.dueDate == null) return false;
      return isSameDay(task.dueDate!, day);
    }).toList();
  }

  List<Task> _getTasksWithoutDate(List<Task> allTasks) {
    return allTasks.where((t) => t.dueDate == null).toList();
  }

  Widget _taskChip(Task task) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      constraints: const BoxConstraints(maxWidth: 46),
      decoration: BoxDecoration(
        color: task.isDelayed
            ? const Color(0xFFEF5350).withOpacity(0.12)
            : const Color(0xFF3F51B5).withOpacity(0.10),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        task.title,
        style: TextStyle(
          fontSize: 9,
          color: task.isDelayed
              ? const Color(0xFFEF5350)
              : const Color(0xFF3F51B5),
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _dayCell(
    DateTime day,
    List<Task> tasks, {
    BoxDecoration? circleDeco,
    TextStyle? numStyle,
  }) {
    final numWidget = circleDeco != null
        ? Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: circleDeco,
            child: Text('${day.day}', style: numStyle),
          )
        : SizedBox(
            width: 30,
            height: 30,
            child: Center(child: Text('${day.day}', style: numStyle)),
          );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        numWidget,
        ...tasks.take(2).map(_taskChip),
        if (tasks.length > 2)
          Text('+${tasks.length - 2}',
              style: const TextStyle(fontSize: 8, color: Color(0xFF9E9EAE))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = [...taskProvider.delayedTasks, ...taskProvider.normalTasks];
    final selectedTasks = _getTasksForDay(allTasks, _selectedDay);
    final noDateTasks = _getTasksWithoutDate(allTasks);
    final isToday = isSameDay(_selectedDay, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delay Detective'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF5)),
        ),
      ),
      body: Column(
        children: [
          const SyncBanner(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                // 캘린더
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TableCalendar<Task>(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2027, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) => _getTasksForDay(allTasks, day),
                    calendarFormat: CalendarFormat.month,
                    rowHeight: 72,
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        const labels = ['월', '화', '수', '목', '금', '토', '일'];
                        final label = labels[day.weekday - 1];
                        return Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: day.weekday == DateTime.sunday
                                  ? const Color(0xFFEF5350)
                                  : day.weekday == DateTime.saturday
                                      ? const Color(0xFF3F51B5)
                                      : const Color(0xFF9E9EAE),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        final tasks = _getTasksForDay(allTasks, day);
                        final color = _isRedDay(day)
                            ? const Color(0xFFEF5350)
                            : _isSaturday(day)
                                ? const Color(0xFF3F51B5)
                                : const Color(0xFF1A1A2E);
                        return _dayCell(day, tasks,
                            numStyle: TextStyle(fontSize: 14, color: color));
                      },
                      todayBuilder: (context, day, focusedDay) {
                        final tasks = _getTasksForDay(allTasks, day);
                        return _dayCell(
                          day, tasks,
                          circleDeco: BoxDecoration(
                            color: const Color(0xFF3F51B5).withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          numStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF3F51B5),
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        final tasks = _getTasksForDay(allTasks, day);
                        return _dayCell(
                          day, tasks,
                          circleDeco: const BoxDecoration(
                            color: Color(0xFF3F51B5),
                            shape: BoxShape.circle,
                          ),
                          numStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Color(0xFF3F51B5),
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Color(0xFF3F51B5),
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                      markersMaxCount: 0,
                    ),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                    },
                    onPageChanged: (focused) {
                      setState(() => _focusedDay = focused);
                    },
                  ),
                ),

                // 선택된 날짜 섹션
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Container(
                        width: 3, height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F51B5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isToday
                            ? '오늘 ${_selectedDay.month}/${_selectedDay.day}'
                            : '${_selectedDay.month}/${_selectedDay.day}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      if (selectedTasks.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3F51B5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${selectedTasks.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (selectedTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '이 날 할 일이 없어요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9EAE),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: selectedTasks
                          .map((t) => TaskCard(
                                task: t,
                                isDelayed: t.isDelayed,
                              ))
                          .toList(),
                    ),
                  ),

                // 날짜 없는 태스크
                if (noDateTasks.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 3, height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9E9EAE),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '마감일 없음',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF9E9EAE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: noDateTasks
                          .map((t) => TaskCard(
                                task: t,
                                isDelayed: t.isDelayed,
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-task'),
        icon: const Icon(Icons.add),
        label: const Text('할 일 추가'),
        backgroundColor: const Color(0xFF3F51B5),
        foregroundColor: Colors.white,
      ),
    );
  }
}
