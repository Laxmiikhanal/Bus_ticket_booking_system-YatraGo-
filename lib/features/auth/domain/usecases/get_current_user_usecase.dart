import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository repository;

  GetCurrentUserUsecase(this.repository);

  Future<AuthEntity?> call() {
    return repository.getCurrentUser();
  }
}
