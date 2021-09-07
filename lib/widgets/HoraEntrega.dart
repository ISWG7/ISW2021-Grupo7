import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';

class HoraEntrega extends StatefulWidget {
  const HoraEntrega({Key? key}) : super(key: key);

  @override
  _HoraEntregaState createState() => _HoraEntregaState();
}

class _HoraEntregaState extends State<HoraEntrega> {
  late TimeOfDay _time;
  late TimeOfDay _actual;

  @override
  void initState() {
    super.initState();
    // TODO PROBAR ESTO

    _actual = TimeOfDay.now();
    _time = _actual.replacing(hour: _actual.hour + 1, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                "Seleccione Horario de Entrega",
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            createInlinePicker(
                value: _time,
                iosStylePicker: false,
                minuteInterval: MinuteInterval.TEN,
                is24HrFormat: true,
                // Mucho cuento, solo para que la hora sea una mas la actual
                minHour: (_actual.hour.floorToDouble() < 23.0)
                    ? _actual.hour.floorToDouble() + 1.0
                    : double.infinity,
                onChange: (newTime) => this.setState(() {
                      _time = newTime;
                    })),
          ],
        ),
      ),
    );
  }
}
