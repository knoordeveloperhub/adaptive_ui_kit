import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_ui_kit/adaptive_ui_kit.dart';

void main() {
  // Optional: Configure global theme before running app
  AdaptiveUiKitConfig.glass = AdaptiveUiKitConfig.glass.copyWith(
    tintColor: Colors.blue,
    destructiveColor: Colors.red,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adaptive UI Kit Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  AdaptiveUiKit? _forcedUiKit;
  String _selectedItems = 'None';

  String get _uiModeLabel {
    if (_forcedUiKit == null) return 'Auto (platform default)';
    return _forcedUiKit == AdaptiveUiKit.glass ? 'Glass' : 'Material';
  }

  void _setUiMode(AdaptiveUiKit? kit) {
    setState(() {
      _forcedUiKit = kit;
      AdaptiveUiKitConfig.forceUiKit = kit;
    });
  }

  Widget _buildUiModeSelector(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UI Mode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Current: $_uiModeLabel',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Auto'),
                  selected: _forcedUiKit == null,
                  onSelected: (_) => _setUiMode(null),
                ),
                ChoiceChip(
                  label: const Text('Glass'),
                  selected: _forcedUiKit == AdaptiveUiKit.glass,
                  onSelected: (_) => _setUiMode(AdaptiveUiKit.glass),
                ),
                ChoiceChip(
                  label: const Text('Material'),
                  selected: _forcedUiKit == AdaptiveUiKit.material,
                  onSelected: (_) => _setUiMode(AdaptiveUiKit.material),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptive UI Kit Example'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Platform-Adaptive Components',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            _buildUiModeSelector(context),
            _buildSection(
              title: 'Date Picker',
              description:
                  'Shows a date picker (Glass calendar on iOS/macOS, native on Android)',
              onPressed: () => _showDatePicker(context),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Dialog',
              description:
                  'Shows a confirm dialog (Glass on iOS/macOS, Material on Android)',
              onPressed: () => _showConfirmDialog(context),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Action Sheet',
              description:
                  'Shows a list of actions (Glass on iOS/macOS, Material on Android)',
              onPressed: () => _showActionSheet(context),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Time Picker',
              description:
                  'Shows a time picker (Glass wheel on iOS/macOS, native on Android)',
              onPressed: () => _showTimePicker(context),
            ),
            const SizedBox(height: 16),
            _buildSection(
              title: 'Multi-Select',
              description:
                  'Shows a multi-select sheet (Glass on iOS/macOS, Material on Android)',
              onPressed: () => _showMultiSelect(context),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Selected Items:',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(_selectedItems),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                child: const Text('Show'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    final result = await AdaptiveDialog.showConfirm(
      context: context,
      title: 'Confirm Action',
      message: 'Do you want to proceed with this action?',
      confirmText: 'Yes',
      cancelText: 'No',
    );
    if (result == true) {
      _showSnackBar('Confirmed!');
    } else {
      _showSnackBar('Cancelled');
    }
  }

  Future<void> _showActionSheet(BuildContext context) async {
    await AdaptiveActionSheet.show(
      context: context,
      title: 'Choose an action',
      items: [
        ActionSheetItem(
          label: 'Edit',
          icon: CupertinoIcons.photo,
          onTap: () => _showSnackBar('Edit tapped'),
        ),
        ActionSheetItem(
          label: 'Share',
          icon: CupertinoIcons.share,
          onTap: () => _showSnackBar('Share tapped'),
        ),
        ActionSheetItem(
          label: 'Delete',
          icon: CupertinoIcons.trash,
          isDestructive: true,
          onTap: () => _showSnackBar('Delete tapped'),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final date = await AdaptiveDateTimePicker.showDate(
      context: context,
      initialDate: DateTime.now(),
    );
    if (date != null) {
      _showSnackBar(
          'Selected date: ${date.toLocal().toString().split(' ')[0]}');
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final time = await AdaptiveTimePicker.show(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      _showSnackBar('Selected time: ${time.toString()}');
    }
  }

  Future<void> _showMultiSelect(BuildContext context) async {
    final selected = await AdaptiveMultiSelect.show(
      context: context,
      title: 'Select items',
      options: [
        const MultiSelectOption(id: '1', label: 'Option 1'),
        const MultiSelectOption(id: '2', label: 'Option 2'),
        const MultiSelectOption(id: '3', label: 'Option 3'),
        const MultiSelectOption(id: '4', label: 'Option 4'),
      ],
    );
    if (selected != null && selected.isNotEmpty) {
      setState(() {
        _selectedItems = selected.join(', ');
      });
      _showSnackBar('Selected: ${selected.join(", ")}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
