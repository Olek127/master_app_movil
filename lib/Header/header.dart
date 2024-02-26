import 'package:flutter/material.dart';
import 'package:master_comprathor/Comparativas/comparativas.dart';
import 'dart:convert';
//import '../ListaProductos/ListaProductos.dart';
//import '../Inicio/inicio.dart';
import 'package:master_comprathor/ListaProductos/ListaProductos.dart';
import 'package:master_comprathor/Inicio/inicio.dart';
import 'package:master_comprathor/Productos/productos.dart';
import 'package:master_comprathor/config.dart';

//import '../config.dart';

Map<String, IconData> iconMap = {
  'FaIcons.FaPlug': Icons.flash_on,
  'FaIcons.FaCouch': Icons.weekend,
  'FaIcons.FaTshirt': Icons.local_mall_outlined,
  'FaIcons.FaFutbol': Icons.sports_soccer,
};


class Header extends StatefulWidget {
  final Widget child;

  Header({required this.child});

  @override
  _HeaderState createState() => _HeaderState();

}

class _HeaderState extends State<Header> {

  Future<List<dynamic>>? _categorias;

  @override
  void initState() {
    super.initState();
    _categorias = _fetchCategorias();
  }

  IconData _getIcon(String? nombreIcono) {
    if(nombreIcono != null && iconMap.containsKey(nombreIcono)) {
      return iconMap[nombreIcono] ?? Icons.error;
    } else {
      return Icons.error;
    }
  }

  Future<List<dynamic>> _fetchCategorias() async {
    final respone = await ApiService.fetchData('categorias');
    if (respone.statusCode == 200) {
      List<dynamic> categorias = json.decode(Utf8Decoder().convert(respone.bodyBytes));
      return categorias;
    } else {
      throw Exception('Error al cargar categorias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprathor'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      drawer: Drawer(
        child: FutureBuilder<List<dynamic>>(
          future: _categorias,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: $snapshot.error}');
            } else {
              List<dynamic>? categorias = snapshot.data;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Inicio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => InicioPagina()),
                      );
                    },
                  ),
              ExpansionTile(
                leading: Icon(Icons.layers),
                title: Text('Categorias',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  if(categorias != null)
                    for (var categoria in categorias!)
                      ListTile(
                        contentPadding: EdgeInsets.only(left: 26),
                        leading: Icon(_getIcon(categoria['icono'])),
                        title: Text(
                          categoria['nombre'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductosPagina(idCategoria: categoria['idcategoria'])),
                          );
                        },
                      ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.compare_arrows),
                title: Text('Comparativas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ComparativasPagina(idUsuario: 10)),
                  );
                },
              ),

            ],
          );
        }
      },
      ),
      ),
      body: widget.child,
    );
  }
}
