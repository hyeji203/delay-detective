import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../application/task_provider.dart';
import '../../application/auth_provider.dart';
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

String _formatMonthTitle(DateTime date, dynamic locale) => '${date.month}월';

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

  void _showDaySheet(BuildContext context, DateTime day) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Consumer<TaskProvider>(
        builder: (ctx, taskProvider, _) {
          final allTasks = [
            ...taskProvider.delayedTasks,
            ...taskProvider.normalTasks,
          ];
          final dayTasks = _getTasksForDay(allTasks, day);
          final noDateTasks = _getTasksWithoutDate(allTasks);
          final isToday = isSameDay(day, DateTime.now());

          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8F8FC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 8, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3F51B5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isToday
                            ? '오늘 ${day.month}/${day.day}'
                            : '${day.month}/${day.day}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3F51B5),
                        ),
                      ),
                      if (dayTasks.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3F51B5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${dayTasks.length}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3F51B5),
                            ),
                          ),
                        ),
                      ],
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushNamed(
                            context,
                            '/add-task',
                            arguments: day,
                          );
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('할일 추가'),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF3F51B5),
                          textStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (dayTasks.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        '이 날 할일이 없어요',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF9E9EAE),
                        ),
                      ),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(ctx).size.height * 0.45,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: dayTasks
                          .map((t) =>
                              TaskCard(task: t, isDelayed: t.isDelayed))
                          .toList(),
                    ),
                  ),
                if (noDateTasks.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Container(
                          width: 3,
                          height: 16,
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(ctx).size.height * 0.25,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: noDateTasks
                          .map((t) =>
                              TaskCard(task: t, isDelayed: t.isDelayed))
                          .toList(),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    int year = _focusedDay.year;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
          contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF3F51B5)),
                onPressed: () => setDialog(() => year--),
              ),
              Text('$year년',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFF3F51B5)),
                onPressed: () => setDialog(() => year++),
              ),
            ],
          ),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(12, (i) {
              final month = i + 1;
              final isSelected =
                  year == _focusedDay.year && month == _focusedDay.month;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _focusedDay = DateTime(year, month);
                  });
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: 72,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF3F51B5)
                        : const Color(0xFFF3F4F8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$month월',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF1A1A2E),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _taskChip(Task task) {
    final hasAnalysis = task.analysis != null;
    final Color chipColor;
    final Color textColor;

    if (hasAnalysis) {
      chipColor = const Color(0xFF7B61FF).withOpacity(0.12);
      textColor = const Color(0xFF7B61FF);
    } else if (task.isDelayed) {
      chipColor = const Color(0xFFEF5350).withOpacity(0.12);
      textColor = const Color(0xFFEF5350);
    } else {
      chipColor = const Color(0xFF3F51B5).withOpacity(0.10);
      textColor = const Color(0xFF3F51B5);
    }

    return Container(
      margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      width: double.infinity,
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasAnalysis)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(Icons.check_circle, size: 8, color: textColor),
            ),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 9,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
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

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 3),
          numWidget,
          ...tasks.take(2).map(_taskChip),
          if (tasks.length > 2)
            Text('+${tasks.length - 2}',
                style: const TextStyle(fontSize: 8, color: Color(0xFF9E9EAE))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final allTasks = [...taskProvider.delayedTasks, ...taskProvider.normalTasks];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delay Detective'),
        actions: [
          _ProfileButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF5)),
        ),
      ),
      body: Column(
        children: [
          const SyncBanner(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                const headerHeight = 52.0;
                const dowHeight = 28.0;
                final rowHeight =
                    (constraints.maxHeight - headerHeight - dowHeight) / 6;
                return Container(
                  color: Colors.white,
                  child: TableCalendar<Task>(
                    firstDay: DateTime.utc(2024, 1, 1),
                    lastDay: DateTime.utc(2027, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    eventLoader: (day) => _getTasksForDay(allTasks, day),
                    calendarFormat: CalendarFormat.month,
                    daysOfWeekHeight: dowHeight,
                    rowHeight: rowHeight,
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
                      titleTextFormatter: _formatMonthTitle,
                    ),
                    onHeaderTapped: (_) => _showMonthPicker(context),
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                      markersMaxCount: 0,
                    ),
                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                      _showDaySheet(context, selected);
                    },
                    onPageChanged: (focused) {
                      setState(() => _focusedDay = focused);
                    },
                  ),
                );
              },
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

class _ProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final initial = (auth.displayName?.isNotEmpty == true
            ? auth.displayName![0]
            : auth.email?.isNotEmpty == true
                ? auth.email![0]
                : '?')
        .toUpperCase();

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => _showProfileSheet(context, auth),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF3F51B5),
          child: Text(
            initial,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context, AuthProvider auth) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF3F51B5),
              child: Text(
                (auth.displayName?.isNotEmpty == true
                        ? auth.displayName![0]
                        : auth.email?[0] ?? '?')
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (auth.displayName != null)
              Text(
                auth.displayName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            if (auth.email != null)
              Text(
                auth.email!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E9EAE),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  Navigator.pop(ctx);
                  await auth.signOut();
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('로그아웃'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF5350),
                  side: const BorderSide(color: Color(0xFFEF5350)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
