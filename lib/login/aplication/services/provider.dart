import 'package:ejemploaa/login/data/repository/auth_repository.dart';
import 'package:ejemploaa/login/data/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final userRepositoryProvider =
    Provider<UserRepository>((ref) => UserRepository());