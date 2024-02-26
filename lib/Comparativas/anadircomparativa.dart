import 'dart:html';

import 'package:flutter/material.dart';
import '../ListaProductos/ListaProductos.dart';
import '../Header//header.dart';
import 'dart:convert';
import '../config.dart';

class AnadirComparativaPagina extends StatefulWidget {

  @override
  _AnadirComparativaPagina createState() => _AnadirComparativaPagina();
}

class _AnadirComparativaPagina extends State<AnadirComparativaPagina> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _producto1Controller = TextEditingController();
  final _descripcion1Controller = TextEditingController();
  final _fabricante1Controller = TextEditingController();
  final _precio1Controller = TextEditingController();
  final _valoracion1Controller = TextEditingController();
  final _imagen1Controller = TextEditingController();
  final _producto2Controller = TextEditingController();
  final _descripcion2Controller = TextEditingController();
  final _fabricante2Controller = TextEditingController();
  final _precio2Controller = TextEditingController();
  final _valoracion2Controller = TextEditingController();
  final _imagen2Controller = TextEditingController();

  String? _metadatoSeleccionado;
  List<dynamic>? _metadatos;

  Future<void> _fetchMetadatos() async {
    try{
      final response = await ApiService.fetchData('metadatos');
      if(response.statusCode == 200) {
        setState(() {
          _metadatos = json.decode(response.body);
        });
      }
      else {
        throw Exception('Error al cargar metadatos');
      }
    }
    catch(e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMetadatos();
  }

  @override build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Comparativa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seleccionar tipo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              DropdownButton<String>(
                value: _metadatoSeleccionado,
                onChanged: (String? newValue){
                  setState(() {
                    _metadatoSeleccionado = newValue;
                  });
                },
                items: _metadatos != null && _metadatos!.isNotEmpty
                  ? _metadatos!.map<DropdownMenuItem<String>>(
                      (metadato) {
                        return DropdownMenuItem<String>(
                        value: metadato['idmetadato'].toString(),
                        child: Text(metadato['nombre']),
                        );
                    }).toList()
                : [],
              ),


              SizedBox(height: 40),
              Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Comparativa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(labelText: 'Título'),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Error en el titulo de la comparativa';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'Error en el descripción de la comparativa';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),

              Text(
                'Primer Producto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _producto1Controller,
                decoration: InputDecoration(labelText: 'Nombre',
                prefixIcon: Icon(Icons.shopping_cart_outlined)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en el nombre del primer producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcion1Controller,
                decoration: InputDecoration(labelText: 'Descripción',
                prefixIcon: Icon(Icons.description_outlined)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en la descripción del primer producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fabricante1Controller,
                decoration: InputDecoration(labelText: 'Fabricante',
                prefixIcon: Icon(Icons.carpenter_outlined)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en el fabricante del primer producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precio1Controller,
                decoration: InputDecoration(labelText: 'Precio',
                prefixIcon: Icon(Icons.money)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en el precio del primer producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valoracion1Controller,
                decoration: InputDecoration(labelText: 'Valoración',
                prefixIcon: Icon(Icons.star)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en la valoración del primer producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagen1Controller,
                decoration: InputDecoration(labelText: 'Imagen (Url)',
                prefixIcon: Icon(Icons.image)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en la imagen del primer producto';
                  }
                  return null;
                },
              ),

              SizedBox(height: 40),
              SizedBox(height: 40),

              Text(
                'Segundo Producto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _producto2Controller,
                decoration: InputDecoration(labelText: 'Nombre',
                prefixIcon: Icon(Icons.shopping_cart_outlined)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en el nombre del segundo producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descripcion2Controller,
                decoration: InputDecoration(labelText: 'Descripción',
                prefixIcon: Icon(Icons.description_outlined)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en la descripción del segundo producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fabricante2Controller,
                decoration: InputDecoration(labelText: 'Fabricante',
                prefixIcon: Icon(Icons.carpenter_outlined)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en el fabricante del segundo producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _precio2Controller,
                decoration: InputDecoration(labelText: 'Precio',
                prefixIcon: Icon(Icons.money)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en el precio del segundo producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _valoracion2Controller,
                decoration: InputDecoration(labelText: 'Valoración',
                prefixIcon: Icon(Icons.star)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en la valoración del segundo producto';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imagen2Controller,
                decoration: InputDecoration(labelText: 'Imagen (Url)',
                prefixIcon: Icon(Icons.image)),
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return 'Error en la imagen del segundo producto';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {
                      final primerproducto = {
                        'idmetadato': _metadatoSeleccionado,
                        'nombre': _producto1Controller.text,
                        'descripcion': _descripcion1Controller.text,
                        'fabricante': _fabricante1Controller.text,
                        'precio': _precio1Controller.text,
                        'valoracion': _valoracion1Controller.text,
                        'imagen': _imagen1Controller.text,
                        'idusuario':10,
                      };

                      final segundoproducto = {
                        'idmetadato': _metadatoSeleccionado,
                        'nombre': _producto2Controller.text,
                        'descripcion': _descripcion2Controller.text,
                        'fabricante': _fabricante2Controller.text,
                        'precio': _precio2Controller.text,
                        'valoracion': _valoracion2Controller.text,
                        'imagen': _imagen2Controller.text,
                        'idusuario':10,
                      };



                      final productos = [primerproducto, segundoproducto];

                      try {
                        final response1 = await ApiService.postData('productos', primerproducto);
                        if(response1.statusCode == 201) {
                          final idproducto1 = json.decode(response1.body)['idproducto'];

                          final response2 = await ApiService.postData('productos', segundoproducto);
                          if(response2.statusCode == 201) {
                            final idproducto2 = json.decode(response2.body)['idproducto'];

                            final comparativa = {
                              'idusuario': 10,
                              'idproducto1': idproducto1,
                              'idproducto2': idproducto2,
                              'titulo': _tituloController.text,
                              'descripcion': _descripcionController.text,
                              'valoracion': 1,
                            };
                            await ApiService.postData('comparativas', comparativa);

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Productos y comparativa añadidos')),
                            );
                          }
                          else {
                            throw Exception('Error al agregar el segundo producto');
                          }
                        }
                        else {
                          throw Exception('Error al agregar el primer producto');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  },
                  child: Text('Agregar Comparativa'),
              ),
            ],
              ),
                    ),
          ),
          ),
              ],
        ),
      ),

    );
  }
}

