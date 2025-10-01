import 'package:storeops_mobile/domain/repositories/auth_repository.dart';
import 'package:storeops_mobile/domain/entities/login_response_entity.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<LoginResponseEntity> login(String user, String password) async {
    print('🧪 Fake login ejecutado');
    return LoginResponseEntity(
      accessToken: 'token',
      message: '',
      mobileAccess: true, id: 1, username: '', email: '', roles: [], tokenType: '',
    );
  }

}
