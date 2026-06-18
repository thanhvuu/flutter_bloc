
class FirebaseErrorHandler {
  static String parseError(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('user-notfound') || errorStr.contains('invalid-credential')) {
      return 'thong tin dang nhap khong chinh xac';
    } else if (errorStr.contains('wrongpassword')) {
      return 'mk khong chinh xac';

    } else if (errorStr.contains('email-already-in-use')) {
      return 'email đã được đăng ký';
    } else if (errorStr.contains('weak-password')) {
      return 'mật khẩu yếu';
    } else if (errorStr.contains('invalid-email')) {
      return 'email không đúng định dạng';
    }
    return 'Lỗi: ${error.toString()}';
  }

  
}