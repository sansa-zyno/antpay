class AppSettings{
  final String? subscriptionType;
  final List<String>? roles;
  final String? region;
  final String? adminHost;
  final String? clientHost;
  final bool? autoEstablishSocketConnection;

  AppSettings._builder(AppSettingsBuilder builder)
      : subscriptionType = builder.subscriptionType,
        roles = builder.roles,
        region = builder.region,
        adminHost = builder.adminHost,
        clientHost = builder.clientHost,
        autoEstablishSocketConnection = builder.autoEstablishSocketConnection??true;
}

class AppSettingsBuilder {
  String? subscriptionType;
  List<String>? roles;
  String? region;
  String? adminHost;
  String? clientHost;
  bool? autoEstablishSocketConnection;

  AppSettingsBuilder();

  AppSettings build() {
    return AppSettings._builder(this);
  }
}
