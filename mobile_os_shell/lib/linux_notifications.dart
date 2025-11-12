import 'package:dbus/dbus.dart';

class IncomingNotification {
  final int id;
  final String appName;
  final String summary;
  final String body;

  IncomingNotification({
    required this.id,
    required this.appName,
    required this.summary,
    required this.body,
  });
}

typedef OnNotify = void Function(IncomingNotification);

/// Simple freedesktop.org notification daemon
class NotificationDaemon extends DBusObject {
  final OnNotify onNotify;
  int _id = 1;

  NotificationDaemon(this.onNotify)
      : super(DBusObjectPath('/org/freedesktop/Notifications'));

  @override
  Future<DBusMethodResponse> handleMethodCall(
      DBusMethodCall call) async {

    final name = call.name;

    // ---- GetServerInformation ----
    if (name == 'GetServerInformation') {
      return DBusMethodSuccessResponse([
        DBusString('FlutterShell'),
        DBusString('MobileOS'),
        DBusString('1.0'),
        DBusString('1.2'),
      ]);
    }

    // ---- GetCapabilities ----
    if (name == 'GetCapabilities') {
      return DBusMethodSuccessResponse([
        DBusArray.string(['body']),
      ]);
    }

    // ---- Notify ----
    if (name == 'Notify') {
      final args = call.values;

      final appName = (args[0] as DBusString).value;
      final summary = (args[3] as DBusString).value;
      final body = (args[4] as DBusString).value;

      final id = _id++;

      onNotify(
        IncomingNotification(
          id: id,
          appName: appName,
          summary: summary,
          body: body,
        ),
      );

      return DBusMethodSuccessResponse([DBusUint32(id)]);
    }

    // ---- CloseNotification ----
    if (name == 'CloseNotification') {
      return DBusMethodSuccessResponse([]);
    }

    return DBusMethodErrorResponse.unknownMethod();
  }
}

class NotificationServer {
  DBusClient? client;
  NotificationDaemon? daemon;

  Future<void> start(OnNotify onNotify) async {
    client = DBusClient.session();

    daemon = NotificationDaemon(onNotify);

    await client!.requestName(
      'org.freedesktop.Notifications',
      flags: {
        DBusRequestNameFlag.allowReplacement,
        DBusRequestNameFlag.replaceExisting,
        DBusRequestNameFlag.doNotQueue
      },
    );

    await client!.registerObject(daemon!);
  }

  Future<void> stop() async {
    if (client != null && daemon != null) {
      await client!.unregisterObject(daemon!);
      await client!.close();
    }
  }
}