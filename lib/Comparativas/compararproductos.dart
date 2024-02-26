import 'package:flutter/material.dart';
import '../ListaProductos/ListaProductos.dart';
import '../Header//header.dart';
import 'dart:convert';
import '../config.dart';

class CompararProductosPagina extends StatefulWidget {

  @override
  _CompararProductosPaginaState createState() => _CompararProductosPaginaState();
}

class _CompararProductosPaginaState extends State<CompararProductosPagina> {
  String? _metdatoSeleccionado;
  String? _primerProductoSeleccionado;
  String? _segundoProductoSeleccionado;
  List<dynamic>? _productos;
  List<dynamic>? _metadatos;
  String? _primerProductoNombre;
  String? _primerProductoDescripcion;
  String? _primerProductoFabricante;
  String? _primerProductoPrecio;
  String? _primerProductoValoracion;
  String? _primerProductoImagen;

  String? _segundoProductoNombre;
  String? _segundoProductoDescripcion;
  String? _segundoProductoFabricante;
  String? _segundoProductoPrecio;
  String? _segundoProductoValoracion;
  String? _segundoProductoImagen;

  @override
  void initState() {
    super.initState();
    _fetchProductos();
    _fetchMetadatos();
  }

  Future<void> _fetchProductosPorMetadato(int idmetadato) async {
    try {
      final respone = await ApiService.fetchData('productos/metadatos/$idmetadato');
      if (respone.statusCode == 200) {
        setState(() {
          _productos = json.decode(respone.body);
          _primerProductoSeleccionado = null;
          _segundoProductoSeleccionado = null;
          _primerProductoNombre = null;
          _segundoProductoNombre = null;
          _primerProductoImagen = null;
          _segundoProductoImagen = null;
        });
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchProductos() async {
    try {
      if(_metdatoSeleccionado != null) {
        print(_metdatoSeleccionado);
        await _fetchProductosPorMetadato(int.parse(_metdatoSeleccionado!));
      } else {
        final response = await ApiService.fetchData('productos');
        if(response.statusCode == 200) {
          setState(() {
            _productos = json.decode(utf8.decode(response.bodyBytes));
          });
        } else{
          throw Exception('Error al cargar los productos');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchMetadatos() async {
    try {
      final respone = await ApiService.fetchData('metadatos');
      if (respone.statusCode == 200) {
        setState(() {
          _metadatos = json.decode(utf8.decode(respone.bodyBytes));
        });
      } else {
        throw Exception('Error al cargar los productos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updatePrimeroProducto() {
    print(_primerProductoSeleccionado);
    if (_productos != null && _primerProductoSeleccionado != null) {
      final productoSeleccionado = _productos!.firstWhere(
              (producto) =>
          producto['idproducto'].toString() == _primerProductoSeleccionado);
      setState(() {
        _primerProductoNombre = productoSeleccionado['nombre'];
        _primerProductoDescripcion = productoSeleccionado['descripcion'];
        _primerProductoFabricante = productoSeleccionado['fabricante'];
        _primerProductoPrecio = productoSeleccionado['precio'].toString();
        _primerProductoValoracion = productoSeleccionado['valoracion'].toString();
        _primerProductoImagen = productoSeleccionado['imagen'];
      });
    }
  }

  void _updateSegundoProducto() {
    if (_productos != null && _segundoProductoSeleccionado != null) {
      final productoSeleccionado = _productos!.firstWhere(
              (producto) =>
          producto['idproducto'].toString() == _segundoProductoSeleccionado);
      setState(() {
        _segundoProductoNombre = productoSeleccionado['nombre'];
        _segundoProductoDescripcion = productoSeleccionado['descripcion'];
        _segundoProductoFabricante = productoSeleccionado['fabricante'];
        _segundoProductoPrecio = productoSeleccionado['precio'].toString();
        _segundoProductoValoracion = productoSeleccionado['valoracion'].toString();
        _segundoProductoImagen = productoSeleccionado['imagen'];
      });
    }
  }

  @override build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparativa en tiempo real'),
      ),
      body: Center(
        child: _productos != null
          ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          DropdownButton<String>(
          isExpanded: true,
          value: _metdatoSeleccionado,
          onChanged: (String? newValue) {
            setState(() {
              _metdatoSeleccionado = newValue;
              _fetchProductos();
            });
          },
          items: _metadatos != null
          ? [
            DropdownMenuItem<String>(
              value: null,
              child: Text('Seleccionar tipo'),
            ),
            ..._metadatos!.map<DropdownMenuItem<String>>((metadato) {
              return DropdownMenuItem<String>(
                value: metadato['idmetadato'].toString(),
                child: Text(metadato['nombre'],),
              );
            }
            ).toList(),
          ]
    : [],
        ),
        SizedBox(height: 20),
          Expanded(child:
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Expanded(
              child: Column(
                children: [ DropdownButton<String>(
                  isExpanded: true,
                  value: _primerProductoSeleccionado,
                  onChanged: (String? newValue) {
                    setState(() {
                      _primerProductoSeleccionado = newValue;
                      _updatePrimeroProducto();
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text('Seleccionar producto'),
                    ),
                    ..._productos!.map<DropdownMenuItem<String>>((producto) {
                      return DropdownMenuItem<String>(
                        value: producto['idproducto'].toString(),
                        child: Text(producto['nombre'],),
                      );
                    },
                    ),
                  ],
                ),
                  if (_primerProductoImagen != null)
                    Image(image: NetworkImage(_primerProductoImagen!)
                    ),
                  SizedBox(height: 5),
                  Visibility(
                    visible: _primerProductoNombre != null,
                    child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title:
                          Text(
                            '$_primerProductoNombre',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),

                        ListTile(
                          title:
                          Text(
                            '$_primerProductoDescripcion',
                            textAlign: TextAlign.center,
                          ),
                          leading: Icon(Icons.description_outlined),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
                        ListTile(
                          title:
                          Text(
                            '$_primerProductoFabricante',
                            textAlign: TextAlign.center,
                          ),
                          leading: Icon(Icons.carpenter_outlined),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),

                        ListTile(
                          title:
                          Text(
                            '$_primerProductoPrecio €',
                            textAlign: TextAlign.center,
                          ),
                          leading: Icon(Icons.money),
                        ),

                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),

                        ListTile(
                          title:
                          Text(
                            '$_primerProductoValoracion',
                            textAlign: TextAlign.center,
                          ),
                          leading: Icon(Icons.star),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
                ],
              ),
            ),
                  ),
              ],
              ),
            ),
              Expanded(
                child: Column(
                children: [ DropdownButton<String>(
                  isExpanded: true,
                  value: _segundoProductoSeleccionado,
                  onChanged: (String? newValue) {
                    setState(() {
                      _segundoProductoSeleccionado = newValue;
                      _updateSegundoProducto();
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: null,
                      child: Text('Seleccionar producto'),
                    ),
                    ..._productos!.map<DropdownMenuItem<String>>((producto) {
                      return DropdownMenuItem<String>(
                        value: producto['idproducto'].toString(),
                        child: Text(producto['nombre'],),
                      );
                    },
                    ),
                  ],
                ),
                  if (_segundoProductoImagen != null)
                    Image(image: NetworkImage(_segundoProductoImagen!)
                    ),
                  SizedBox(height: 5),
                  Visibility(
                    visible: _segundoProductoNombre != null,

                    child: Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title:
                            Text(
                              '$_segundoProductoNombre',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),

                        ListTile(
                          title:
                            Text(
                              '$_segundoProductoDescripcion',
                              textAlign: TextAlign.center,
                            ),
                          leading: Icon(Icons.description_outlined),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
                        ListTile(
                          title:
                            Text(
                              '$_segundoProductoFabricante',
                              textAlign: TextAlign.center,
                            ),
                          leading: Icon(Icons.carpenter_outlined),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
                        ListTile(
                          title:
                            Text(
                              '$_segundoProductoPrecio €',
                              textAlign: TextAlign.center,
                            ),
                          leading: Icon(Icons.money),
                        ),

                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),

                        ListTile(
                          title:
                            Text(
                              '$_segundoProductoValoracion',
                              textAlign: TextAlign.center,
                            ),
                          leading: Icon(Icons.star),
                        ),
                        SizedBox(height: 5),
                        Divider(),
                        SizedBox(height: 5),
                ],
              ),
              ),
                  ),
          ],
        ),
          ),
            ],
          ),
          ),
            ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
