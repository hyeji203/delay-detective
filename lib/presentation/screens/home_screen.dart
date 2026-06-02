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
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        const labels = ['월', '화', '수', '목', '금', '토', '일'];
                        final label = labels[day.weekday - 1];
                        final isRedHeader = day.weekday == DateTime.sunday;
                        final isBlueHeader = day.weekday == DateTime.saturday;
                        return Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isRedHeader
                                  ? const Color(0xFFEF5350)
                                  : isBlueHeader
                                      ? const Color(0xFF3F51B5)
                                      : const Color(0xFF9E9EAE),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        if (_isRedDay(day)) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Color(0xFFEF5350),
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                        if (_isSaturday(day)) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Color(0xFF3F51B5),
                                fontSize: 14,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        if (_isRedDay(day)) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Color(0xFFEF5350),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }
                        if (_isSaturday(day)) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Color(0xFF3F51B5),
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          );
                        }
                        return null;
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
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFF3F51B5).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        color: Color(0xFF3F51B5),
                        fontWeight: FontWeight.w700,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Color(0xFF3F51B5),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Color(0xFFEF5350),
                        shape: BoxShape.circle,
                      ),
                      markerSize: 5,
                      markersMaxCount: 3,
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
