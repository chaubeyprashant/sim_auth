import 'package:sim_auth/features/login/data/datasources/sim_card_remote_data_source.dart';
import 'package:sim_auth/features/login/data/repositories/sim_card_repository_impl.dart';
import 'package:sim_auth/features/login/domain/repositories/sim_card_repository.dart';
import 'package:sim_auth/features/login/domain/usecases/check_phone_permission.dart';
import 'package:sim_auth/features/login/domain/usecases/get_sim_cards.dart';
import 'package:sim_auth/features/login/domain/usecases/request_phone_permission.dart';
import 'package:sim_auth/features/login/presentation/bloc/login_bloc.dart';
import 'package:sim_auth/features/splash/presentation/bloc/splash_bloc.dart';

/// Dependency injection setup
class Injection {
  // Data Sources
  static SimCardRemoteDataSource get simCardRemoteDataSource {
    return SimCardRemoteDataSourceImpl();
  }

  // Repositories
  static SimCardRepository get simCardRepository {
    return SimCardRepositoryImpl(
      remoteDataSource: simCardRemoteDataSource,
    );
  }

  // Use Cases
  static CheckPhonePermissionUseCase get checkPhonePermission {
    return CheckPhonePermissionUseCase(simCardRepository);
  }

  static RequestPhonePermissionUseCase get requestPhonePermission {
    return RequestPhonePermissionUseCase(simCardRepository);
  }

  static GetSimCardsUseCase get getSimCards {
    return GetSimCardsUseCase(simCardRepository);
  }

  // BLoCs
  static SplashBloc get splashBloc {
    return SplashBloc();
  }

  static LoginBloc get loginBloc {
    return LoginBloc(
      checkPhonePermissionUseCase: checkPhonePermission,
      requestPhonePermissionUseCase: requestPhonePermission,
      getSimCardsUseCase: getSimCards,
    );
  }
}

