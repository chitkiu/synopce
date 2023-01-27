enum AppRouteType {
  auth("/auth"),
  main("/main");

  final String route;
  const AppRouteType(this.route);
}
