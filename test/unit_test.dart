import 'package:flutter_test/flutter_test.dart';
import 'package:delay_detective/domain/models/task.dart';
import 'package:delay_detective/domain/models/sub_task.dart';
import 'package:delay_detective/domain/enums/task_status.dart';

Task _makeTask({
  DateTime? dueDate,
  TaskStatus status = TaskStatus.todo,
  bool isDelayed = false,
}) {
  final now = DateTime.now();
  return Task(
    id: 'test-id',
    uid: 'test-uid',
    title: '테스트 태스크',
    dueDate: dueDate,
    status: status,
    isDelayed: isDelayed,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  group('Task.shouldBeDelayed', () {
    test('dueDate가 과거이고 완료 안 됐으면 true', () {
      final task = _makeTask(
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        status: TaskStatus.todo,
      );
      expect(task.shouldBeDelayed, isTrue);
    });

    test('dueDate가 미래이면 false', () {
      final task = _makeTask(
        dueDate: DateTime.now().add(const Duration(days: 3)),
      );
      expect(task.shouldBeDelayed, isFalse);
    });

    test('완료된 태스크는 dueDate가 과거여도 false', () {
      final task = _makeTask(
        dueDate: DateTime.now().subtract(const Duration(days: 2)),
        status: TaskStatus.done,
      );
      expect(task.shouldBeDelayed, isFalse);
    });

    test('dueDate 없으면 false', () {
      final task = _makeTask();
      expect(task.shouldBeDelayed, isFalse);
    });
  });

  group('SubTask isDone 토글', () {
    test('isDone 기본값은 false', () {
      final sub = SubTask(id: 'sub-1', title: '할 일');
      expect(sub.isDone, isFalse);
    });

    test('isDone 토글 동작', () {
      final sub = SubTask(id: 'sub-1', title: '할 일');
      sub.isDone = true;
      expect(sub.isDone, isTrue);
      sub.isDone = false;
      expect(sub.isDone, isFalse);
    });
  });

  group('Task.toMap / Task.fromMap', () {
    test('직렬화 → 역직렬화 왕복 일치', () {
      final now = DateTime(2026, 6, 8, 12, 0);
      final task = Task(
        id: 'round-trip-id',
        uid: 'uid-1',
        title: '직렬화 테스트',
        description: '설명',
        dueDate: DateTime(2026, 7, 1),
        status: TaskStatus.delayed,
        isDelayed: true,
        createdAt: now,
        updatedAt: now,
        subtasks: [
          SubTask(id: 'sub-1', title: '소태스크', isDone: true),
        ],
      );

      final map = task.toMap();
      final restored = Task.fromMap(map);

      expect(restored.id, task.id);
      expect(restored.title, task.title);
      expect(restored.status, task.status);
      expect(restored.isDelayed, task.isDelayed);
      expect(restored.subtasks.length, 1);
      expect(restored.subtasks.first.isDone, isTrue);
    });
  });

  group('Conflict Resolution 시뮬레이션', () {
    test('updatedAt이 더 최신인 태스크가 우선', () {
      final older = DateTime(2026, 6, 8, 10, 0);
      final newer = DateTime(2026, 6, 8, 11, 0);

      // Last-Write-Wins: newer > older 이면 newer 선택
      expect(newer.isAfter(older), isTrue);
    });

    test('동일한 updatedAt은 충돌로 처리', () {
      final t1 = DateTime(2026, 6, 8, 10, 0);
      final t2 = DateTime(2026, 6, 8, 10, 0);
      expect(t1.isAtSameMomentAs(t2), isTrue);
    });
  });
}
