import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_widgets.dart';
import '../../data/models/onboarding_profile.dart';
import '../../services/app_state.dart';

/// The full onboarding experience that builds a learner profile.
///
/// Steps: Welcome → Language → Goals → Reading level → Tajweed →
/// Memorization → Practice frequency → Review.
class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;

  ReadingLevel _reading = ReadingLevel.beginner;
  TajweedLevel _tajweed = TajweedLevel.none;
  MemorizationLevel _memorization = MemorizationLevel.none;
  PracticeFrequency _frequency = PracticeFrequency.daily;
  final List<LearningGoal> _goals = [];
  String _languageCode = 'en';

  static const int _totalSteps = 6;

  void _next() {
    if (_step == _totalSteps - 1) {
      _finish();
      return;
    }
    setState(() => _step++);
  }

  void _finish() {
    final onboarding = OnboardingProfile(
      locale: Locale(_languageCode),
      goals: _goals,
      readingLevel: _reading,
      tajweedLevel: _tajweed,
      memorizationLevel: _memorization,
      frequency: _frequency,
    );
    context.read<AppState>().completeOnboarding(onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                child: _buildStep(context, key: ValueKey(_step)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        children: [
          if (_step > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: _step / (_totalSteps - 1),
                minHeight: 5,
                backgroundColor: Theme.of(context).dividerColor,
              ),
            )
          else
            const SizedBox(height: 5),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'AmiriQuran'),
              ),
              const Spacer(),
              if (_step > 0)
                TextButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Back'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep(BuildContext context, {required Key key}) {
    switch (_step) {
      case 0:
        return _Welcome(key: key, onNext: _next);
      case 1:
        return _Language(key: key, value: _languageCode, onChange: (v) => setState(() => _languageCode = v), onNext: _next);
      case 2:
        return _Goals(
          key: key,
          goals: _goals,
          onToggle: (g) => setState(() => _goals.contains(g) ? _goals.remove(g) : _goals.add(g)),
          onNext: _next,
        );
      case 3:
        return _ReadingStep(
          key: key,
          value: _reading,
          onChanged: (v) => setState(() => _reading = v),
          onNext: _next,
        );
      case 4:
        return _TajweedStep(
          key: key,
          value: _tajweed,
          onChanged: (v) => setState(() => _tajweed = v),
          onNext: _next,
          memorization: _memorization,
          onMemorization: (v) => setState(() => _memorization = v),
        );
      case 5:
        return _FrequencyStep(
          key: key,
          value: _frequency,
          onChanged: (v) => setState(() => _frequency = v),
          onFinish: _finish,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.icon, required this.title, required this.subtitle, required this.child});
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 26),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Icon(Icons.menu_book_rounded, size: 72, color: scheme.primary),
          const SizedBox(height: 24),
          Text(
            'Welcome to AyahPath',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 12),
          Text(
            AppConstants.tagline,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 16),
          Text(
            'AyahPath learns how you learn. It will assess where you are, build a '
            'personalized plan, listen to your reading on-device, and adapt every '
            'lesson to your progress.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onNext, child: const Text('Begin my journey')),
          ),
        ],
      ),
    );
  }
}

class _Language extends StatelessWidget {
  const _Language({super.key, required this.value, required this.onChange, required this.onNext});
  final String value;
  final ValueChanged<String> onChange;
  final VoidCallback onNext;

  static const _languages = [
    ('en', 'English', 'العربية interface is coming soon'),
    ('ar', 'العربية', 'Arabic'),
  ];

  @override
  Widget build(BuildContext context) {
    return _OptionListStep(
      key: key,
      icon: Icons.translate,
      title: 'Choose your language',
      subtitle: 'AyahPath will use this language for the interface.',
      options: const [
        ('English', 'Start with English as the interface language'),
        ('العربية', 'الواجهة باللغة العربية'),
      ],
      selected: value == 'ar' ? 1 : 0,
      onSelect: (i) => onChange(_languages[i].$1),
      onPrimary: onNext,
    );
  }
}

