import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/settings_provider.dart';
import '../widgets/month_view.dart';
import '../widgets/week_view.dart';
import '../widgets/day_view.dart';
import '../widgets/agenda_view.dart';
import '../../events/screens/event_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentView = AppConstants.viewMonth;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  bool _bootstrapped = false;

  final _viewOptions = const [
    {
      'label': 'Month',
      'value': AppConstants.viewMonth,
      'icon': Icons.calendar_month
    },
    {'label': 'Week', 'value': AppConstants.viewWeek, 'icon': Icons.view_week},
    {'label': 'Day', 'value': AppConstants.viewDay, 'icon': Icons.view_day},
    {
      'label': 'Agenda',
      'value': AppConstants.viewAgenda,
      'icon': Icons.view_agenda
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_bootstrapped) {
      _bootstrapped = true;
      _bootstrap();
    }
  }

  Future<void> _bootstrap() async {
    await context.read<SettingsProvider>().load();
    await context.read<EventProvider>().load();
  }

  void _goToToday() {
    setState(() {
      _selectedDate = DateTime.now();
      _focusedDate = DateTime.now();
    });
  }

  void _navigate(int delta) {
    setState(() {
      switch (_currentView) {
        case AppConstants.viewMonth:
          _focusedDate =
              DateTime(_focusedDate.year, _focusedDate.month + delta, 1);
          break;
        case AppConstants.viewWeek:
          _focusedDate = _focusedDate.add(Duration(days: 7 * delta));
          break;
        case AppConstants.viewDay:
        case AppConstants.viewAgenda:
          _focusedDate = _focusedDate.add(Duration(days: delta));
          _selectedDate = _focusedDate;
          break;
      }
    });
  }

  String get _titleText {
    switch (_currentView) {
      case AppConstants.viewMonth:
        return DateFormat.yMMMM().format(_focusedDate);
      case AppConstants.viewWeek:
        final weekStart = DateUtilsX.startOfWeek(_focusedDate,
            context.select<SettingsProvider, int>((s) => s.weekStart));
        final weekEnd = weekStart.add(const Duration(days: 6));
        if (weekStart.month == weekEnd.month) {
          return '${DateFormat.MMMd().format(weekStart)} – ${DateFormat.MMMd().format(weekEnd)}, ${weekEnd.year}';
        }
        return '${DateFormat.MMMd().format(weekStart)} – ${DateFormat.MMMd().format(weekEnd)}';
      case AppConstants.viewDay:
      case AppConstants.viewAgenda:
        return DateFormat.yMMMMd().format(_focusedDate);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _navigate(-1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _navigate(1),
          ),
          IconButton(
            icon: const Icon(Icons.today_outlined),
            onPressed: _goToToday,
            tooltip: 'Today',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).pushNamed('/settings');
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
        title: Text(_titleText),
      ),
      body: Column(
        children: [
          _ViewSelector(
            options: _viewOptions,
            current: _currentView,
            onChanged: (v) => setState(() => _currentView = v),
          ),
          Expanded(
            child: _buildView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => EventFormScreen(
                initialDate: _selectedDate,
              ),
              fullscreenDialog: true,
            ),
          );
          if (result == true && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Event created'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Event'),
      ),
    );
  }

  Widget _buildView() {
    switch (_currentView) {
      case AppConstants.viewMonth:
        return MonthView(
          focusedDate: _focusedDate,
          selectedDate: _selectedDate,
          onDaySelected: (date) {
            setState(() {
              _selectedDate = date;
              _focusedDate = date;
            });
          },
          onPageChanged: (date) => setState(() => _focusedDate = date),
        );
      case AppConstants.viewWeek:
        return WeekView(
          focusedDate: _focusedDate,
          selectedDate: _selectedDate,
          onDaySelected: (d) => setState(() {
            _selectedDate = d;
            _focusedDate = d;
          }),
        );
      case AppConstants.viewDay:
        return DayView(
          date: _focusedDate,
          onDayChanged: (d) => setState(() {
            _focusedDate = d;
            _selectedDate = d;
          }),
        );
      case AppConstants.viewAgenda:
      default:
        return AgendaView(
          startDate: _focusedDate,
          onEventTap: (e) => _openEventDetail(e.id),
        );
    }
  }

  void _openEventDetail(String id) {
    Navigator.of(context).pushNamed('/event/$id');
  }
}

class _ViewSelector extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final String current;
  final ValueChanged<String> onChanged;

  const _ViewSelector({
    required this.options,
    required this.current,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: options.map((option) {
          final selected = current == option['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(option['value'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      option['icon'] as IconData,
                      size: 16,
                      color: selected
                          ? Colors.white
                          : theme.textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      option['label'] as String,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : theme.textTheme.bodySmall?.color,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
