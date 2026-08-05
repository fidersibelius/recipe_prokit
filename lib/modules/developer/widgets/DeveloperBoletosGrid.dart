import 'package:flutter/material.dart';

import '../models/BoletoModel.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'DeveloperBoletosDataSource.dart';

class DeveloperBoletosGrid extends StatelessWidget {
  final Function(BoletoModel) onDetalle;
  final List<BoletoModel> boletos;

  const DeveloperBoletosGrid({
    super.key,
    required this.boletos,
    required this.onDetalle,
  });

  @override
  Widget build(BuildContext context) {
    final dataSource = DeveloperBoletosDataSource(
      boletos: boletos,
    );
    return SfDataGrid(
      headerRowHeight: 55,
      rowHeight: 65,
      gridLinesVisibility: GridLinesVisibility.horizontal,
      headerGridLinesVisibility: GridLinesVisibility.horizontal,
      source: dataSource,
      onCellTap: (details) {
        if (details.rowColumnIndex.rowIndex == 0) {
          return;
        }

        final index = details.rowColumnIndex.rowIndex - 1;

        onDetalle(
          dataSource.boletos[index],
        );
      },
      columns: [
        GridColumn(
          width: 160,
          columnName: 'nombre',
          label: Container(
            color: Colors.indigo,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text(
              'Nombre',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GridColumn(
          width: 80,
          columnName: 'registro',
          label: Container(
            color: Colors.indigo,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text(
              'Registro',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GridColumn(
          width: 110,
          columnName: 'estado',
          label: Container(
            color: Colors.indigo,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text(
              'Estado',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