class _Goals extends StatelessWidget {
  const _Goals({super.key, required this.goals, required this.onToggle, required this.onNext});
  final List<LearningGoal> goals;
  final ValueChanged<LearningGoal> onToggle;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.flag_rounded,
      title: 'What do you want to achieve?',
      subtitle: 'Select all that apply. AyahPath weaves these into your daily plan.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final g in LearningGoal.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectableRow(
                selected: goals.contains(g),
                title: g.label,
                subtitle: g.subtitle,
                icon: Icons.check_rounded,
                onTap: () => onToggle(g),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReadingStep extends StatelessWidget {
  const _ReadingStep({super.key, required this.value, required this.onChanged, required this.onNext});
  final ReadingLevel value;
  final ValueChanged<ReadingLevel> onChanged;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return _OptionListStep(
      key: key,
      icon: Icons.abc,
      title: 'How is your Arabic reading?',
      subtitle: 'This helps us start at the right level.',
      options: ReadingLevel.values.map((l) => (l.label, l.subtitle)).toList(),
      selected: value.index,
      onSelect: (i) => onChanged(ReadingLevel.values[i]),
      onPrimary: onNext,
    );
  }
}

class _TajweedStep extends StatelessWidget {
  const _TajweedStep({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onNext,
    required this.memorization,
    required this.onMemorization,
  });
  final TajweedLevel value;
  final ValueChanged<TajweedLevel> onChanged;
  final VoidCallback onNext;
  final MemorizationLevel memorization;
  final ValueChanged<MemorizationLevel> onMemorization;

  @override
  Widget build(BuildContext context) {
    return _OptionListStep(
      key: key,
      icon: Icons.hearing_rounded,
      title: 'About Tajweed & memorization',
      subtitle: 'Two quick questions about your background.',
      extraAbove: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How familiar are you with Tajweed?', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          ...List.generate(TajweedLevel.values.length, (i) {
            final t = TajweedLevel.values[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectableRow(
                selected: value.index == i,
                title: t.label,
                subtitle: t.subtitle,
                icon: Icons.check_rounded,
                onTap: () => onChanged(t),
              ),
            );
          }),
        ],
      ),
      options: MemorizationLevel.values.map((m) => (m.label, m.subtitle)).toList(),
      selected: memorization.index,
      optionTitle: 'How much have you memorized?',
      onSelect: (i) => onMemorization(MemorizationLevel.values[i]),
      onPrimary: onNext,
    );
  }
}

class _FrequencyStep extends StatelessWidget {
  const _FrequencyStep({super.key, required this.value, required this.onChanged, required this.onFinish});
  final PracticeFrequency value;
  final ValueChanged<PracticeFrequency> onChanged;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    return _OptionListStep(
      key: key,
      icon: Icons.calendar_today_rounded,
      title: 'How often will you practice?',
      subtitle: 'We’ll size each lesson to fit your rhythm.',
      options: PracticeFrequency.values.map((f) => ('${f.label} · ~${f.minutesPerSession} min', 'A consistent habit builds steady progress')).toList(),
      selected: value.index,
      primaryLabel: 'Create my personalized plan',
      onSelect: (i) => onChanged(PracticeFrequency.values[i]),
      onPrimary: onFinish,
    );
  }
}

/// A step with uniform selectable option cards.
class _OptionListStep extends StatelessWidget {
  const _OptionListStep({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.onSelect,
    required this.onPrimary,
    this.optionTitle,
    this.extraAbove,
    this.primaryLabel = 'Continue',
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final List<(String, String)> options;
  final int selected;
  final ValueChanged<int> onSelect;
  final VoidCallback onPrimary;
  final String? optionTitle;
  final Widget? extraAbove;
  final String primaryLabel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 26),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          if (extraAbove != null) ...[extraAbove!, const SizedBox(height: 4)],
          if (optionTitle != null) ...[
            Text(optionTitle!, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
          ],
          for (var i = 0; i < options.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectableRow(
                selected: i == selected,
                title: options[i].$1,
                subtitle: options[i].$2,
                icon: Icons.radio_button_checked_rounded,
                onTap: () => onSelect(i),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: selected >= 0 ? onPrimary : null,
              child: Text(primaryLabel),
            ),
          ),
        ],
      ),
    );
  }
}

/// A tappable selectable row card.
class _SelectableRow extends StatelessWidget {
  const _SelectableRow({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      color: selected ? scheme.primary.withValues(alpha: 0.12) : null,
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? scheme.primary : scheme.outlineVariant,
                width: 2,
              ),
              color: selected ? scheme.primary : Colors.transparent,
            ),
            child: selected
                ? Icon(icon, size: 16, color: scheme.onPrimary)
                : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
