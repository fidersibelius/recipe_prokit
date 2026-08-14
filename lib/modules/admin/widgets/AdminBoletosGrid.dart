import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/AdminBoletoModel.dart';
import 'AdminBoletosDataSource.dart';

class AdminBoletosGrid extends StatefulWidget {
  final Function(AdminBoletoModel) onDetalle;
  final List<AdminBoletoModel> boletos;

  const AdminBoletosGrid({
    super.key,
    required this.boletos,
    required this.onDetalle,
  });

  @override
  State<AdminBoletosGrid> createState() => _AdminBoletosGridState();
}

class _AdminBoletosGridState extends State<AdminBoletosGrid> {
  static const List<int> opcionesDePaginacion = [
    10,
    50,
    100,
    500,
    1000,
    0, // 0 significa Todos
  ];

  int registrosPorPagina = 10;

  late AdminBoletosDataSource dataSource;

  @override
  void initState() {
    super.initState();

    dataSource = AdminBoletosDataSource(
      boletos: widget.boletos,
      registrosPorPagina: registrosPorPagina,
      onDetalle: (boleto) {
        widget.onDetalle(boleto);
      },
    );
  }

  @override
  void didUpdateWidget(
    covariant AdminBoletosGrid oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.boletos != widget.boletos) {
      dataSource.actualizarBoletos(
        widget.boletos,
      );

      if (registrosPorPagina == 0) {
        dataSource.actualizarRegistrosPorPagina(
          math.max(1, widget.boletos.length),
        );
      }
    }
  }

  double get totalPaginas {
    if (widget.boletos.isEmpty || registrosPorPagina == 0) {
      return 1;
    }

    return math
        .max(
          1,
          (widget.boletos.length / registrosPorPagina).ceil(),
        )
        .toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SfDataGrid(
            source: dataSource,
            headerRowHeight: 55,
            rowHeight: 65,
            gridLinesVisibility: GridLinesVisibility.horizontal,
            headerGridLinesVisibility: GridLinesVisibility.horizontal,
            showHorizontalScrollbar: true,
            isScrollbarAlwaysShown: true,
            horizontalScrollPhysics: const AlwaysScrollableScrollPhysics(),
            columns: [
              GridColumn(
                width: 70,
                columnName: 'folio',
                label: _encabezado(
                  texto: '#',
                  alineacion: Alignment.center,
                ),
              ),
              GridColumn(
                width: 180,
                columnName: 'nombre',
                label: _encabezado(
                  texto: 'Nombre',
                ),
              ),
              GridColumn(
                width: 110,
                columnName: 'registro',
                label: _encabezado(
                  texto: 'Registró',
                ),
              ),
              GridColumn(
                width: 170,
                columnName: 'fecha_registro',
                label: _encabezado(
                  texto: 'F. Registro',
                  alineacion: Alignment.center,
                ),
              ),
              GridColumn(
                width: 110,
                columnName: 'checked',
                label: _encabezado(
                  texto: 'Ingresado',
                  alineacion: Alignment.center,
                ),
              ),
              GridColumn(
                width: 170,
                columnName: 'fecha_checked',
                label: _encabezado(
                  texto: 'F. Check-in',
                  alineacion: Alignment.center,
                ),
              ),
              GridColumn(
                width: 90,
                columnName: 'intentos',
                label: _encabezado(
                  texto: 'Intentos',
                  alineacion: Alignment.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Filas por página:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            DropdownButton<int>(
              value: registrosPorPagina,
              items: opcionesDePaginacion.map((cantidad) {
                return DropdownMenuItem<int>(
                  value: cantidad,
                  child: Text(
                    cantidad == 0 ? 'Todos' : cantidad.toString(),
                  ),
                );
              }).toList(),
              onChanged: (nuevaCantidad) {
                if (nuevaCantidad == null) {
                  return;
                }

                setState(() {
                  registrosPorPagina = nuevaCantidad;

                  final cantidadReal = nuevaCantidad == 0
                      ? math.max(1, widget.boletos.length)
                      : nuevaCantidad;

                  dataSource.actualizarRegistrosPorPagina(
                    cantidadReal,
                  );
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 60,
          child: SfDataPager(
            key: ValueKey(registrosPorPagina),
            pageCount: totalPaginas,
            delegate: dataSource,
          ),
        ),
      ],
    );
  }

  Widget _encabezado({
    required String texto,
    Alignment alineacion = Alignment.centerLeft,
  }) {
    return Container(
      color: Colors.indigo,
      alignment: alineacion,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: Text(
        texto,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _encabezadoConIcono(
    IconData icono,
  ) {
    return Container(
      color: Colors.indigo,
      alignment: Alignment.center,
      child: Icon(
        icono,
        color: Colors.white,
      ),
    );
  }
}
