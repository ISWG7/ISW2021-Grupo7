import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';

class HoraEntrega extends StatefulWidget {
  final PedidoAnyEntity entity;
  final PedidoAnyController controller;

  const HoraEntrega({
    Key? key,
    required this.entity,
    required this.controller,
  }) : super(key: key);

  @override
  _HoraEntregaState createState() => _HoraEntregaState();
}

class _HoraEntregaState extends State<HoraEntrega> {
  //Para la hora
  late TimeOfDay _time;
  late TimeOfDay _actual;
  //Para el dia
  late DateTime ultimoDiaSeleccionable;
  late DateTime primerDiaSeleccionable;
  late DateTime diaSeleccionado;

  // Programo o no la entrega
  bool? programarEntrega;

  @override
  void initState() {
    super.initState();

    widget.controller.validate = validate;
    widget.controller.save = save;

    _actual = TimeOfDay.now();
    _time = _actual.replacing(hour: _actual.hour + 1, minute: 0);
    var now = DateTime.now();
    ultimoDiaSeleccionable = DateTime(now.year, now.month, now.day + 7);
    primerDiaSeleccionable = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final colorSeleccionado = Color(0xFF6F2DBD);
    final colorNoSeleccionado = Color(0xFFB298DC);
    Widget entregarAhora = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: (programarEntrega == null)
              ? colorNoSeleccionado
              : (programarEntrega!)
                  ? colorNoSeleccionado
                  : colorSeleccionado),
      icon: Icon(Icons.whatshot_rounded),
      label: Text("Entregar Ahora"),
      onPressed: () => this.setState(() {
        programarEntrega = false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Seleccionada entrega Inmediata")));
      }),
    );

    Widget programarEntregaBtn = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          primary: (programarEntrega == null)
              ? colorNoSeleccionado
              : (programarEntrega!)
                  ? colorSeleccionado
                  : colorNoSeleccionado),
      icon: Icon(Icons.calendar_today_sharp),
      label: Text("Programar la entrega"),
      onPressed: () async {
        DateTime? newDateTime = await showRoundedDatePicker(
            context: context,
            // locale: Locale('es', 'ARG'),
            firstDate: primerDiaSeleccionable,
            lastDate: ultimoDiaSeleccionable,
            textPositiveButton: "Aceptar",
            textNegativeButton: "Cancelar",
            theme: ThemeData(primaryColor: Color(0xFFA663CC), accentColor:Color(0xFFB9FAF8) ),
            //TODO
            // imageHeader: AssetImage("assets/images/calendar_header.jpg"),
            description: "Elige un dia para que realizemos la entrega."
                " Recuerda que la fecha maxima para progamar una entrega son 7 dias");

        if (newDateTime != null) {
          setState(() {
            diaSeleccionado = newDateTime;
          });

          showHoraPicker(context);
        }
      },
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 36),
          child: Text(
            " ¿Cuando hacemos la entrega ? ",
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: entregarAhora,
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: programarEntregaBtn,
        ),
      ],
    );
  }

  void showHoraPicker(BuildContext context) {
    Navigator.of(context).push(
      showPicker(
        value: _time,
        iosStylePicker: false,
        minuteInterval: MinuteInterval.TEN,
        is24HrFormat: true,
        // Mucho cuento, solo para que la hora sea una mas la actual
        minHour: (_actual.hour.floorToDouble() < 23.0)
            ? _actual.hour.floorToDouble() + 1.0
            : double.infinity,
        onChange: (newTime) {
          this.setState(() {
            _time = newTime;
            programarEntrega = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Programada entrega para el ${diaSeleccionado.day}/${diaSeleccionado.month}"
                  " a las ${_time.hour} : ${_time.minute}"),
            ),
          );
        },
      ),
    );
  }

  void save() {
    if (programarEntrega!) {
      widget.entity.horarioEntrega = _time.toString();
      widget.entity.fechaEntrega = diaSeleccionado.toString();
      widget.entity.entregaProgramada = true;
    } else {
      widget.entity.entregaProgramada = false;
    }
  }

  bool validate() {
    if (programarEntrega == null) {
      showDialog(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Debe seleccionar una forma de entrega"),
              content: Text(
                  "Por favor seleccione una de las formas de entrega antes de continuar"),
            );
          },
          context: context);
      return false;
    }
    return true;
  }
}
