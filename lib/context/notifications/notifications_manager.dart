import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sochat_client/context/context_manager.dart';
import 'package:sochat_client/so_ui/notifications/so_notification.dart';
import 'package:sochat_client/extenstions/theme_getter.dart';
import 'package:sochat_client/so_ui/common/so_button.dart';

final notificationsManagerProvider = StateNotifierProvider<NotificationsManager, NotificationsManagerState>(
      (ref) => NotificationsManager(ref),);

class NotificationsManagerState {

  final List<SoNotification> notificationList;

  NotificationsManagerState({required this.notificationList});

  NotificationsManagerState copyWith({
    List<SoNotification>? notifications,
  }) {
    return NotificationsManagerState(
      notificationList: notifications ?? this.notificationList,
    );
  }
}

class NotificationsManager extends StateNotifier<NotificationsManagerState> {


  NotificationsManager(this._ref)
      : super(NotificationsManagerState(notificationList: []));

  Ref _ref;

  List<SoNotification> get notificationList =>
      state.notificationList;


  void remove(int index) {
    final newList = List<SoNotification>.from(notificationList);

    newList.removeAt(index);

    state = state.copyWith(notifications: newList);
  }

  void addUpdate(SoNotification notification) {
    final newList = List<SoNotification>.from(notificationList);
    newList.add(notification);
    state = state.copyWith(notifications: newList);
  }

  void addError(String title, String content){
    final notification = SoNotification(icon: Icons.error_outline_sharp,title: title, content: content, canCopy: true,);
    addUpdate(notification);
  }
}
