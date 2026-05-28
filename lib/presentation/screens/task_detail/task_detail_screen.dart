import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/typography.dart';
import '../../../core/constants.dart';
import '../../../domain/models/task.dart';
import '../../providers/tasks_provider.dart';
import '../../widgets/nothing_button.dart';
import '../../widgets/nothing_input.dart';
import '../../widgets/nothing_date_picker.dart';
import '../../widgets/priority_selector.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final int? taskId;

  const TaskDetailScreen({super.key, this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _dueDate;
  Priority _priority = Priority.medium;
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get isEditing => widget.taskId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeForEdit(Task task) {
    if (_isInitialized) return;
    _titleController.text = task.title;
    _notesController.text = task.notes ?? '';
    _dueDate = task.dueDate;
    _priority = task.priority;
    _isInitialized = true;
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    setState(() => _isLoading = true);

    final notifier = ref.read(taskNotifierProvider.notifier);

    if (isEditing) {
      final existingTask = await ref.read(taskByIdProvider(widget.taskId!).future);
      if (existingTask != null) {
        await notifier.updateTask(existingTask.copyWith(
          title: title,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
        ));
      }
    } else {
      final now = DateTime.now();
      await notifier.createTask(Task(
        title: title,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        createdAt: now,
        updatedAt: now,
      ));
    }

    if (mounted) {
      context.pop();
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _DeleteConfirmationDialog(),
    );

    if (confirmed == true && widget.taskId != null) {
      setState(() => _isLoading = true);
      await ref.read(taskNotifierProvider.notifier).deleteTask(widget.taskId!);
      if (mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    final isMobile = MediaQuery.of(context).size.width < AppConstants.mobileBreakpoint;
    final horizontalPadding = isMobile ? AppConstants.spaceMd : AppConstants.spaceLg;

    if (isEditing) {
      final taskAsync = ref.watch(taskByIdProvider(widget.taskId!));
      return taskAsync.when(
        data: (Task? task) {
          if (task != null) {
            _initializeForEdit(task);
          }
          return _buildForm(context, colors, task != null, horizontalPadding);
        },
        loading: () => _buildLoading(colors),
        error: (e, _) => _buildError(colors, e.toString()),
      );
    }

    return _buildForm(context, colors, true, horizontalPadding);
  }

  Widget _buildForm(
    BuildContext context,
    AppColors colors,
    bool isValid,
    double horizontalPadding,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(horizontalPadding),
          child: Text(
            isEditing ? 'EDIT TASK' : 'NEW TASK',
            style: NothingTypography.heading(colors.textDisplay),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NothingInput(
                  label: 'TITLE',
                  hint: 'Task title',
                  controller: _titleController,
                  autofocus: !isEditing,
                  errorText: _titleController.text.isEmpty && _isLoading
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: AppConstants.spaceLg),
                NothingDatePicker(
                  selectedDate: _dueDate,
                  onChanged: (date) => setState(() => _dueDate = date),
                ),
                const SizedBox(height: AppConstants.spaceLg),
                PrioritySelector(
                  selected: _priority,
                  onChanged: (p) => setState(() => _priority = p),
                ),
                const SizedBox(height: AppConstants.spaceLg),
                NothingInput(
                  label: 'NOTES',
                  hint: 'Optional notes',
                  controller: _notesController,
                  maxLines: 4,
                ),
                const SizedBox(height: AppConstants.space2xl),
                Row(
                  children: [
                    if (isEditing)
                      Expanded(
                        child: NothingButton(
                          label: 'DELETE',
                          variant: NothingButtonVariant.destructive,
                          onPressed: _isLoading ? null : _delete,
                        ),
                      ),
                    if (isEditing) const SizedBox(width: AppConstants.spaceMd),
                    Expanded(
                      child: NothingButton(
                        label: isEditing ? 'UPDATE' : 'SAVE',
                        onPressed: _isLoading || !isValid ? null : _save,
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(AppColors colors) {
    return Center(
      child: SegmentedLoadingIndicator(color: colors.textSecondary),
    );
  }

  Widget _buildError(AppColors colors, String error) {
    return Center(
      child: Text(
        '[ERROR: $error]',
        style: NothingTypography.body(colors.accent),
      ),
    );
  }
}

class SegmentedLoadingIndicator extends StatefulWidget {
  final Color color;
  final int segmentCount;
  final double size;

  const SegmentedLoadingIndicator({
    super.key,
    required this.color,
    this.segmentCount = 8,
    this.size = 32,
  });

  @override
  State<SegmentedLoadingIndicator> createState() => _SegmentedLoadingIndicatorState();
}

class _SegmentedLoadingIndicatorState extends State<SegmentedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.segmentCount, (index) {
              final progress = (_controller.value * widget.segmentCount - index).clamp(0.0, 1.0);
              return Container(
                width: 3,
                height: widget.size * 0.6,
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: widget.color.withValues(alpha: 0.3 + (progress * 0.7)),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.light;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        side: BorderSide(color: colors.borderVisible),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'DELETE TASK?',
              style: NothingTypography.heading(colors.textDisplay),
            ),
            const SizedBox(height: AppConstants.spaceMd),
            Text(
              'This action cannot be undone.',
              style: NothingTypography.body(colors.textSecondary),
            ),
            const SizedBox(height: AppConstants.spaceLg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NothingButton(
                  label: 'CANCEL',
                  variant: NothingButtonVariant.ghost,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(width: AppConstants.spaceMd),
                NothingButton(
                  label: 'DELETE',
                  variant: NothingButtonVariant.destructive,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}