// import 'package:flowrist/config/form_validator/form_validator.dart';
// import 'package:flowrist/config/l10n/app_localizations.dart';

// abstract final class SignUpFormValidator {
//   static String? validatePassword({
//     required String? value,
//     required AppLocalizations localizations,
//   }) {
//     if (value == null || value.trim().isEmpty) {
//       return localizations.emptyValidationError;
//     }
//     return FormValidator.validatePassword(value).getErrorMessage(localizations);
//   }

//   static String? validateConfirmPassword({
//     required String? value,
//     required String password,
//     required AppLocalizations localizations,
//   }) {
//     if (value == null || value.trim().isEmpty) {
//       return localizations.emptyValidationError;
//     }
//     if (value != password) {
//       return localizations.passwordsDoNotMatchError;
//     }
//     return null;
//   }
// }

// extension PasswordValidationMessage on PasswordValidationResult {
//   String? getErrorMessage(AppLocalizations l10n) {
//     return switch (this) {
//       Valid() => null,
//       LengthError() => l10n.passwordLengthError,
//       UppercaseError() => l10n.passwordUppercaseError,
//       LowercaseError() => l10n.passwordLowercaseError,
//       NumberError() => l10n.passwordNumberError,
//       SpecialCharError() => l10n.passwordSpecialCharError,
//     };
//   }
// }