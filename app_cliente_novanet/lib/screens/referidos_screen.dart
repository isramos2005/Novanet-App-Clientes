// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';

import 'package:app_cliente_novanet/screens/referir_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../api.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

class referidos_Screen extends StatefulWidget {
  const referidos_Screen({Key? key}) : super(key: key);

  @override
  State<referidos_Screen> createState() => _referidos_ScreenState();
}

class _referidos_ScreenState extends State<referidos_Screen> {
  late ColorNotifire notifire;
  int _itemsPerPage = 10;
  List listadodereferidos = [];
  bool _isLoading = true;
  int _currentPage = 0; // Página actual

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  void initState() {
    PagosByCliente();
    super.initState();
  }

  Future<void> PagosByCliente() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var piIDCliente = prefs.getString("fiIDCliente");

      final response = await http.post(Uri.parse(
          '${apiUrl}Servicio/ClientesReferidos_Listado_ByCliente?piIDEquifaxClienteReferente=$piIDCliente'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          listadodereferidos = data;
  
          _isLoading = false;
        });
      } else {
        if (kDebugMode) {
          print('Error en la solicitud: ${response.statusCode}');
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Excepción en la solicitud: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      notifire = Provider.of<ColorNotifire>(context, listen: true);

    // Calcular los índices de inicio y fin para la página actual
    final int _startIndex = _currentPage * _itemsPerPage;
    final int _endIndex = (_startIndex + _itemsPerPage) > listadodereferidos.length
        ? listadodereferidos.length
        : _startIndex + _itemsPerPage;

    // Elementos para la página actual
    List<dynamic> currentPageItems = [];
    if (_startIndex < listadodereferidos.length) {
      currentPageItems = listadodereferidos.sublist(
        _startIndex,
        _endIndex,
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: notifire.getwhite),
        backgroundColor: notifire.getorangeprimerycolor,
        title: Text(
          'Referidos',
          style: TextStyle(
              fontFamily: "Gilroy Bold",
              color: notifire.getwhite,
              fontSize: 20),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: notifire.getwhite),
            ),
            child: Icon(Icons.arrow_back, color: notifire.getwhite),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<int>(
              value: _itemsPerPage,
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: notifire.getdarkscolor),
              underline: Container(
                height: 2,
                color: notifire.getdarkscolor,
              ),
              dropdownColor: notifire.getbackcolor,
              onChanged: (int? newValue) {
                setState(() {
                  _itemsPerPage = newValue!;
                  _currentPage = 0; // Reiniciar a la primera página
                });
              },
              items: <int>[10, 25, 50].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(
                    'Mostrar ' + value.toString(),
                    style: TextStyle(color: notifire.getdarkscolor),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          IconButton(
            icon: Icon(Icons.person_add_alt, color: notifire.getwhite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReferirScreen(),
                ),
              );
            },
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 50,
            ),
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(
                  color: notifire.getorangeprimerycolor,
                ),
              )
            else if (listadodereferidos.isEmpty)
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'images/referidos.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No cuentas con Referidos',
                      style: TextStyle(
                        fontFamily: "Gilroy Bold",
                        color: notifire.getdarkscolor,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                color: notifire.getprimerycolor,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/referidos.png',
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            Container(
              height: height / 1.15,
              color: Colors.transparent,
              child: Card(
                color: notifire.getbackcolor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black12, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(40, 40),
                            backgroundColor: (_currentPage > 0)
                                ? notifire.getorangeprimerycolor
                                : Colors.grey,
                          ),
                          onPressed: () {
                            if (_currentPage > 0) {
                              setState(() {
                                _currentPage--;
                              });
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                        Text(
                          "Mostrando ${_startIndex + 1} - $_endIndex de ${listadodereferidos.length} registros",
                          style: TextStyle(
                            fontFamily: "Gilroy Medium",
                            color: notifire.getdarkscolor.withOpacity(0.6),
                            fontSize: height * 0.013,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(40, 40),
                            backgroundColor: (_endIndex < listadodereferidos.length)
                                ? notifire.getorangeprimerycolor
                                : Colors.grey,
                          ),
                          onPressed: (_endIndex < listadodereferidos.length)
                              ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                }
                              : null,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
                      for (int i = _startIndex; i <= _endIndex; i++)
                        if (i < listadodereferidos.length)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: height * 0.07,
                                    width: width / 7,
                                    decoration: BoxDecoration(
                                      color: notifire.getprimerycolor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "images/logos.png",
                                        height: height / 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        listadodereferidos[i]
                                                ['fcNombreReferido']
                                            .toString(),
                                        style: TextStyle(
                                          fontFamily: "Gilroy Bold",
                                          color: notifire.getdarkscolor,
                                          fontSize: height * 0.015,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        listadodereferidos[i]
                                                    ['fbClienteInstalado'] ==
                                                true
                                            ? 'Activo'
                                            : 'No Activo',
                                        style: TextStyle(
                                          fontFamily: "Gilroy Medium",
                                          color: listadodereferidos[i]
                                                      ['fbClienteInstalado'] ==
                                                  true
                                              ? Colors.green.shade200
                                              : Colors.red.shade200,
                                          fontSize: height * 0.015,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      SizedBox(height: height * 0.005),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                listadodereferidos[i]
                                                    ['fdFechaCreacion'],
                                              ),
                                            ) +
                                            ' - ' +
                                            DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(
                                                listadodereferidos[i]
                                                    ['fdFechaVencimiento'],
                                              ),
                                            ),
                                        style: TextStyle(
                                          fontFamily: "Gilroy Medium",
                                          color: notifire.getdarkscolor
                                              .withOpacity(0.6),
                                          fontSize: height * 0.013,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                      SizedBox(height: height * 0.005),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.005),
                              const Divider(),
                            ],
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
