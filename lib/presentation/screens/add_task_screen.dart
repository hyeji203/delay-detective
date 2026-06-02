import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _dueDate;
  bool _saving = false;
  Task? _editingTask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_editingTask == null) {
      final task = ModalRoute.of(context)?.settings.arguments as Task?;
      if (task != null) {
        _editingTask = task;
        _titleController.text = task.title;
        _descController.text = task.description ?? '';
        _dueDate = task.dueDate;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF3F51B5)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final provider = context.read<TaskProvider>();
    final now = DateTime.now();

    if (_editingTask != null) {
      _editingTask!.title = _titleController.text.trim();
      _editingTask!.description = _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim();
      _editingTask!.dueDate = _dueDate;
      _editingTask!.updatedAt = now;
      await provider.updateTask(_editingTask!);
    } else {
      final task = Task(
        id: 'task_${now.millisecondsSinceEpoch}',
        uid: 'anonymous-placeholder',
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        dueDate: _dueDate,
        createdAt: now,
        updatedAt: now,
      );
      await provider.addTask(task);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingTask != null ? '할 일 수정' : '할 일 추가'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFEEEEF5)),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              '무엇을 해야 하나요?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E9EAE),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: '예: 발표 준비하기',
                hintStyle: TextStyle(color: Color(0xFFBBBBC8)),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '할 일을 입력해주세요' : null,
              autofocus: true,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            const Text(
              '메모 (선택)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E9EAE),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                hintText: '추가 설명을 입력하세요',
                hintStyle: TextStyle(color: Color(0xFFBBBBC8)),
              ),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 20),
            const Text(
              '마감일 (선택)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9E9EAE),
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Color(0xFF3F51B5),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _dueDate == null
                          ? '날짜 선택'
                          : '${_dueDate!.year}.${_dueDate!.month}.${_dueDate!.day}',
                      style: TextStyle(
                        fontSize: 15,
                        color: _dueDate == null
                            ? const Color(0xFFBBBBC8)
                            : const Color(0xFF1A1A2E),
                        fontWeight: _dueDate == null
                            ? FontWeight.normal
                            : FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    if (_dueDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _dueDate = null),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF9E9EAE),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _editingTask != null ? '수정 완료' : '저장',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
