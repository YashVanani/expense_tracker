import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../models/auth_response.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final TokenService _tokenService = Get.find<TokenService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();
  final signUpNameController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isSignUpPasswordVisible = false.obs;
  final isSignUpConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleSignUpPasswordVisibility() {
    isSignUpPasswordVisible.value = !isSignUpPasswordVisible.value;
  }

  void toggleSignUpConfirmPasswordVisibility() {
    isSignUpConfirmPasswordVisible.value =
        !isSignUpConfirmPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != signUpPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _apiService.post<AuthResponse>(
          '/auth/login',
          {
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          },
          requiresAuth: false,
          fromJson: (json) => AuthResponse.fromJson(json),
        );

        if (response.success && response.data != null) {
          await _tokenService.saveToken(response.data!.token);
          await _tokenService.saveUserId(response.data!.userId);

          Get.offAll(() => const HomeScreen());

          Get.snackbar(
            'Success',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        } else {
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await _apiService.post<AuthResponse>(
          '/auth/register',
          {
            'email': signUpEmailController.text.trim(),
            'password': signUpPasswordController.text.trim(),
            'name': signUpNameController.text.trim(),
          },
          requiresAuth: false,
          fromJson: (json) => AuthResponse.fromJson(json),
        );

        if (response.success && response.data != null) {
          await _tokenService.saveToken(response.data!.token);
          await _tokenService.saveUserId(response.data!.userId);

          Get.back();

          Get.snackbar(
            'Success',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        } else {
          Get.snackbar(
            'Error',
            response.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Sign up failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> logout() async {
    await _tokenService.clearToken();
    Get.offAll(() => const LoginScreen());
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signUpNameController.dispose();
    super.onClose();
  }
}
