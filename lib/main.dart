import 'package:flutter/material.dart';
import 'package:master_comprathor/Inicio/inicio.dart';
import 'package:keycloak_flutter/keycloak_flutter.dart';
import 'config.dart';
import 'ListaProductos/ListaProductos.dart';
import 'Header/header.dart';

late KeycloakService keycloakService;

Future<void> main() async {
  keycloakService = KeycloakService(KeycloakConfig(
    url: "http://localhost:8080/",
    realm: "SpringBootKeycloak",
    clientId: "login-app",
  ));
  await keycloakService.init(
    initOptions: KeycloakInitOptions(
      onLoad: 'login-required',
      checkLoginIframe: true,
      pkceMethod: 'S256',
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: keycloakService.isLoggedIn(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return CircularProgressIndicator();
          }
          else
          {
            if(snapshot.hasData && snapshot.data!)
            {
              return Header(child: InicioPagina(),);
            }
            else
            {
              return Center(child: Text('El usuario no se ha autenticado'),);
            }
          }
        },
      ),
    );
  }
}