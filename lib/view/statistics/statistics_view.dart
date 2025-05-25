import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/controller/reserva_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final homeController = Get.put(HomeController());
  final reservaController = Get.find<ReservaController>(); // Asegúrate de inicializarlo en otro lugar

  @override
  void initState() {
    homeController.customInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!).withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros de días y botones como en tu código original...
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Historial de Reservas", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  /*Obx(() {
                    final historial = reservaController.historialReservas;
                    if (historial.isEmpty) {
                      return const Text("No hay reservas realizadas.");
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: historial.length,
                      itemBuilder: (context, index) {
                        final reserva = historial[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            title: Text(
                              "Auto: ${reserva.auto.chapa} - Piso: ${reserva.piso.descripcion}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,*/
                              Obx(() {
  final historial = reservaController.historialReservas;
  if (historial.isEmpty) {
    return const Center(child: Text("No hay reservas todavía."));
  }
  return ListView.builder(
    itemCount: historial.length,
    itemBuilder: (context, index) {
      final reserva = historial[index];
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text("Auto: ${reserva.auto}"),
                              Text("Piso: ${reserva.piso}"),
                                Text("Lugar: ${reserva.lugar.descripcionLugar}"),
                                Text("Inicio: ${reserva.inicio}"),
                                Text("Salida: ${reserva.salida}"),
                                Text("Monto: ${reserva.monto} Gs"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Lista de canchas original (opcional mantenerla o reemplazarla)
          ],
        ),
      ),
    );
  }
}


/*
import 'package:finpay/config/images.dart';
import 'package:finpay/config/textstyle.dart';
import 'package:finpay/controller/home_controller.dart';
import 'package:finpay/view/home/widget/transaction_list.dart';
import 'package:finpay/view/statistics/widget/card_view.dart';
import 'package:finpay/view/statistics/widget/circle_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({Key? key}) : super(key: key);

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final homeController = Get.put(HomeController());
  @override
  void initState() {
    homeController.customInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      color: AppTheme.isLightTheme == false
          ? HexColor('#15141f')
          : HexColor(AppTheme.primaryColorString!).withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Cerca mío", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  // Filtro de días
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (_, index) {
                        final now = DateTime.now().add(Duration(days: index));
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            children: [
                              Text(
                                ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'][now.weekday % 7],
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: index == 0 ? Colors.green : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${now.day.toString().padLeft(2, '0')} ${["ene", "feb", "mar", "abr", "may", "jun", "jul", "ago", "sep", "oct", "nov", "dic"][now.month - 1]}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: index == 0 ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Horario y duración
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Desde las 17:00"),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text("2 horas"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Lista de canchas
            Expanded(
              child: ListView.builder(
                itemCount: 2, // Puedes enlazar esto con tu controlador
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              'assets/images/cancha${index + 1}.jpg', // Reemplazar con tus imágenes reales
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index == 0 ? "Recoleta" : "Mburicao",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: const [
                                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Text("0.6 km - Asunción", style: TextStyle(fontSize: 12)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    for (var hour in ["17:00", "18:00", "22:00"])
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(hour),
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
}
}*/



/*            Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).textTheme.titleLarge!.color,
                    ),
                  ),
                  Text(
                    "Statistic",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const Icon(
                    Icons.arrow_back,
                    color: Colors.transparent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            homeController.isWeek.value == true
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Spending",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .color!
                                        .withOpacity(0.60),
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(children: [
                          Text(
                            "\$1,691.54",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "-3.1% from last month",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .color!
                                      .withOpacity(0.60),
                                ),
                          ),
                        ])
                      ],
                    ),
                  ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  cardView(
                    context,
                    homeController.isWeek.value == true
                        ? HexColor(AppTheme.primaryColorString!)
                        : AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffF9F9FA),
                    homeController.isWeek.value == true
                        ? Colors.white
                        : const Color(0xffA2A0A8),
                    () {
                      setState(() {
                        homeController.isWeek.value = true;
                        homeController.isMonth.value = false;
                        homeController.isYear.value = false;
                      });
                    },
                    "Week",
                  ),
                  cardView(
                    context,
                    homeController.isMonth.value == true
                        ? HexColor('#6C56F9')
                        : AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffF9F9FA),
                    homeController.isMonth.value == true
                        ? Colors.white
                        : const Color(0xffA2A0A8),
                    () {
                      setState(() {
                        homeController.isWeek.value = false;
                        homeController.isMonth.value = true;
                        homeController.isYear.value = false;
                      });
                    },
                    "Month",
                  ),
                  cardView(
                    context,
                    homeController.isYear.value == true
                        ? HexColor(AppTheme.primaryColorString!)
                        : AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffF9F9FA),
                    homeController.isYear.value == true
                        ? Colors.white
                        : const Color(0xffA2A0A8),
                    () {
                      setState(() {
                        homeController.isWeek.value = false;
                        homeController.isMonth.value = false;
                        homeController.isYear.value = true;
                      });
                    },
                    "Year",
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                children: [
                  const SizedBox(height: 20),
                  homeController.isWeek.value == true
                      ? Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: SvgPicture.asset(
                                AppTheme.isLightTheme == false
                                    ? DefaultImages.darkChart2
                                    : DefaultImages.chart2,
                                fit: BoxFit.fill,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 60,
                              width: Get.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ListView(
                                  physics: const ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "Food",
                                            HexColor(
                                                AppTheme.primaryColorString!),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "Bills",
                                            HexColor('#907FFA'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "Gadget",
                                            HexColor('#CCCACF'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 16),
                                          child: circleCard(
                                            context,
                                            "Food",
                                            HexColor(
                                                AppTheme.primaryColorString!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            height: 250,
                            child: SvgPicture.asset(
                              AppTheme.isLightTheme == false
                                  ? DefaultImages.darkChart1
                                  : DefaultImages.chart1,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.isLightTheme == false
                            ? const Color(0xff211F32)
                            : const Color(0xffFFFFFF),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withOpacity(0.10),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  homeController.isWeek.value == true
                                      ? "This Week"
                                      : homeController.isMonth.value == true
                                          ? "This Month"
                                          : "This Year",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                Text(
                                  "See all",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: HexColor(
                                              AppTheme.primaryColorString!)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              for (var i = 0;
                                  i < homeController.transactionList.length;
                                  i++)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: transactionList(
                                    homeController.transactionList[i].image,
                                    homeController
                                        .transactionList[i].background,
                                    homeController.transactionList[i].title,
                                    homeController.transactionList[i].subTitle,
                                    homeController.transactionList[i].price,
                                    homeController.transactionList[i].time,
                                  ),
                                )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/