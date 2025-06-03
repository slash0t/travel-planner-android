import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/todo_ai_creation_view_model.dart';
import 'package:putevod/view/screens/todo_item_detail_screen.dart';
import 'package:putevod/view-model/todo_list_view_model.dart'; // Required for provider

class TodoAICreationScreen extends StatefulWidget {
  const TodoAICreationScreen({super.key});

  @override
  State<TodoAICreationScreen> createState() => _TodoAICreationScreenState();
}

class _TodoAICreationScreenState extends State<TodoAICreationScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final todoListViewModel = Provider.of<TodoListViewModel>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => TodoAICreationViewModel(todoListViewModel),
      child: Consumer<TodoAICreationViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.text),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Генерация списка',
                style: TextStyle(
                    fontFamily: 'NotoSans', color: AppColors.text, fontSize: 20),
              ),
              // actions: [
              //   IconButton(
              //     icon: const Icon(Icons.info_outline, color: AppColors.text),
              //     onPressed: () {
              //       // TODO: Implement info dialog
              //     },
              //   ),
              // ],
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        // _buildDataSourceButtons(viewModel),
                        // const SizedBox(height: 16),
                        _buildTripTypeDropdown(viewModel),
                        const SizedBox(height: 16),
                        _buildDirectionInput(viewModel),
                        const SizedBox(height: 16),
                        _buildSeasonSelector(viewModel),
                        const SizedBox(height: 16),
                        _buildDurationInput(viewModel),
                        const SizedBox(height: 16),
                        _buildAdditionalInfoInput(viewModel),
                        const SizedBox(height: 24),
                        _buildGenerateButton(context, viewModel),
                      ],
                    ),
                  ),
                ),
                if (viewModel.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDataSourceButtons(TodoAICreationViewModel viewModel) {
    // For now, only "New Trip" is active
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Выберите источник данных',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'NotoSans'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implement existing trip selection
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white, // AppColors.cardBackground,
                  side: const BorderSide(color: AppColors.accent, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Column(
                  children: [
                    Text('Существующая', style: TextStyle(color: AppColors.accent, fontFamily: 'NotoSans', fontSize: 16)),
                    Text('поездка', style: TextStyle(color: AppColors.accent, fontFamily: 'NotoSans', fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Новая поездка', style: TextStyle(color: Colors.white, fontFamily: 'NotoSans', fontSize: 16), textAlign: TextAlign.center,),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTripTypeDropdown(TodoAICreationViewModel viewModel) {
    return _buildFormSection(
      label: 'Тип поездки',
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(hintText: 'Выберите тип поездки'),
        value: viewModel.tripType,
        hint: const Text('Выберите тип поездки', style: TextStyle(fontFamily: 'NotoSans', color: AppColors.text)),
        onChanged: (value) => viewModel.setTripType(value),
        items: viewModel.tripTypes
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type, style: const TextStyle(fontFamily: 'NotoSans')),
                ))
            .toList(),
        validator: (value) => value == null ? 'Пожалуйста, выберите тип поездки' : null,
        style: const TextStyle(fontFamily: 'NotoSans', color: AppColors.text, fontSize: 16),
      ),
    );
  }

  Widget _buildDirectionInput(TodoAICreationViewModel viewModel) {
    return _buildFormSection(
      label: 'Направление',
      child: TextFormField(
        initialValue: viewModel.direction,
        decoration: _inputDecoration(hintText: 'Введите город или страну').copyWith(
            suffixIcon: const Icon(Icons.location_on, color: AppColors.accent)),
        onChanged: (value) => viewModel.setDirection(value),
        validator: (value) => (value == null || value.isEmpty) ? 'Пожалуйста, введите направление' : null,
        style: const TextStyle(fontFamily: 'NotoSans', color: AppColors.text, fontSize: 16),
      ),
    );
  }

  Widget _buildSeasonSelector(TodoAICreationViewModel viewModel) {
    final seasonEntries = viewModel.seasons.entries.toList();
    return _buildFormSection(
      label: 'Сезон',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSeasonButton(viewModel, seasonEntries[0])),
              const SizedBox(width: 8),
              Expanded(child: _buildSeasonButton(viewModel, seasonEntries[1])),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSeasonButton(viewModel, seasonEntries[2])),
              const SizedBox(width: 8),
              Expanded(child: _buildSeasonButton(viewModel, seasonEntries[3])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonButton(TodoAICreationViewModel viewModel, MapEntry<String, String> entry) {
    final isSelected = viewModel.season == entry.key;
    return ElevatedButton(
      onPressed: () => viewModel.setSeason(entry.key),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.secondary : Colors.white,
        foregroundColor: AppColors.text,
        elevation: isSelected ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isSelected ? BorderSide.none : BorderSide(color: Colors.grey.shade300)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Adjusted padding
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(entry.value, style: const TextStyle(fontSize: 20, fontFamily: 'NotoSans')), // Emoji
            const SizedBox(height: 4),
            Text(entry.key, style: const TextStyle(fontSize: 14, fontFamily: 'NotoSans')),
          ]
      ),
    );
  }

  Widget _buildDurationInput(TodoAICreationViewModel viewModel) {
    return _buildFormSection(
      label: 'Продолжительность',
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: TextFormField(
              initialValue: viewModel.duration.toString(),
              decoration: _inputDecoration(hintText: '7'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                final intValue = int.tryParse(value);
                if (intValue != null) {
                  viewModel.setDuration(intValue);
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) return 'Введите дни';
                if (int.tryParse(value) == null || int.parse(value) <= 0) return ' > 0 ';
                return null;
              },
              style: const TextStyle(fontFamily: 'NotoSans', color: AppColors.text, fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          const Text('дней', style: TextStyle(fontFamily: 'NotoSans', fontSize: 16, color: AppColors.text)),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoInput(TodoAICreationViewModel viewModel) {
    return _buildFormSection(
      label: 'Дополнительная информация',
      child: TextFormField(
        initialValue: viewModel.additionalInfo,
        decoration: _inputDecoration(hintText: 'Укажите любые дополнительные пожелания'),
        onChanged: (value) => viewModel.setAdditionalInfo(value),
        maxLines: 3,
        style: const TextStyle(fontFamily: 'NotoSans', color: AppColors.text, fontSize: 16),
      ),
    );
  }

  Widget _buildFormSection({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'NotoSans', fontSize: 14, color: AppColors.text),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(fontFamily: 'NotoSans', color: AppColors.text, fontSize: 16),
      filled: true,
      fillColor: AppColors.background, // Figma shows #E7E4DC for input field background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildGenerateButton(BuildContext context, TodoAICreationViewModel viewModel) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
      label: const Text(
        'Сгенерировать список',
        style: TextStyle(color: Colors.white, fontFamily: 'NotoSans', fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: viewModel.isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                if (viewModel.season == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пожалуйста, выберите сезон')),
                  );
                  return;
                }
                final newId = await viewModel.generateTodoList();
                if (mounted && newId != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => TodoItemDetailScreen(todoItemId: newId),
                    ),
                  );
                }
              }
            },
    );
  }
} 