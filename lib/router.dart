import 'package:flutter/material.dart';
import 'package:gdocs_flutter/screens/home_screen.dart';
import 'package:gdocs_flutter/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
    routes: {'/': (route) => const MaterialPage(child: LoginScreen())});

final loggedInRoute =
    RouteMap(routes: {'/': (route) => const MaterialPage(child: HomeScreen())});
