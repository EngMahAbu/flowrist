abstract final class Endpoints {
  static const baseUrl = 'http://10.0.2.2:5000/';
  static const register = 'api/identity/auth/register';
  static const occasions = 'api/catalog/occasions';
  static const categories = 'api/catalog/categories';
  static const products = 'api/catalog/products';
  static const home = 'api/catalog/home/layout';
  static const getAllAddress = 'api/address-cart/addresses';
  static const addressId = 'addressId';
  static const setDefaultAddress =
      'api/address-cart/users/me/addresses/{addressId}/default';

  static const String forgetPassword = 'auth/forget-password';
  static const String verifyOTP = 'auth/otp-verification';
  static const String resetPassword = 'auth/reset-password';
  static const String productDetails = '/api/catalog/products';
}
