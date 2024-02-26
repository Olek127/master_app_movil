import 'package:flutter/material.dart';
import '../ListaProductos/ListaProductos.dart';
import '../Header//header.dart';
import 'dart:convert';
import '../config.dart';

class ProductosPagina extends StatefulWidget {
  final int? idCategoria;

  ProductosPagina({this.idCategoria});

  @override
  _ProductosPaginaState createState() => _ProductosPaginaState();
}

class _ProductosPaginaState extends State<ProductosPagina> {
  String? _metadatoSeleccionado;
  List<dynamic>? _metadatos;

  @override
  void initState() {
    super.initState();
    _fetchMetadatos();
  }

  Future<void> _fetchMetadatos() async {
    try {
      final respone = await ApiService.fetchData('metadatos/categoria/${widget.idCategoria}');
      if (respone.statusCode == 200) {
        setState(() {
          _metadatos = json.decode(utf8.decode(respone.bodyBytes));
        });
      } else {
        throw Exception('Error al cargar metadatos');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: Center(
        child: _metadatos != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
                value: _metadatoSeleccionado,
                onChanged: (String? newValue) {
                  setState(() {
                    _metadatoSeleccionado = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text('Todos los productos'),
                  ),
                ..._metadatos!.map<DropdownMenuItem<String>>((metadato) {
                  return DropdownMenuItem<String>(
                      value: metadato['idmetadato'].toString(),
                      child: Text(metadato['nombre']),
                  );
                }).toList(),
              ]
            ),
            SizedBox(height: 20),
            ListaProductosPagina(metadatoSeleccionado: _metadatoSeleccionado),
          ],
        )
        : CircularProgressIndicator(),
      ),
    );
  }
}

