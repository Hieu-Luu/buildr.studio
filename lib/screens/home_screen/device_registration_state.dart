import 'package:buildr_studio/repositories/account_repository.dart';
import 'package:buildr_studio/repositories/user_preferences_repository.dart';
import 'package:buildr_studio/services/device_registration_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

class DeviceRegistrationState extends ChangeNotifier {
  DeviceRegistrationState({
    required DeviceRegistrationService deviceRegistration,
    required AccountRepository accountRepository,
    required UserPreferencesRepository userPreferencesRepository,
  })  : _deviceRegistration = deviceRegistration,
        _accountRepository = accountRepository,
        _userPreferencesRepository = userPreferencesRepository {
    registerDevice();
  }

  final _logger = GetIt.I.get<Logger>();

  final DeviceRegistrationService _deviceRegistration;
  final AccountRepository _accountRepository;
  final UserPreferencesRepository _userPreferencesRepository;
  String? accountId;
  String? errorMessage;

  Future<String?> registerDevice() async {
    try {
      errorMessage = null;
      final deviceKey = await _deviceRegistration.loadDeviceKey();
      final id = accountId = await _accountRepository.getAccountId(deviceKey);
      _userPreferencesRepository.setAccountId(id);
      notifyListeners();
      return deviceKey;
    } catch (e) {
      _logger.e('Error registering device: $e');
      errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
}
