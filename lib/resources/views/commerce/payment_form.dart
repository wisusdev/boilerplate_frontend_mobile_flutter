import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
    const PaymentForm({Key? key}) : super(key: key);

    @override
    State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Formulario de pago'),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(width: 1, color: Colors.grey.shade300)
                                )
                            ),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(10, (index) => Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                                const Icon(Icons.add, color: Colors.green),
                                                const SizedBox(width: 5,),
                                                Text('Item ${index + 1} '),
                                                const Spacer(),
                                                const Text('\$100.00'),
                                            ],
                                        ),
                                    ],
                                )),
                            ),
                        ),

                        const SizedBox(height: 20),

                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Grand Total'),
                                Text('\$ 1179.00'),
                            ],
                        ),

                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Taxes & Fees'),
                                Text('\$ 5.00'),
                            ],
                        ),

                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Delivery Charges'),
                                Text('\$ 00.00'),
                            ],
                        ),
                        
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Discount'),
                                Text('\$ 234.00'),
                            ],
                        ),

                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Wallet Discount'),
                                Text('NA'),
                            ],
                        ),
                        const SizedBox(height: 10),

                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('\$ 950.00', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                        ),
                        
                        const SizedBox(height: 30),

                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                foregroundColor: Theme.of(context).colorScheme.primary,
                                minimumSize: const Size.fromHeight(45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                ),
                            ),
                            onPressed: () {
                                showModalBottomSheetPayment(context);
                            },
                            child: const Text('Siguiente'),
                        ),
                    ],
                ),
            ),
        );
    }
}

void showModalBottomSheetPayment(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    final _cardNumberController = TextEditingController();
    final _cardHolderController = TextEditingController();
    final _expirationMonthController = TextEditingController();
    final _expirationYearController = TextEditingController();
    final _cvvController = TextEditingController();

    @override
    void dispose() {
        _cardNumberController.dispose();
        _cardHolderController.dispose();
        _expirationMonthController.dispose();
        _expirationYearController.dispose();
        _cvvController.dispose();
    }
    
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
            return SafeArea(
                child: Container(
                    padding: const EdgeInsets.all(15),
                    child: ListView(
                        children: [

                            Form(
                                key: _formKey,
                                child: Column(
                                    children: [

                                        TextFormField(
                                            controller: _cardHolderController,
                                            decoration: const InputDecoration(
                                                labelText: 'Nombre del propietario',
                                            ),
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return 'Por favor, ingresa el nombre del propietario';
                                                }
                                                return null;
                                            },
                                        ),

                                        TextFormField(
                                            controller: _cardNumberController,
                                            decoration: const InputDecoration(
                                                labelText: 'Número de tarjeta',
                                            ),
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return 'Por favor, ingresa el número de tarjeta';
                                                }
                                                return null;
                                            },
                                        ),

                                        Row(
                                            children: [
                                                Expanded(
                                                    child: TextFormField(
                                                        controller: _expirationMonthController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Mes de expiración',
                                                        ),
                                                        validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                                return 'Por favor, ingresa el mes de expiración';
                                                            }
                                                            return null;
                                                        },
                                                    ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    child: TextFormField(
                                                        controller: _expirationYearController,
                                                        decoration: const InputDecoration(
                                                            labelText: 'Año de expiración',
                                                        ),
                                                        validator: (value) {
                                                            if (value == null || value.isEmpty) {
                                                                return 'Por favor, ingresa el año de expiración';
                                                            }
                                                            return null;
                                                        },
                                                    ),
                                                ),
                                            ],
                                        ),
                                        TextFormField(
                                            controller: _cvvController,
                                            decoration: const InputDecoration(
                                                labelText: 'Código secreto',
                                            ),
                                            validator: (value) {
                                                if (value == null || value.isEmpty) {
                                                    return 'Por favor, ingresa el código secreto';
                                                }
                                                return null;
                                            },
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                                if (_formKey.currentState!.validate()) {
                                                    // Realizar la lógica de envío del formulario
                                                    // Aquí puedes acceder a los valores de los campos:
                                                    // _cardNumberController.text
                                                    // _cardHolderController.text
                                                    // _expirationMonthController.text
                                                    // _expirationYearController.text
                                                    // _cvvController.text
                                                }
                                            },
                                            child: const Text('Enviar'),
                                        ),
                                    ],
                                ),
                            ),
                        ],
                    ),
                ),
            );
        },
    );
}
