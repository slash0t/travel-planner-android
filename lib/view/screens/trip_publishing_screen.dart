import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/trip_publishing_view_model.dart';

/// Trip publishing screen
class TripPublishingScreen extends StatelessWidget {
  /// Constructor
  const TripPublishingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripPublishingViewModel(),
      child: const TripPublishingView(),
    );
  }
}

/// Trip publishing view
class TripPublishingView extends StatefulWidget {
  /// Constructor
  const TripPublishingView({super.key});

  @override
  State<TripPublishingView> createState() => _TripPublishingViewState();
}

class _TripPublishingViewState extends State<TripPublishingView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Публикация поездки',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 20,
            fontFamily: 'NotoSans',
          ),
        ),
      ),
      body: viewModel.isLoading && viewModel.trips.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SelectTripSection(),
                  const SizedBox(height: 24),
                  const _TripPreviewSection(),
                  const SizedBox(height: 24),
                  const _ExcludeFromPublicationSection(),
                  const SizedBox(height: 24),
                  const _CategorySection(),
                  const SizedBox(height: 24),
                  const _DescriptionSection(),
                  const SizedBox(height: 24),
                  //const _CoverImageSection(),
                  //const SizedBox(height: 24),
                  //const _VisibilitySettingsSection(),
                  //const SizedBox(height: 24),
                  const _TermsSection(),
                  const SizedBox(height: 24),
                  _PublishButton(
                    onPressed: () async {
                      final success = await viewModel.publishTrip();
                      if (success) {
                        // Show success and go back
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Поездка успешно опубликована'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      } else if (viewModel.errorMessage != null) {
                        // Show error
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(viewModel.errorMessage!),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class _SelectTripSection extends StatelessWidget {
  const _SelectTripSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Выберите поездку',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.trips.length,
              itemBuilder: (context, index) {
                final trip = viewModel.trips[index];
                final isSelected = viewModel.selectedTrip?.id == trip.id;
                return GestureDetector(
                  onTap: () => viewModel.selectedTrip = trip,
                  child: Container(
                    width: 128,
                    height: 160,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? AppColors.red : Colors.grey,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            trip.previewUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            trip.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TripPreviewSection extends StatelessWidget {
  const _TripPreviewSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    if (viewModel.selectedTrip == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Text(
          'Выберите поездку для предпросмотра',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }
    
    final trip = viewModel.selectedTrip!;
    final tripDays = trip.endDate.difference(trip.startDate).inDays + 1;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Предпросмотр',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 192,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(trip.previewUrl!),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 76,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.6),
                          Color.fromRGBO(0, 0, 0, 0),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                        //const SizedBox(height: 4),
                        Text(
                          '$tripDays дней • 12 мест',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExcludeFromPublicationSection extends StatelessWidget {
  const _ExcludeFromPublicationSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Исключить из публикации',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text(
              'Личные заметки',
              style: TextStyle(
                fontFamily: 'NotoSans',
              ),
            ),
            value: viewModel.includePersonalNotes,
            onChanged: (value) {
              if (value != null) {
                viewModel.includePersonalNotes = value;
              }
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          // CheckboxListTile(
          //   title: const Text(
          //     'Выбранные дни и события',
          //     style: TextStyle(
          //       fontFamily: 'NotoSans',
          //     ),
          //   ),
          //   value: viewModel.includeDaysAndEvents,
          //   onChanged: (value) {
          //     if (value != null) {
          //       viewModel.includeDaysAndEvents = value;
          //     }
          //   },
          //   contentPadding: EdgeInsets.zero,
          //   controlAffinity: ListTileControlAffinity.leading,
          // ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Категория',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TripCategory>(
                value: viewModel.selectedCategory,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                  color: AppColors.text,
                  fontFamily: 'NotoSans',
                  fontSize: 16,
                ),
                onChanged: (TripCategory? value) {
                  if (value != null) {
                    viewModel.selectedCategory = value;
                  }
                },
                items: TripCategory.values.map<DropdownMenuItem<TripCategory>>(
                  (TripCategory category) {
                    return DropdownMenuItem<TripCategory>(
                      value: category,
                      child: Text(category.displayName),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Теги',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: viewModel.tagsController,
            decoration: InputDecoration(
              hintText: 'Добавьте теги через запятую',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'NotoSans',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 16,
              ),
            ),
            style: const TextStyle(
              fontFamily: 'NotoSans',
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Описание',
            style: TextStyle(
              fontFamily: 'NotoSans',
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: viewModel.descriptionController,
            decoration: InputDecoration(
              hintText: 'Расскажите о вашей поездке...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontFamily: 'NotoSans',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
            style: const TextStyle(
              fontFamily: 'NotoSans',
            ),
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}

class _CoverImageSection extends StatelessWidget {
  const _CoverImageSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Обложка',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: viewModel.pickImage,
            child: Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.circular(8),
                image: viewModel.coverImageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(viewModel.coverImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: viewModel.coverImageUrl.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 24,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Выберите изображение',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilitySettingsSection extends StatelessWidget {
  const _VisibilitySettingsSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Настройки видимости',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
          const SizedBox(height: 16),
          RadioListTile(
            title: const Text(
              'Публичная',
              style: TextStyle(
                fontFamily: 'NotoSans',
              ),
            ),
            value: true,
            groupValue: viewModel.isPublic,
            onChanged: (value) {
              if (value != null) {
                viewModel.isPublic = value;
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile(
            title: const Text(
              'Только по ссылке',
              style: TextStyle(
                fontFamily: 'NotoSans',
              ),
            ),
            value: true,
            groupValue: viewModel.isLinkOnly,
            onChanged: (value) {
              if (value != null) {
                viewModel.isLinkOnly = value;
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: viewModel.agreedToTerms,
            onChanged: (value) {
              if (value != null) {
                viewModel.agreedToTerms = value;
              }
            },
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Я согласен с правилами публикации и подтверждаю, что имею права на публикацию данного контента',
                style: TextStyle(
                  fontFamily: 'NotoSans',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PublishButton extends StatelessWidget {
  final VoidCallback onPressed;
  
  const _PublishButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TripPublishingViewModel>();
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: viewModel.isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: viewModel.isLoading
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
                  const Icon(Icons.publish, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Опубликовать поездку',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSans',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} 