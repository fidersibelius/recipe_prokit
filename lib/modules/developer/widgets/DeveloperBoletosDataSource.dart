import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../models/BoletoModel.dart';

class DeveloperBoletosDataSource extends DataGridSource {
  late List<BoletoModel> boletos;

  late List<DataGridRow> _rows;

  DeveloperBoletosDataSource({
    required List<BoletoModel> boletos,
  }) {
    this.boletos = boletos;

    _rows = boletos.map((boleto) {
      return DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'nombre',
            value: boleto.nombre,
          ),
          DataGridCell<String>(
            columnName: 'registro',
            value: boleto.quienRegistro,
          ),
          DataGridCell<String>(
            columnName: 'estado',
            value: boleto.checkIn == 1 ? "Usado" : "Disponible",
          ),
        ],
      );
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _rows;
  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
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
