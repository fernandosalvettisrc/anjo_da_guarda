import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final bool isUFValid;
  final bool isCEPValid;
  final bool isCPFValid;
  final bool isPasswordVerifyValid;
  final bool isDataValid;
  final bool isValidNumber;
  bool get isFormValid => isEmailValid && isPasswordValid;

  RegisterState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.isUFValid,
    @required this.isCEPValid,
    @required this.isCPFValid,
    @required this.isPasswordVerifyValid,
    @required this.isDataValid,
    @required this.isValidNumber,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isUFValid: true,
      isCPFValid: true,
      isCEPValid: true,
      isPasswordVerifyValid: true,
      isDataValid: true,
      isValidNumber: true,
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      isUFValid: true,
      isCPFValid: true,
      isPasswordVerifyValid: true,
      isDataValid: true,
      isCEPValid: true,
      isValidNumber: true,
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      isUFValid: true,
      isCPFValid: true,
      isPasswordVerifyValid: true,
      isDataValid: true,
      isCEPValid: true,
      isValidNumber: true,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      isUFValid: true,
      isCPFValid: true,
      isPasswordVerifyValid: true,
      isDataValid: true,
      isCEPValid: true,
      isValidNumber: true,
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isUFValid,
    bool isCPFValid,
    bool isPasswordVerifyValid,
    bool isDataValid,
    bool isValidNumber,
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isUFValid: isUFValid,
      isCPFValid: isCPFValid,
      isCEPValid: isCEPValid,
      isDataValid: isDataValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      isValidNumber: isValidNumber,
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure,
    bool isUFValid,
    bool isCPFValid,
    bool isCEPValid,
    bool isDataValid,
    bool isValidNumber,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      isCEPValid: isCEPValid ?? this.isCEPValid,
      isCPFValid: isCPFValid ?? this.isCPFValid,
      isUFValid: isUFValid ?? this.isUFValid,
      isDataValid: isDataValid ?? this.isDataValid,
      isPasswordVerifyValid: isPasswordVerifyValid ?? this.isPasswordVerifyValid,
      isValidNumber: isValidNumber ?? this.isValidNumber,
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isPasswordVerifyValid: $isPasswordVerifyValid,
      isCEPValid: $isCEPValid,
      isCPFValid: $isCPFValid,
      isUFValid: $isUFValid,
      isDataValid: $isDataValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isValidNumber: $isValidNumber,
    }''';
  }
}
