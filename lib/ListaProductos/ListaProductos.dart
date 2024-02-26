import 'package:flutter/material.dart';
import 'dart:convert';
import '../config.dart';

class ListaProductosPagina extends StatefulWidget {

  final String query;
  final String? metadatoSeleccionado;

  ListaProductosPagina({this.query = '', this.metadatoSeleccionado});

  @override
  _ListaProductosPaginaState createState() => _ListaProductosPaginaState();
}

class _ListaProductosPaginaState extends State<ListaProductosPagina> {
  List<dynamic> productos = [];

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    final response = await ApiService.fetchData('productos');

    if(response.statusCode == 200) {
      setState(() {
        productos = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Fallo cargando los productos');
    }
  }

    List<dynamic> getProductosFiltrados() {
      if (widget.metadatoSeleccionado != null && widget.metadatoSeleccionado!.isNotEmpty) {
        return productos.where((producto) =>
          producto['idmetadato']['idmetadato'].toString() == widget.metadatoSeleccionado).toList();
      }
      else if (widget.query != null && widget.query.isNotEmpty) {
        return productos.where((producto) =>
        producto['nombre'] != null &&
            producto['nombre'].toString().toLowerCase()
            .contains(widget.query.toLowerCase())).toList();
      }
      else {
        return productos;
      }

  }

  @override
  Widget build(BuildContext context) {
      final productosFiltrados = getProductosFiltrados();

      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.builder(
            itemCount: productosFiltrados.length,
              itemBuilder: (BuildContext context, int index) {
              final producto = productosFiltrados[index];
            return ListTile(
                leading: AspectRatio(
                  aspectRatio: 4,
                child: Image.network(
                  producto['imagen'],

                  fit: BoxFit.fitHeight,
                ),
                ),
              title: Text(producto['nombre']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(producto['descripcion'].toString()),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.carpenter_outlined),
                      SizedBox(width: 2),
                      Text('Fabricante: ${producto['fabricante'] ?? ''}'),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.money),
                      SizedBox(width: 2),
                      Text('Precio: ${producto['precio']  ?? ''} € '),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.star),
                      SizedBox(width: 2),
                      Text('Valoración: ${producto['valoracion'] ?? ''}'),
                    ],
                  ),
                ],

              )


            );
            },
          ),
      );
  }
}

