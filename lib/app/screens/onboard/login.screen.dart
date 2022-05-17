// 🎯 Dart imports:
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:at_base2e15/at_base2e15.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/services/onboarding_service.dart';
import 'package:at_onboarding_flutter/utils/response_status.dart';
import 'package:at_server_status/at_server_status.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:path/path.dart' as p;
// 🌎 Project imports:
import '../../../core/services/app.service.dart';
import '../../../core/services/passman.env.dart';
import '../../../core/services/sdk.services.dart';
import '../../../meta/components/adaptive_loading.dart';
import '../../../meta/components/file_upload_space.dart';
import '../../../meta/components/filled_text_field.dart';
import '../../../meta/components/set_propic.dart';
import '../../../meta/components/toast.dart';
import '../../../meta/extensions/input_formatter.ext.dart';
import '../../../meta/extensions/logger.ext.dart';
import '../../../meta/extensions/string.ext.dart';
import '../../../meta/notifiers/user_data.dart';
import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../constants/global.dart';
import '../../constants/page_route.dart';
import '../../constants/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AppLogger _logger = AppLogger('LoginScreen');
  late TextEditingController _atSignController;
  String? fileName, _atSign;
  bool _isValidAtSign = false,
      _checkedAtSign = false,
      _isLoading = false,
      _uploading = false;
  Set<PlatformFile> _list = <PlatformFile>{};
  final SdkServices _sdk = SdkServices.getInstance();
  @override
  void initState() {
    _atSignController = TextEditingController();
    Future<void>.delayed(Duration.zero, () async {
      String _path = (await getApplicationSupportDirectory()).path;
      String _downloadsPath = p.join(_path, 'downloads');
      if (!await Directory(_downloadsPath).exists()) {
        await Directory(_downloadsPath).create(recursive: true);
        _logger.finer('Created downloads directory at $_downloadsPath');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _atSignController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      bool _alreadyExists = await _alreadyLoggedin();
      if (_alreadyExists) {
        showToast(context, 'User account already exists.', isError: true);
      } else {
        setState(() => _isLoading = true);
        String _atKeysData =
            await AppServices.readAtKeysFile(_list.first.path!);
        ResponseStatus status =
            await _sdk.onboardWithAtKeys(_atSign!, _atKeysData);
        context.read<UserData>().authenticated = status.name == 'authSuccess';
        if (status.name == 'authSuccess') {
          _atKeysData.clear();
          context.read<UserData>().currentAtSign = _atSign!;
          await AtClientManager.getInstance().setCurrentAtSign(
              context.read<UserData>().currentAtSign,
              PassmanEnv.appNamespace,
              context.read<UserData>().atOnboardingPreference);
          _list.clear();
          bool _masterImgKeyExists = await _sdk.checkMasterImageKey();
          AppServices.syncData();
          while (context.read<UserData>().syncStatus != SyncStatus.success) {
            await Future<void>.delayed(Duration.zero);
          }
          context.read<UserData>().isAdmin = await _sdk.isAdmin();
          String? _profilePic = await _sdk.getProPic();
          if (_profilePic != null) {
            context.read<UserData>().currentProfilePic =
                Base2e15.decode(_profilePic);
          } else {
            Uint8List _avatar = await AppServices.readLocalfilesAsBytes(
                Assets.getRandomAvatar());
            await showModalBottomSheet(
              backgroundColor: Colors.white,
              isScrollControlled: false,
              isDismissible: false,
              enableDrag: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              context: context,
              builder: (_) {
                return SetProPic(_avatar);
              },
            );
          }
          setState(() => _isLoading = false);
          await Navigator.pushReplacementNamed(
              context,
              _masterImgKeyExists
                  ? PageRouteNames.loadingScreen
                  : PageRouteNames.setMasterPassword);
        } else if (status == ResponseStatus.authFailed) {
          _list.clear();
          setState(() => _isLoading = false);
          showToast(context,
              'Failed to authenticate. Please pick files and try again.',
              isError: true);
        } else if (status == ResponseStatus.serverNotReached ||
            status == ResponseStatus.timeOut) {
          _list.clear();
          setState(() => _isLoading = false);
          showToast(context, 'Unable to reach server. Please try again later.',
              isError: true);
        }
      }
    } on FileSystemException catch (e, s) {
      _list.clear();
      setState(() => _isLoading = false);
      _logger.severe('FileSystemException: ${e.toString}', e, s);
      showToast(context, e.message + '😥. Please upload the atKeys file again.',
          isError: true);
    } catch (e, s) {
      _list.clear();
      setState(() => _isLoading = false);
      showToast(context, 'Authentication failed', isError: true);
      _logger.severe('Authentication failed', e, s);
      log('Authentication failed', error: e, stackTrace: s);
    }
  }

  Future<bool> _alreadyLoggedin() async {
    setState(() {
      _isLoading = true;
    });
    bool _atSignLoggedIn = await SdkServices.getInstance()
        .checkIfAtSignExistInDevice(
            _atSign!, context.read<UserData>().atOnboardingPreference);
    if (_atSignLoggedIn) {
      bool onboarded = await OnboardingService.getInstance().onboard();
      if (onboarded) {
        setState(() {
          _isLoading = false;
          _checkedAtSign = true;
        });
        await Navigator.pushReplacementNamed(
            context, PageRouteNames.masterPassword);
      }
    } else {
      setState(() {
        _isLoading = false;
        _checkedAtSign = true;
      });
    }
    return _atSignLoggedIn;
  }

  Future<void> _checkAtSign() async {
    setState(() => _isLoading = true);
    await SdkServices.getInstance()
        .getAtSignStatus(
      _atSign!,
    )
        .then(
      (AtStatus atStatus) {
        setState(() {
          _isValidAtSign = atStatus.rootStatus == RootStatus.found;
          _checkedAtSign = true;
          _isLoading = false;
        });
        if (!_isValidAtSign) {
          showToast(
            context,
            'Can\'t find $_atSign. Please try again.',
            isError: true,
          );
        }
      },
    );
  }

  Future<void> uploadAtKeys(Set<PlatformFile> _l) async {
    if (_l.isEmpty) {
      setState(() {
        fileName = null;
        _uploading = false;
        _list = _l;
      });
      showToast(context, 'No file selected');
      return;
    } else {
      setState(() {
        _list = _l;
        fileName = _l.first.name;
      });
    }
    setState(() => _uploading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset(
                          Assets.atLogo,
                          color: AppTheme.primary,
                          height: 120,
                        ),
                        vSpacer(50),
                        const Text(
                          'Control access to your data with\nyour own unique digital ID.\nEnter your @Sign.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    vSpacer(70),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _isValidAtSign
                            ? FileUploadSpace(
                                onTap: (_) async {
                                  setState(() => _uploading = true);
                                  await uploadAtKeys(_);
                                },
                                assetPath: Assets.atKeys,
                                uploadMessage: _list.isEmpty
                                    ? 'Upload your atKeys file.'
                                    : fileName,
                                dismissable: !_uploading,
                                isUploading: _uploading,
                                onDismmisTap: () => setState(() {
                                  _list.clear();
                                  _isValidAtSign = false;
                                  _checkedAtSign = false;
                                }),
                              )
                            : FilledTextField(
                                controller: _atSignController,
                                hint: '@sign',
                                prefix: Text(
                                  '@ ',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onChanged: (_) {
                                  setState(() {
                                    _atSign =
                                        '@' + _atSignController.text.trim();
                                    _checkedAtSign = false;
                                  });
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                    RegExp(Constants.atSignPattern),
                                  ),
                                  LowerCaseTextFormatter(),
                                ],
                              ),
                        vSpacer(100),
                        _isLoading
                            ? const AdaptiveLoading()
                            : MaterialButton(
                                mouseCursor: SystemMouseCursors.click,
                                color: _checkedAtSign &&
                                        _isValidAtSign &&
                                        _list.isEmpty
                                    ? AppTheme.primary
                                    : AppTheme.primary,
                                elevation: 0,
                                highlightElevation: 0,
                                hoverElevation: 0,
                                focusElevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  _checkedAtSign && _isValidAtSign
                                      ? 'Login'
                                      : 'Check @sign',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: _checkedAtSign &&
                                        _isValidAtSign &&
                                        _list.isEmpty
                                    ? null
                                    : _atSign == null || _atSign!.isEmpty
                                        ? () => showToast(
                                            context, 'Please enter your @sign',
                                            isError: true)
                                        : _checkedAtSign && _isValidAtSign
                                            ? _login
                                            : _checkAtSign,
                              ),
                        vSpacer(30),
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          child: Text(
                            'Get an @sign',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: () async => Navigator.pushNamed(
                              context, PageRouteNames.registerScreen),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: IconButton(
                icon: const Icon(TablerIcons.qrcode),
                onPressed: () async =>
                    Navigator.pushNamed(context, PageRouteNames.qrScreen),
                splashRadius: 0.01,
              ),
              top: 0,
              right: 10,
            ),
          ],
        ),
      ),
    );
  }
}
