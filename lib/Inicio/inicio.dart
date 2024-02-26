import 'package:flutter/material.dart';
import '../ListaProductos/ListaProductos.dart';
import '../Header//header.dart';
import 'dart:convert';
import '../config.dart';

class InicioPagina extends StatefulWidget {
  @override
  _InicioPaginaState createState() => _InicioPaginaState();
}

class _InicioPaginaState extends State<InicioPagina> {
  String _query = '';

  @override build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Buscar producto',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
          ),
          Expanded(child: ListaProductosPagina(query: _query),
          ),
        ],
      ),
    );
  }
}

