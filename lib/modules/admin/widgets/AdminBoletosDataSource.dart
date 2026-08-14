import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/AdminBoletoModel.dart';

class AdminBoletosDataSource extends DataGridSource {
  List<AdminBoletoModel> boletos;

  final void Function(AdminBoletoModel boleto) onDetalle;

  int registrosPorPagina;

  List<DataGridRow> _todasLasFilas = [];
  List<DataGridRow> _filasDePagina = [];

  final Map<DataGridRow, AdminBoletoModel> _boletoPorFila = {};

  AdminBoletosDataSource({
    required this.boletos,
    required this.onDetalle,
    required this.registrosPorPagina,
  }) {
    _crearFilas();
    _cargarPagina(0);
  }

  void actualizarBoletos(
    List<AdminBoletoModel> nuevosBoletos,
  ) {
    boletos = nuevosBoletos;

    _crearFilas();
    _cargarPagina(0);

    notifyListeners();
  }

  void actualizarRegistrosPorPagina(
    int cantidad,
  ) {
    registrosPorPagina = cantidad;

    _cargarPagina(0);

    notifyListeners();
  }

  void _crearFilas() {
    _boletoPorFila.clear();

    _todasLasFilas = boletos.map((boleto) {
      final fila = DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'folio',
            value: boleto.folio,
          ),
          DataGridCell<String>(
            columnName: 'nombre',
            value: boleto.nombre,
          ),
          DataGridCell<String>(
            columnName: 'registro',
            value: boleto.quienRegistro,
          ),
          DataGridCell<String>(
            columnName: 'fecha_registro',
            value: boleto.fechaCreacion,
          ),
          DataGridCell<int>(
            columnName: 'checked',
            value: boleto.checkIn,
          ),
          DataGridCell<String>(
            columnName: 'fecha_checked',
            value: boleto.fechaCheckIn ?? '',
          ),
          DataGridCell<int>(
            columnName: 'intentos',
            value: boleto.intentos,
          ),
        ],
      );

      _boletoPorFila[fila] = boleto;

      return fila;
    }).toList();
  }

  void _cargarPagina(int pagina) {
    final inicio = pagina * registrosPorPagina;

    if (inicio >= _todasLasFilas.length) {
      _filasDePagina = [];
      return;
    }

    final fin = (inicio + registrosPorPagina) > _todasLasFilas.length
        ? _todasLasFilas.length
        : inicio + registrosPorPagina;

    _filasDePagina = _todasLasFilas.getRange(inicio, fin).toList();
  }

  @override
  List<DataGridRow> get rows => _filasDePagina;

  @override
  Future<bool> handlePageChange(
    int oldPageIndex,
    int newPageIndex,
  ) async {
    _cargarPagina(newPageIndex);
    notifyListeners();

    return true;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final boleto = _boletoPorFila[row];
    final rowIndex = _todasLasFilas.indexOf(row);

    return DataGridRowAdapter(
      color: rowIndex.isEven ? Colors.white : Colors.grey.shade100,
      cells: row.getCells().map((cell) {
        if (cell.columnName == 'nombre') {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: InkWell(
              onTap: boleto == null
                  ? null
                  : () {
                      onDetalle(boleto);
                    },
              child: Text(
                cell.value.toString(),
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        if (cell.columnName == 'checked') {
          return Container(
            alignment: Alignment.center,
            child: Icon(
              cell.value == 1
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: cell.value == 1 ? Colors.green : Colors.grey,
              size: 26,
            ),
          );
        }

        if (cell.columnName == 'fecha_checked') {
          final fecha = cell.value?.toString() ?? '';

          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Text(
              fecha.isEmpty ? '—' : fecha,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (cell.columnName == 'folio' || cell.columnName == 'intentos') {
          return Container(
            alignment: Alignment.center,
            child: Text(
              cell.value.toString(),
            ),
          );
        }

        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            cell.value.toString(),
          ),
        );
      }).toList(),
    );
  }
}
