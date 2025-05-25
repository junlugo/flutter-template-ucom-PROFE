import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:finpay/controller/reserva_controller.dart';
import 'package:finpay/model/sitema_reservas.dart';
import 'package:finpay/utils/utiles.dart';

class ReservaScreen extends StatelessWidget {
  final controller = Get.put(ReservaController());

  ReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reservar lugar")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Seleccione el horario", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (date == null) return;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) return;
                          controller.horarioInicio.value = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        },
                        icon: const Icon(Icons.access_time),
                        label: Obx(() => Text(
                              controller.horarioInicio.value == null
                                  ? "Inicio"
                                  : "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioInicio.value!)} ${TimeOfDay.fromDateTime(controller.horarioInicio.value!).format(context)}",
                            )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: controller.horarioInicio.value ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (date == null) return;
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time == null) return;
                          controller.horarioSalida.value = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        },
                        icon: const Icon(Icons.timer_off),
                        label: Obx(() => Text(
                              controller.horarioSalida.value == null
                                  ? "Salida"
                                  : "${UtilesApp.formatearFechaDdMMAaaa(controller.horarioSalida.value!)} ${TimeOfDay.fromDateTime(controller.horarioSalida.value!).format(context)}",
                            )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Duración estimada", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [1, 2, 4, 6, 8].map((horas) {
                    final seleccionada = controller.duracionSeleccionada.value == horas;
                    return ChoiceChip(
                      label: Text("$horas h"),
                      selected: seleccionada,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      onSelected: (_) {
                        controller.duracionSeleccionada.value = horas;
                        final inicio = controller.horarioInicio.value ?? DateTime.now();
                        controller.horarioInicio.value = inicio;
                        controller.horarioSalida.value = inicio.add(Duration(hours: horas));
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text("Seleccione su auto", style: TextStyle(fontWeight: FontWeight.bold)),
                Obx(() {
                  return Wrap(
                    spacing: 8.0,
                    children: controller.autosCliente.map((auto) {
                      final seleccionado = controller.autoSeleccionado.value?.chapa == auto.chapa;
                      return ChoiceChip(
                        key: ValueKey(auto.chapa),
                        label: Text(
                          "${auto.chapa} - ${auto.marca} ${auto.modelo}",
                          style: TextStyle(
                            color: seleccionado ? Colors.white : const Color.fromARGB(255, 24, 201, 255),
                          ),
                        ),
                        selected: seleccionado,
                        onSelected: (val) {
                          if (val) controller.autoSeleccionado.value = auto;
                        },
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
                const Text("Seleccione el piso", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() {
                  return Wrap(
                    spacing: 8.0,
                    children: controller.pisos.map((piso) {
                      final seleccionado = controller.pisoSeleccionado.value?.codigo == piso.codigo;
                      return ChoiceChip(
                        key: ValueKey(piso.codigo),
                        label: Text(
                          piso.descripcion,
                          style: TextStyle(
                            color: seleccionado ? Colors.white : const Color.fromARGB(255, 24, 201, 255),
                          ),
                        ),
                        selected: seleccionado,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        onSelected: (val) {
                          if (val) controller.seleccionarPiso(piso);
                        },
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
                const Text("Seleccione el lugar disponible", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.lugaresDisponibles
                        .where((l) => l.codigoPiso == controller.pisoSeleccionado.value?.codigo)
                        .map((lugar) {
                      final seleccionado = lugar == controller.lugarSeleccionado.value;
                      final color = lugar.estado == "RESERVADO"
                          ? Colors.red
                          : seleccionado
                              ? Colors.green
                              : Colors.grey.shade300;
                      return GestureDetector(
                        onTap: lugar.estado == "DISPONIBLE"
                            ? () => controller.lugarSeleccionado.value = lugar
                            : null,
                        child: Container(
                          width: 60,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color,
                            border: Border.all(
                              color: seleccionado ? Colors.green.shade700 : Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lugar.codigoLugar,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: lugar.estado == "reservado" ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
                const Text("Motivo de la visita", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Obx(() {
                  return Wrap(
                    spacing: 8.0,
                    children: controller.motivos.map((motivo) {
                      final seleccionado = controller.motivoSeleccionado.value?.codigo == motivo.codigo;
                      return ChoiceChip(
                        key: ValueKey(motivo.codigo),
                        label: Text(
                          motivo.descripcion,
                          style: TextStyle(
                            color: seleccionado ? Colors.white : const Color.fromARGB(255, 24, 201, 255),
                          ),
                        ),
                        selected: seleccionado,
                        selectedColor: Theme.of(context).colorScheme.primary,
                        onSelected: (_) {
                          controller.motivoSeleccionado.value = motivo;
                        },
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 16),
                Obx(() {
                  final auto = controller.autoSeleccionado.value;
                  final piso = controller.pisoSeleccionado.value;
                  final lugar = controller.lugarSeleccionado.value;
                  final inicio = controller.horarioInicio.value;
                  final salida = controller.horarioSalida.value;
                  final motivo = controller.motivoSeleccionado.value;

                  if (auto == null || piso == null || lugar == null || inicio == null || salida == null || motivo == null) {
                    return const SizedBox();
                  }

                  final minutos = salida.difference(inicio).inMinutes;
                  final horas = minutos / 60;
                  final monto = (horas * 10000).round();

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Resumen de tu reserva", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                          Text("Auto: ${auto.marca} ${auto.modelo} - ${auto.chapa}"),
                          Text("Piso: ${piso.descripcion}"),
                          Text("Lugar: ${lugar.codigoLugar}"),
                          Text("Motivo: ${motivo.descripcion}"),
                          Text("Horario: ${UtilesApp.formatearFechaDdMMAaaa(inicio)} ${TimeOfDay.fromDateTime(inicio).format(context)} - ${UtilesApp.formatearFechaDdMMAaaa(salida)} ${TimeOfDay.fromDateTime(salida).format(context)}"),
                          Text("Monto estimado: ₲${UtilesApp.formatearGuaranies(monto)}"),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final confirmada = await controller.confirmarReserva();

                      if (confirmada) {
                        Get.snackbar("Reserva", "Reserva realizada con éxito.", snackPosition: SnackPosition.BOTTOM);

                        await Future.delayed(const Duration(milliseconds: 2000));
                        final minutos = controller.horarioSalida.value!.difference(controller.horarioInicio.value!).inMinutes;
                        final horas = minutos / 60;
                        final monto = (horas * 10000).round();

                        controller.historialReservas.add(Reservahistorial(
                          auto: controller.autoSeleccionado.value!,
                          piso: controller.pisoSeleccionado.value!,
                          lugar: controller.lugarSeleccionado.value!,
                          inicio: controller.horarioInicio.value!,
                          salida: controller.horarioSalida.value!,
                          monto: monto,
                          motivo: controller.motivoSeleccionado.value!,
                        ));

                        Get.back();
                      } else {
                        Get.snackbar(
                          "Error",
                          "Verificá que todos los campos estén completos",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red.shade100,
                          colorText: Colors.red.shade900,
                        );
                      }
                    },
                    child: const Text(
                      "Confirmar Reserva",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
