import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/model/place.dart';
import 'package:putevod/view-model/place_editing_view_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// Screen for creating or editing a place
class PlaceEditingScreen extends StatefulWidget {
  /// ID of the place to edit, null for creation mode
  final String? placeId;
  
  /// Trip ID for context
  final int tripId;
  
  /// Day ID for context
  final int dayId;

  /// Creates a new place editing screen in create mode
  const PlaceEditingScreen.create({
    super.key,
    required this.tripId,
    required this.dayId,
  }) : placeId = null;

  /// Creates a new place editing screen in update mode
  const PlaceEditingScreen.update({
    super.key,
    required this.placeId,
    required this.tripId,
    required this.dayId,
  });

  @override
  State<PlaceEditingScreen> createState() => _PlaceEditingScreenState();
}

class _PlaceEditingScreenState extends State<PlaceEditingScreen> {
  late PlaceEditingViewModel _viewModel;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _viewModel = PlaceEditingViewModel(
      isCreateMode: widget.placeId == null,
      tripId: widget.tripId,
      dayId: widget.dayId,
    );
    
    // Load place data after the widget is built
    if (widget.placeId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadPlaceDetail();
      });
    } else {
      // For create mode, we don't need to load anything
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Setup initial state
        setState(() {}); // Trigger a rebuild
      });
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPlaceDetail() async {
    await _viewModel.loadPlace(widget.placeId!);
    
    // Set values in the controllers once we have the place data
    if (_viewModel.place != null) {
      _nameController.text = _viewModel.place!.name;
      if (_viewModel.place!.latitude != null) {
        _latitudeController.text = _viewModel.place!.latitude!.toString();
      }
      if (_viewModel.place!.longitude != null) {
        _longitudeController.text = _viewModel.place!.longitude!.toString();
      }
      if (_viewModel.place!.notes != null) {
        _notesController.text = _viewModel.place!.notes!;
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<PlaceEditingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: _buildContent(viewModel),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildContent(PlaceEditingViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (!viewModel.isCreateMode && viewModel.place == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load place data'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    }
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildHeader(viewModel),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPlaceTypeSection(viewModel),
                    const SizedBox(height: 24),
                    _buildNameSection(viewModel),
                    const SizedBox(height: 24),
                    _buildTimeSection(viewModel),
                    const SizedBox(height: 24),
                    _buildLocationSection(viewModel),
                    const SizedBox(height: 24),
                    _buildNotesSection(viewModel),
                    // const SizedBox(height: 24),
                    // _buildAttachmentsSection(viewModel),
                    const SizedBox(height: 24),
                    _buildSaveButton(viewModel),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeader(PlaceEditingViewModel viewModel) {
    final title = viewModel.isCreateMode ? 'Создать место' : 'Редактировать место';
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPlaceTypeSection(PlaceEditingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Тип места',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 14,
            color: Color(0xFF4B5562),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildPlaceTypeButton(
                viewModel,
                PlaceType.place,
                'Место',
                Icons.place,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPlaceTypeButton(
                viewModel,
                PlaceType.restaurant,
                'Ресторан',
                Icons.restaurant,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPlaceTypeButton(
                viewModel,
                PlaceType.event,
                'Мероприятие',
                Icons.event,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildPlaceTypeButton(
    PlaceEditingViewModel viewModel,
    PlaceType type,
    String label,
    IconData icon,
  ) {
    final isSelected = viewModel.place?.type == type;
    
    return GestureDetector(
      onTap: () => viewModel.setPlaceType(type),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : Colors.transparent,
          border: Border.all(
            color: const Color(0xFFE5E7EB),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF374151),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 14,
                color: isSelected ? Colors.white : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNameSection(PlaceEditingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Название',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 14,
            color: Color(0xFF4B5562),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Введите название места',
            hintStyle: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              color: Color(0xFFADB0BC),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Название не может быть пустым';
            }
            return null;
          },
          onChanged: (value) {
            viewModel.setName(value);
          },
        ),
      ],
    );
  }
  
  Widget _buildTimeSection(PlaceEditingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: viewModel.place?.hasTime ?? false,
                onChanged: (value) {
                  if (value != null) {
                    viewModel.setHasTime(value);
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: AppColors.accent,
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 8),
            const Text(
              'Указать время посещения',
              style: TextStyle(
                fontFamily: 'NotoSans',
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (viewModel.place?.hasTime ?? false)
          Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Время начала',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14,
                            color: Color(0xFF4B5562),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTimeOfDay(viewModel, true),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                viewModel.formatTimeOfDay(viewModel.place?.startTime),
                                style: const TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Время окончания',
                          style: TextStyle(
                            fontFamily: 'NotoSans',
                            fontSize: 14,
                            color: Color(0xFF4B5562),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectTimeOfDay(viewModel, false),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                viewModel.formatTimeOfDay(viewModel.place?.endTime),
                                style: const TextStyle(
                                  fontFamily: 'NotoSans',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
      ],
    );
  }
  
  Future<void> _selectTimeOfDay(PlaceEditingViewModel viewModel, bool isStartTime) async {
    final initialTime = isStartTime 
        ? viewModel.place?.startTime ?? TimeOfDay.now() 
        : viewModel.place?.endTime ?? TimeOfDay.now();
        
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accent,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (pickedTime != null) {
      if (isStartTime) {
        viewModel.setStartTime(pickedTime);
      } else {
        viewModel.setEndTime(pickedTime);
      }
    }
  }
  
  Widget _buildLocationSection(PlaceEditingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Местоположение',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 14,
            color: Color(0xFF4B5562),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: 'Поиск на карте',
            hintStyle: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              color: Color(0xFFADB0BC),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF9CA3AF),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
          ),
          onTap: () {
            // TODO: Open map search
          },
          readOnly: true,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Координаты',
                    style: TextStyle(
                      fontFamily: 'NotoSans',
                      fontSize: 14,
                      color: Color(0xFF4B5562),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Logic for entering coordinates manually
                  //     setState(() {
                  //       // Show/hide the coordinate fields
                  //     });
                  //   },
                  //   child: const Text(
                  //     'Ввести вручную',
                  //     style: TextStyle(
                  //       fontFamily: 'NotoSans',
                  //       fontSize: 14,
                  //       color: AppColors.accent,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(
                        hintText: 'Широта',
                        hintStyle: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 14,
                          color: Color(0xFFADB0BC),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 14,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        if (value.isNotEmpty && _longitudeController.text.isNotEmpty) {
                          try {
                            final latitude = double.parse(value);
                            final longitude = double.parse(_longitudeController.text);
                            viewModel.setCoordinates(latitude, longitude);
                          } catch (e) {
                            // Handle parsing error
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(
                        hintText: 'Долгота',
                        hintStyle: TextStyle(
                          fontFamily: 'NotoSans',
                          fontSize: 14,
                          color: Color(0xFFADB0BC),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'NotoSans',
                        fontSize: 14,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        if (value.isNotEmpty && _latitudeController.text.isNotEmpty) {
                          try {
                            final latitude = double.parse(_latitudeController.text);
                            final longitude = double.parse(value);
                            viewModel.setCoordinates(latitude, longitude);
                          } catch (e) {
                            // Handle parsing error
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // const SizedBox(height: 12),
        // OutlinedButton(
        //   onPressed: () {
        //     // TODO: Open saved places selection
        //   },
        //   style: OutlinedButton.styleFrom(
        //     padding: const EdgeInsets.symmetric(vertical: 16),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     side: const BorderSide(
        //       color: Color(0xFFE5E7EB),
        //     ),
        //     minimumSize: const Size(double.infinity, 50),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       const Icon(
        //         Icons.bookmark_border,
        //         size: 16,
        //         color: Color(0xFF374151),
        //       ),
        //       const SizedBox(width: 8),
        //       Text(
        //         'Выбрать из сохраненных мест',
        //         style: TextStyle(
        //           fontFamily: 'NotoSans',
        //           fontSize: 16,
        //           color: Colors.grey[800],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }
  
  Widget _buildNotesSection(PlaceEditingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Заметки',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 14,
            color: Color(0xFF4B5562),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Добавьте заметки о месте',
            hintStyle: const TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
              color: Color(0xFFADB0BC),
            ),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFE5E7EB),
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          style: const TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
          ),
          maxLines: 4,
          onChanged: (value) {
            viewModel.setNotes(value);
          },
        ),
      ],
    );
  }
  
  Widget _buildAttachmentsSection(PlaceEditingViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Прикрепленные файлы',
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 14,
            color: Color(0xFF4B5562),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            await _pickFile(viewModel);
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(
              color: Color(0xFFE5E7EB),
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.attach_file,
                size: 16,
                color: Color(0xFF4B5562),
              ),
              const SizedBox(width: 8),
              Text(
                'Прикрепить файлы',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (viewModel.attachedFiles.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.attachedFiles.length,
            itemBuilder: (context, index) {
              final file = viewModel.attachedFiles[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  file.path.split('/').last,
                  style: const TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 14,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    viewModel.removeAttachedFile(index);
                  },
                ),
              );
            },
          ),
      ],
    );
  }
  
  Future<void> _pickFile(PlaceEditingViewModel viewModel) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          if (file.path != null) {
            viewModel.addAttachedFile(File(file.path!));
          }
        }
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }
  
  Widget _buildSaveButton(PlaceEditingViewModel viewModel) {
    final buttonText = viewModel.isCreateMode ? 'Создать место' : 'Обновить в плане';
    
    return ElevatedButton(
      onPressed: viewModel.isSaving
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                final success = await viewModel.savePlaceChanges();
                if (success) {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(viewModel.errorMessage ?? 'Failed to save place'),
                      ),
                    );
                  }
                }
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 56),
      ),
      child: viewModel.isSaving
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: const TextStyle(
                    fontFamily: 'NotoSans',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }
} 