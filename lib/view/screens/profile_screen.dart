import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putevod/model/app_colors.dart';
import 'package:putevod/view-model/navigation_view_model.dart';
import 'package:putevod/view-model/profile_view_model.dart';
import 'package:putevod/view/widgets/app_header.dart';
import 'package:putevod/view/widgets/app_bottom_navigation.dart';

import '../widgets/basic_text_field.dart';

/// Profile screen implementation matching design
class ProfileScreen extends StatefulWidget {
  /// Creates a profile screen
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values from view model
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    _nicknameController.text = profileViewModel.nickname;
    _emailController.text = profileViewModel.email;
    _passwordController.text = profileViewModel.password;
  }
  
  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              showBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserProfile(profileViewModel),
                      const SizedBox(height: 16),
                      _buildStatistics(profileViewModel),
                      //const SizedBox(height: 15),
                     // _buildEditProfileButton(),
                      const SizedBox(height: 12),
                      _buildEditableFields(),
                      const SizedBox(height: 20),
                      _buildSaveButton(profileViewModel),
                    ],
                  ),
                ),
              ),
            ),
            AppBottomNavigation(
              selectedTab: NavigationTab.profile,
              onTabSelected: (tab) {
                navigationViewModel.setSelectedTab(tab);
              },
              onCreatePressed: () {
                navigationViewModel.setSelectedTab(NavigationTab.home);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUserProfile(ProfileViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProfilePicture(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NotoSans',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  viewModel.status,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF4B5563),
                    fontFamily: 'NotoSans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfilePicture() {
    return Container(
      width: 93,
      height: 93,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accent,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/profile_avatar.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  
  Widget _buildStatistics(ProfileViewModel viewModel) {
    return SizedBox(
      height: 84,
      child: Row(
        children: [
          _buildStatItem('Путешествия', viewModel.tripsCount, const Color(0xFF4850D3)),
          const SizedBox(width: 16),
          _buildStatItem('Места', viewModel.placesCount, const Color(0xFF84BA83)),
          // const SizedBox(width: 16),
          // _buildStatItem('Фото', viewModel.photosCount, const Color(0xFFF1C021)),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String title, int count, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'NotoSans',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'NotoSans',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEditProfileButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          'Редактировать профиль',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'NotoSans',
          ),
        ),
      ),
    );
  }
  
  Widget _buildEditableFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField('Никнейм', _nicknameController),
        const SizedBox(height: 16),
        _buildInputField('Email', _emailController),
        //const SizedBox(height: 16),
        //_buildInputField('Пароль', _passwordController, isPassword: true),
      ],
    );
  }
  
  Widget _buildInputField(String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: BasicTextField(label:label, controller: controller)
          ),
        ),
      ],
    );
  }
  
  Widget _buildSaveButton(ProfileViewModel viewModel) {
    return GestureDetector(
      onTap: () async {
        // Update view model with edited values
        viewModel.updateNickname(_nicknameController.text);
        viewModel.updateEmail(_emailController.text);
        //viewModel.updatePassword(_passwordController.text);
        
        // Save changes
        bool success = await viewModel.saveChanges();
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Профиль успешно сохранен'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: Text(
            'Сохранить изменения',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSans',
            ),
          ),
        ),
      ),
    );
  }
} 