import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class FormTarjeta extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const FormTarjeta({Key? key, required this.formKey}) : super(key: key);

  @override
  _FormTarjetaState createState() => _FormTarjetaState();
}

class _FormTarjetaState extends State<FormTarjeta>{
  late String cardNumber ;
  late String expiryDate ;
  late String cardHolderName ;
  late String cvvCode ;
  bool isCvvFocused = false;

  //TODO SEGUIR ACA
  @override
  void initState() {
    cardNumber = '';
    expiryDate = "";
    cardHolderName = "";
    cvvCode = "";
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 3,
          child: CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused),
        ),
        Flexible(flex: 2,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    onCreditCardModelChange: onCreditCardModelChange,
                    themeColor: Colors.blue,
                    formKey: widget.formKey,
                    cardNumberDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Numero de Tarjeta',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fecha Expiracion',
                      hintText: 'XX/XX',
                    ),
                    cvvCodeDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nombre en la Tarjeta',
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
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


}
