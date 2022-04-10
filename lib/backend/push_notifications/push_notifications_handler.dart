import 'dart:async';
import 'dart:convert';

import 'serialization_util.dart';
import '../backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../login_page/login_page_widget.dart';
import '../../register_account/register_account_widget.dart';
import '../../verify_s_m_s/verify_s_m_s_widget.dart';
import '../../forgot_password/forgot_password_widget.dart';
import '../../s_m_s_verify/s_m_s_verify_widget.dart';
import '../../complete_profile/complete_profile_widget.dart';
import '../../onboarding/onboarding_widget.dart';
import '../../create_budget_begin/create_budget_begin_widget.dart';
import '../../create_budget_begin_copy/create_budget_begin_copy_widget.dart';
import '../../google_map/google_map_widget.dart';
import '../../m_y_profile_page/m_y_profile_page_widget.dart';
import '../../budget_details/budget_details_widget.dart';
import '../../payment_details/payment_details_widget.dart';
import '../../create_budget/create_budget_widget.dart';
import '../../transaction_a_d_d/transaction_a_d_d_widget.dart';
import '../../transaction_e_d_i_t/transaction_e_d_i_t_widget.dart';
import '../../budget_d_e_l_e_t_e/budget_d_e_l_e_t_e_widget.dart';
import '../../edit_profile/edit_profile_widget.dart';
import '../../change_password/change_password_widget.dart';
import '../../notifications_settings/notifications_settings_widget.dart';
import '../../tutorial_p_r_o_f_i_l_e/tutorial_p_r_o_f_i_l_e_widget.dart';
import '../../home_page_alt/home_page_alt_widget.dart';
import '../../home_page_alt_1/home_page_alt1_widget.dart';

class PushNotificationsHandler extends StatefulWidget {
  const PushNotificationsHandler(
      {Key key, this.handlePushNotification, this.child})
      : super(key: key);

  final Function(BuildContext) handlePushNotification;
  final Widget child;

  @override
  _PushNotificationsHandlerState createState() =>
      _PushNotificationsHandlerState();
}

class _PushNotificationsHandlerState extends State<PushNotificationsHandler> {
  bool _loading = false;

  Future handleOpenedPushNotification() async {
    final notification = await FirebaseMessaging.instance.getInitialMessage();
    if (notification != null) {
      await _handlePushNotification(notification);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handlePushNotification);
  }

  Future _handlePushNotification(RemoteMessage message) async {
    setState(() => _loading = true);
    try {
      final initialPageName = message.data['initialPageName'] as String;
      final initialParameterData = getInitialParameterData(message.data);
      final pageBuilder = pageBuilderMap[initialPageName];
      if (pageBuilder != null) {
        final page = await pageBuilder(initialParameterData);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    handleOpenedPushNotification();
  }

  @override
  Widget build(BuildContext context) => _loading
      ? Container(
          color: Colors.transparent,
          child: Center(
            child: Builder(
              builder: (context) => Image.asset(
                'assets/images/Medical_ScheduleApp_0.0.png',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        )
      : widget.child;
}

final pageBuilderMap = <String, Future<Widget> Function(Map<String, dynamic>)>{
  'loginPage': (data) async => LoginPageWidget(),
  'registerAccount': (data) async => RegisterAccountWidget(),
  'VerifySMS': (data) async => VerifySMSWidget(),
  'forgotPassword': (data) async => ForgotPasswordWidget(),
  'SMSVerify': (data) async => SMSVerifyWidget(),
  'completeProfile': (data) async => CompleteProfileWidget(),
  'onboarding': (data) async => OnboardingWidget(),
  'createBudgetBegin': (data) async => CreateBudgetBeginWidget(),
  'createBudgetBeginCopy': (data) async => CreateBudgetBeginCopyWidget(),
  'GoogleMap': (data) async => GoogleMapWidget(),
  'MY_Budgets': (data) async => NavBarPage(initialPage: 'MYBudgetsWidget'),
  'MY_BudgetsCopy': (data) async =>
      NavBarPage(initialPage: 'MYBudgetsCopyWidget'),
  'MY_profilePage': (data) async => hasMatchingParameters(data, {'userProfile'})
      ? MYProfilePageWidget(
          userProfile: getParameter(data, 'userProfile'),
        )
      : NavBarPage(initialPage: 'MYProfilePageWidget'),
  'budgetDetails': (data) async => BudgetDetailsWidget(
        budgetDetails: getParameter(data, 'budgetDetails'),
      ),
  'paymentDetails': (data) async => PaymentDetailsWidget(
        transactionDetails: getParameter(data, 'transactionDetails'),
        userSpent: getParameter(data, 'userSpent'),
      ),
  'createBudget': (data) async => CreateBudgetWidget(),
  'transaction_ADD': (data) async => TransactionADDWidget(),
  'transaction_EDIT': (data) async => TransactionEDITWidget(
        transactionDetails: getParameter(data, 'transactionDetails'),
      ),
  'budget_DELETE': (data) async => BudgetDELETEWidget(
        budgetList: getParameter(data, 'budgetList'),
      ),
  'editProfile': (data) async => EditProfileWidget(
        userProfile: getParameter(data, 'userProfile'),
      ),
  'changePassword': (data) async => ChangePasswordWidget(),
  'notificationsSettings': (data) async => NotificationsSettingsWidget(),
  'tutorial_PROFILE': (data) async => TutorialPROFILEWidget(),
  'homePage_alt': (data) async => HomePageAltWidget(),
  'homePage_alt_1': (data) async => HomePageAlt1Widget(),
};

bool hasMatchingParameters(Map<String, dynamic> data, Set<String> params) =>
    params.any((param) => getParameter(data, param) != null);

Map<String, dynamic> getInitialParameterData(Map<String, dynamic> data) {
  try {
    final parameterDataStr = data['parameterData'];
    if (parameterDataStr == null ||
        parameterDataStr is! String ||
        parameterDataStr.isEmpty) {
      return {};
    }
    return jsonDecode(parameterDataStr) as Map<String, dynamic>;
  } catch (e) {
    print('Error parsing parameter data: $e');
    return {};
  }
}
