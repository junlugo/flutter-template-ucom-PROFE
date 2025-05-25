import 'package:finpay/model/motivo_visita.dart';
import 'package:get/get.dart';
import 'package:finpay/api/local.db.service.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Reservahistorial {
  final Auto auto;
  final Piso piso;
  final Lugar lugar;
  final DateTime inicio;
  final DateTime salida;
  final int monto;
  final MotivoVisita motivo;

  Reservahistorial({
    required this.auto,
    required this.piso,
    required this.lugar,
    required this.inicio,
    required this.salida,
    required this.monto,
    required this.motivo,
  });
}

class ReservaDB {
  final String codigoReserva;
  final DateTime horarioInicio;
  final DateTime horarioSalida;
  final double monto;
  final String estadoReserva;
  final String chapaAuto;

  ReservaDB({
    required this.codigoReserva,
    required this.horarioInicio,
    required this.horarioSalida,
    required this.monto,
    required this.estadoReserva,
    required this.chapaAuto,
  });

  factory ReservaDB.fromJson(Map<String, dynamic> json) {
    return ReservaDB(
      codigoReserva: json['codigoReserva'],
      horarioInicio: DateTime.parse(json['horarioInicio']),
      horarioSalida: DateTime.parse(json['horarioSalida']),
      monto: json['monto'].toDouble(),
      estadoReserva: json['estadoReserva'],
      chapaAuto: json['chapaAuto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoReserva': codigoReserva,
      'horarioInicio': horarioInicio.toIso8601String(),
      'horarioSalida': horarioSalida.toIso8601String(),
      'monto': monto,
      'estadoReserva': estadoReserva,
      'chapaAuto': chapaAuto,
    };
  }
}

class ReservaController extends GetxController {
  final db = LocalDBService();

  // Observables
  RxList<Piso> pisos = <Piso>[].obs;
  Rx<Piso?> pisoSeleccionado = Rx<Piso?>(null);
  RxList<Lugar> lugaresDisponibles = <Lugar>[].obs;
  Rx<Lugar?> lugarSeleccionado = Rx<Lugar?>(null);
  Rx<DateTime?> horarioInicio = Rx<DateTime?>(null);
  Rx<DateTime?> horarioSalida = Rx<DateTime?>(null);
  RxInt duracionSeleccionada = 0.obs;
  RxList<Auto> autosCliente = <Auto>[].obs;
  Rx<Auto?> autoSeleccionado = Rx<Auto?>(null);
  final historialReservas = <Reservahistorial>[].obs;
  RxList<MotivoVisita> motivos = <MotivoVisita>[].obs;
  Rx<MotivoVisita?> motivoSeleccionado = Rx<MotivoVisita?>(null);

  String codigoClienteActual = 'cliente_1'; // Simulado por ahora

  @override
  void onInit() {
    super.onInit();
    resetearCampos();
    cargarAutosDelCliente();
    cargarPisosYLugares();
    cargarMotivos();
  }

  void resetearCampos() {
    pisoSeleccionado.value = null;
    lugarSeleccionado.value = null;
    horarioInicio.value = null;
    horarioSalida.value = null;
    duracionSeleccionada.value = 0;
    autoSeleccionado.value = null;
    motivoSeleccionado.value = null;
  }

  Future<void> cargarMotivos() async {
    try {
      final data = await rootBundle.loadString('assets/data/motivos.json');
      final List<dynamic> jsonResult = json.decode(data);
      motivos.value = jsonResult.map((e) => MotivoVisita.fromJson(e)).toList();
      print("Motivos cargados: ${motivos.length}");
    } catch (e) {
      print("Error al cargar motivos: $e");
    }
  }

  Future<void> cargarAutosDelCliente() async {
    final rawAutos = await db.getAll("autos.json");
    final autos = rawAutos.map((e) => Auto.fromJson(e)).toList();
    autosCliente.value =
        autos.where((a) => a.clienteId == codigoClienteActual).toList();
  }

  Future<void> cargarPisosYLugares() async {
    final rawPisos = await db.getAll("pisos.json");
    final rawLugares = await db.getAll("lugares.json");
    final rawReservas = await db.getAll("reservas.json");

    final reservas = rawReservas.map((e) => ReservaDB.fromJson(e)).toList();
    final lugaresReservados = reservas.map((r) => r.codigoReserva).toSet();

    final todosLugares = rawLugares.map((e) => Lugar.fromJson(e)).toList();

    pisos.value = rawPisos.map((pJson) {
      final codigoPiso = pJson['codigo'];
      final lugaresDelPiso =
          todosLugares.where((l) => l.codigoPiso == codigoPiso).toList();
      return Piso(
        codigo: codigoPiso,
        descripcion: pJson['descripcion'],
        lugares: lugaresDelPiso,
      );
    }).toList();

    lugaresDisponibles.value = todosLugares.where((l) {
      return !lugaresReservados.contains(l.codigoLugar);
    }).toList();
  }

  void seleccionarPiso(Piso piso) {
    pisoSeleccionado.value = piso;
    lugarSeleccionado.value = null;
    lugaresDisponibles.value = piso.lugares.where((lugar) {
      return lugar.estado != "RESERVADO";
    }).toList();
  }

  Future<bool> confirmarReserva() async {
    if (pisoSeleccionado.value == null ||
        lugarSeleccionado.value == null ||
        horarioInicio.value == null ||
        horarioSalida.value == null ||
        autoSeleccionado.value == null ||
        motivoSeleccionado.value == null) {
      return false;
    }

    final duracionEnHoras =
        horarioSalida.value!.difference(horarioInicio.value!).inMinutes / 60;
    if (duracionEnHoras <= 0) return false;

    final montoCalculado = (duracionEnHoras * 10000).round();

    final reserva = Reservahistorial(
      auto: autoSeleccionado.value!,
      piso: pisoSeleccionado.value!,
      lugar: lugarSeleccionado.value!,
      inicio: horarioInicio.value!,
      salida: horarioSalida.value!,
      monto: montoCalculado,
      motivo: motivoSeleccionado.value!,
    );

    historialReservas.add(reserva);

    final nuevaReservaDB = ReservaDB(
      codigoReserva: "RES-${DateTime.now().millisecondsSinceEpoch}",
      horarioInicio: reserva.inicio,
      horarioSalida: reserva.salida,
      monto: reserva.monto.toDouble(),
      estadoReserva: "PENDIENTE",
      chapaAuto: reserva.auto.chapa,
    );

    try {
      final reservas = await db.getAll("reservas.json");
      reservas.add(nuevaReservaDB.toJson());
      await db.saveAll("reservas.json", reservas);

      final lugares = await db.getAll("lugares.json");
      final index = lugares.indexWhere(
        (l) => l['codigoLugar'] == lugarSeleccionado.value!.codigoLugar,
      );
      if (index != -1) {
        lugares[index]['estado'] = "RESERVADO";
        await db.saveAll("lugares.json", lugares);
      }

      return true;
    } catch (e) {
      print("Error al guardar reserva: $e");
      return false;
    }
  }

  @override
  void onClose() {
    resetearCampos();
    super.onClose();
  }
}
