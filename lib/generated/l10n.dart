// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Copyright © 2025 Checkpoint Systems, Inc. All right are reserved. StoreOps is a trademark of Checkpoint Systems, Inc.`
  String get letters {
    return Intl.message(
      'Copyright © 2025 Checkpoint Systems, Inc. All right are reserved. StoreOps is a trademark of Checkpoint Systems, Inc.',
      name: 'letters',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `User ID`
  String get user {
    return Intl.message('User ID', name: 'user', desc: '', args: []);
  }

  /// `Sign In`
  String get send {
    return Intl.message('Sign In', name: 'send', desc: '', args: []);
  }

  /// `Your user is not authorized`
  String get unauthorized {
    return Intl.message(
      'Your user is not authorized',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Your user or password are wrong`
  String get incorrect {
    return Intl.message(
      'Your user or password are wrong',
      name: 'incorrect',
      desc: '',
      args: [],
    );
  }

  /// `You must enter your username`
  String get no_user {
    return Intl.message(
      'You must enter your username',
      name: 'no_user',
      desc: '',
      args: [],
    );
  }

  /// `You must enter your password`
  String get no_password {
    return Intl.message(
      'You must enter your password',
      name: 'no_password',
      desc: '',
      args: [],
    );
  }

  /// `Principal Menu`
  String get principal_menu {
    return Intl.message(
      'Principal Menu',
      name: 'principal_menu',
      desc: '',
      args: [],
    );
  }

  /// `Waiting Info Client`
  String get waiting_client {
    return Intl.message(
      'Waiting Info Client',
      name: 'waiting_client',
      desc: '',
      args: [],
    );
  }

  /// `Waiting Info Store`
  String get waiting_store {
    return Intl.message(
      'Waiting Info Store',
      name: 'waiting_store',
      desc: '',
      args: [],
    );
  }

  /// `Real Time Events`
  String get real_time_events {
    return Intl.message(
      'Real Time Events',
      name: 'real_time_events',
      desc: '',
      args: [],
    );
  }

  /// `Events for readers`
  String get events_for_readers {
    return Intl.message(
      'Events for readers',
      name: 'events_for_readers',
      desc: '',
      args: [],
    );
  }

  /// `Daily Report`
  String get daily_report {
    return Intl.message(
      'Daily Report',
      name: 'daily_report',
      desc: '',
      args: [],
    );
  }

  /// `Report today`
  String get report_today {
    return Intl.message(
      'Report today',
      name: 'report_today',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Config App`
  String get config_app {
    return Intl.message('Config App', name: 'config_app', desc: '', args: []);
  }

  /// `Customer`
  String get customer {
    return Intl.message('Customer', name: 'customer', desc: '', args: []);
  }

  /// `Search Customer`
  String get search {
    return Intl.message('Search Customer', name: 'search', desc: '', args: []);
  }

  /// `Site`
  String get site {
    return Intl.message('Site', name: 'site', desc: '', args: []);
  }

  /// `Search Site`
  String get search_site {
    return Intl.message('Search Site', name: 'search_site', desc: '', args: []);
  }

  /// `Group`
  String get group {
    return Intl.message('Group', name: 'group', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Technologies`
  String get technologies {
    return Intl.message(
      'Technologies',
      name: 'technologies',
      desc: '',
      args: [],
    );
  }

  /// `People Counting`
  String get pc {
    return Intl.message('People Counting', name: 'pc', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Push Notifications`
  String get push_notifications {
    return Intl.message(
      'Push Notifications',
      name: 'push_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Total Alarms`
  String get total_alarms {
    return Intl.message(
      'Total Alarms',
      name: 'total_alarms',
      desc: '',
      args: [],
    );
  }

  /// `Total Audible Alarms`
  String get total_audible_alarms {
    return Intl.message(
      'Total Audible Alarms',
      name: 'total_audible_alarms',
      desc: '',
      args: [],
    );
  }

  /// `AVG Daily Audible Alarms`
  String get avg_daily_audible_alarms {
    return Intl.message(
      'AVG Daily Audible Alarms',
      name: 'avg_daily_audible_alarms',
      desc: '',
      args: [],
    );
  }

  /// `Total audible alarms by category`
  String get total_audible_alarms_by_category {
    return Intl.message(
      'Total audible alarms by category',
      name: 'total_audible_alarms_by_category',
      desc: '',
      args: [],
    );
  }

  /// `Config Saved`
  String get config_saved {
    return Intl.message(
      'Config Saved',
      name: 'config_saved',
      desc: '',
      args: [],
    );
  }

  /// `You must select a client`
  String get select_client {
    return Intl.message(
      'You must select a client',
      name: 'select_client',
      desc: '',
      args: [],
    );
  }

  /// `You must select a store`
  String get select_store {
    return Intl.message(
      'You must select a store',
      name: 'select_store',
      desc: '',
      args: [],
    );
  }

  /// `You must select at least one technology`
  String get select_technology {
    return Intl.message(
      'You must select at least one technology',
      name: 'select_technology',
      desc: '',
      args: [],
    );
  }

  /// `Saving Configuration`
  String get saving_configuration {
    return Intl.message(
      'Saving Configuration',
      name: 'saving_configuration',
      desc: '',
      args: [],
    );
  }

  /// `Loading Customers Info`
  String get loading_customers_info {
    return Intl.message(
      'Loading Customers Info',
      name: 'loading_customers_info',
      desc: '',
      args: [],
    );
  }

  /// `No Description`
  String get no_description {
    return Intl.message(
      'No Description',
      name: 'no_description',
      desc: '',
      args: [],
    );
  }

  /// `Image break`
  String get image_break {
    return Intl.message('Image break', name: 'image_break', desc: '', args: []);
  }

  /// `Image unavailable`
  String get image_unavailable {
    return Intl.message(
      'Image unavailable',
      name: 'image_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Loading Events from`
  String get lef {
    return Intl.message('Loading Events from', name: 'lef', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Log out`
  String get logOut {
    return Intl.message('Log out', name: 'logOut', desc: '', args: []);
  }

  /// `¿Do you want to log out?`
  String get confirmLogOut {
    return Intl.message(
      '¿Do you want to log out?',
      name: 'confirmLogOut',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `loading`
  String get loading {
    return Intl.message('loading', name: 'loading', desc: '', args: []);
  }

  /// `Waiting client selection`
  String get waitingClientSelection {
    return Intl.message(
      'Waiting client selection',
      name: 'waitingClientSelection',
      desc: '',
      args: [],
    );
  }

  /// `Access success`
  String get access_success {
    return Intl.message(
      'Access success',
      name: 'access_success',
      desc: '',
      args: [],
    );
  }

  /// `Search store...`
  String get search_store {
    return Intl.message(
      'Search store...',
      name: 'search_store',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message('Store', name: 'store', desc: '', args: []);
  }

  /// `Session Expired`
  String get session_expired {
    return Intl.message(
      'Session Expired',
      name: 'session_expired',
      desc: '',
      args: [],
    );
  }

  /// `Your session has expired. Please log in again`
  String get session_expired_message {
    return Intl.message(
      'Your session has expired. Please log in again',
      name: 'session_expired_message',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Log out`
  String get log_out {
    return Intl.message('Log out', name: 'log_out', desc: '', args: []);
  }

  /// `¿Do you want to log out?`
  String get log_out_question {
    return Intl.message(
      '¿Do you want to log out?',
      name: 'log_out_question',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
