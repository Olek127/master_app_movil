import 'dart:html';

import 'package:flutter/material.dart';
import '../ListaProductos/ListaProductos.dart';
import '../Header//header.dart';
import 'dart:convert';
import '../config.dart';
import 'package:master_comprathor/Inicio/inicio.dart';
import 'package:master_comprathor/Comparativas/anadircomparativa.dart';
import 'package:master_comprathor/Comparativas/compararproductos.dart';

class ComparativasPagina extends StatefulWidget {
  final int idUsuario;

  ComparativasPagina({required this.idUsuario});

  @override
  _ComparativasPaginaState createState() => _ComparativasPaginaState();
}

class _ComparativasPaginaState extends State<ComparativasPagina> {
  String? _selectedOpcion;
  List<String> _opcionesUsuario = ['Comparativas Propias', 'Comparativas de Otros usuarios'];
  int? _selectedUsuarioId;
  List<dynamic>? _comparativas;
  Map<int, List<dynamic>> _productosPorComparativa = {};

  @override
  void initState() {
    super.initState();
    _selectedOpcion = _opcionesUsuario[0];
    _fetchComparativas();
  }


  Future<void> _fetchComparativas() async {
    try {
      if(_selectedOpcion == 'Comparativas Propias') {
        _selectedUsuarioId = 10;
      }
      else {
        _selectedUsuarioId = null;
      }

      final response = await ApiService.fetchData(
          _selectedUsuarioId != null
          ? 'comparativas/usuario/${_selectedUsuarioId}' :'comparativas'
      );
      if(response.statusCode == 200) {
        setState(() {
          _comparativas = json.decode(utf8.decode(response.bodyBytes));
          _fetchProductos();
        });
      }
      else {
        throw Exception('Error al cargar comparativas');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchProductos() async {
    try {
        if(_comparativas != null) {
          for (var comparativa in _comparativas!) {
            final idComparativa = comparativa['idcomparativa'];
            if(idComparativa == null){
              continue;
            }
            final response1 = await ApiService.fetchData('productos/${comparativa['idproducto1']['idproducto']}');
            final response2 = await ApiService.fetchData('productos/${comparativa['idproducto2']['idproducto']}');
            if(response1.statusCode == 200 && response2.statusCode == 200) {
              final producto1 = json.decode(utf8.decode(response1.bodyBytes));
              final producto2 = json.decode(utf8.decode(response2.bodyBytes));
              setState(() {
                _productosPorComparativa[comparativa['idcomparativa']] = [producto1, producto2];
              });
          }
        }
      }
    } catch (e) {
      print('Error: $e');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Comparativas'),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AnadirComparativaPagina()),
                  );
                },
                icon: Icon(Icons.add),
              ),
              Text('Añadir'),
              SizedBox(width: 8),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CompararProductosPagina()),
                  );
                },
                icon: Icon(Icons.timer_outlined),
              ),
              Text('Comparar'),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column (
          children: [
            DropdownButton<String>(
              value: _selectedOpcion,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOpcion = newValue;
                  _fetchComparativas();
                });
              },
              items: _opcionesUsuario.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _comparativas != null
                  ? ListView.builder(
                itemCount: _comparativas!.length,
                itemBuilder: (context, index) {
                  final comparativa = _comparativas![index];
                  final idComparativa = comparativa['idcomparativa'];

                  if(idComparativa == null) {
                    return SizedBox.shrink();
                  }

                  final productos = _productosPorComparativa[idComparativa];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          comparativa['titulo'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        subtitle:
                        Text(
                          comparativa['descripcion'] ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),

                      ),
                      SizedBox(height: 5),
                        ListView.builder(
                              itemCount: productos != null ? productos.length : 0,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (productos == null || productos.isEmpty) {
                                  return SizedBox.shrink();
                                }
                                final producto = productos![index];
                                return Card(
                                    child: ListTile(
                                  title:
                                  Text(
                                  producto['nombre'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                        producto['descripcion'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                      if(producto['imagen'] != null)
                                        Image.network(
                                          producto['imagen'],
                                          height: 200,
                                          width: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.carpenter_outlined),
                                              SizedBox(width: 2),
                                              Text('Fabricante: ${producto['fabricante'] ?? ''}'),
                                            ],
                                          ),
                                          SizedBox(height: 25),
                                          Row(
                                            children: [
                                              Icon(Icons.money),
                                              SizedBox(width: 2),
                                              Text('Precio: ${producto['precio']  ?? ''} € '),
                                            ],
                                          ),
                                          SizedBox(height: 25),
                                          Row(
                                            children: [
                                              Icon(Icons.star),
                                              SizedBox(width: 2),
                                              Text('Valoración: ${producto['valoracion'] ?? ''}'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  ],
                                ),
                                    ),
                                );
                              },
                        ),

                    ],

                  );
                },
              )
                  : CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}