// 이 테스트는 Firebase 초기화가 필요합니다.
// Firebase Emulator 설정 후 실행하거나, 실기기/시뮬레이터에서 flutter test -d 로 실행하세요.
// 단위 테스트는 test/unit_test.dart 를 사용하세요.
import 'package:flutter_test/flutter_test.dart';
import 'package:delay_detective/domain/models/task.dart';
import 'package:delay_detective/domain/enums/task_status.dart';

void main() {
  // Firebase 의존성 없이 검증 가능한 도메인 레이어 스모크 테스트
  test('Task 생성 — 기본값 확인', () {
    final now = DateTime(2026, 6, 15);
    final task = Task(
      id: 'smoke-id',
      uid: 'uid-1',
      title: '스모크 테스트 태스크',
      status: TaskStatus.todo,
      isDelayed: false,
      createdAt: now,
      updatedAt: now,
    );

    expect(task.id, 'smoke-id');
    expect(task.status, TaskStatus.todo);
    expect(task.subtasks, isEmpty);
    expect(task.analysis, isNull);
  });

  test('Task.shouldBeDelayed — 내일 마감은 false', () {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    final task = Task(
      id: 'tomorrow-task',
      uid: 'uid-1',
      title: '내일 마감',
      dueDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59),
      status: TaskStatus.todo,
      isDelayed: false,
      createdAt: now,
      updatedAt: now,
    );
    expect(task.shouldBeDelayed, isFalse);
  });
}
