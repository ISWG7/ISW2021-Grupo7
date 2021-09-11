import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:tp_isw/entities/PedidoAnyEntity.dart';
import 'package:tp_isw/entities/TarjetaCreditoEntity.dart';
import 'package:tp_isw/helpers/PedidoAnyController.dart';

class FormTarjeta extends StatefulWidget {
  final PedidoAnyController controller;
  final PedidoAnyEntity entity;

  const FormTarjeta({Key? key, required this.controller, required this.entity})
      : super(key: key);

  @override
  _FormTarjetaState createState() => _FormTarjetaState();
}

class _FormTarjetaState extends State<FormTarjeta> {
  late String cardNumber;
  late String expiryDate;
  late String cardHolderName;
  late String cvvCode;
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //TODO SEGUIR ACA
  @override
  void initState() {
    super.initState();

    widget.controller.validate = validate;
    widget.controller.save = save;

    llenarCampos();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardGraf = CreditCardWidget(
      labelCardHolder: "Nombre en la Tarjeta",
      obscureCardNumber: false,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      showBackView: isCvvFocused,
    );

    Widget cardForm = CreditCardForm(
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardHolderName: cardHolderName,
      cvvCode: cvvCode,
      onCreditCardModelChange: onCreditCardModelChange,
      themeColor: Colors.blue,
      formKey: formKey,
      numberValidationMessage: "Ingrese un numero valido",
      cvvValidationMessage: "Ingrese un CVV",
      dateValidationMessage: "Ingrese una fecha valida",
      cardNumberDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Numero de Tarjeta',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      expiryDateDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Fecha Expiracion',
        hintText: 'XX/XX',
      ),
      cvvCodeDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'CVV',
        hintText: 'XXX',
      ),
      cardHolderDecoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'NOMBRE EN LA TARJETA',
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return (constraints.maxWidth < 600)
            ? Container(
                height: constraints.maxHeight,
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      flex: 3,
                      child: cardGraf,
                    ),
                    Flexible(
                      flex: 2,
                      child: Scrollbar(
                          child: SingleChildScrollView(child: cardForm)),
                    )
                  ],
                ),
              )
            : Row(
                children: [
                  SizedBox(width: constraints.maxWidth / 2, child: cardGraf),
                  SizedBox(width: constraints.maxWidth / 2, child: cardForm)
                ],
              );
      },
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  bool validate() {
    if (detectCCType(cardNumber) == CardType.visa) {
      return formKey.currentState!.validate();
    }
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error Tipo Tarjeta"),
            content:
                Text("Por el Momento la unica tarjeta que aceptamos es Visa"),
          );
        },
        context: context);
    return false;
  }

  void save() {
    widget.entity.medioPago = "Tarjeta";
    widget.entity.tarjeta =
        TarjetaCreditoEntity(cardNumber, expiryDate, cardHolderName, cvvCode);
  }

  void llenarCampos() {
    if (widget.entity.medioPago == "Tarjeta") {
      var tarjeta = widget.entity.tarjeta!;
      cardNumber = tarjeta.numero;
      expiryDate = tarjeta.expiracion;
      cardHolderName = tarjeta.nombre;
      cvvCode = tarjeta.cvv;
    } else {
      cvvCode = "";
      expiryDate = "";
      cardHolderName = "";
      cardNumber = "";
    }
  }


  // ================= INFERNAL MAMBO PARA SACAR EL TIPO DE TARJETA =================
  //  NO ME ENORGULLESCO DE ESTO , PERO YA PASARON DEMASIADAS HORAS
  // este MISMO  codigo esta dentor del CreditCardWidget y lo usa para sacar el dibujito

  Map<CardType, Set<List<String>>> cardNumPatterns =
  <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;

    if (cardNumber.isEmpty) {
      return cardType;
    }



    cardNumPatterns.forEach(
          (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
          cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }

          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

}
