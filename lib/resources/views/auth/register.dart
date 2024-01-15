import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';

class AuthRegister extends StatefulWidget {
  	const AuthRegister({super.key});

  	@override
  	State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
	final _formKey = GlobalKey<FormState>();

	final TextEditingController _nameController = TextEditingController();
	final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();
	final TextEditingController _confirmPasswordController = TextEditingController();

  	@override
  	Widget build(BuildContext context) {
		final sizeWith = MediaQuery.of(context).size.width;

		return Scaffold(
			appBar: AppBar(
				title: const Text('Registro'),
			),
			body: Center(
                child: Container(
					constraints: const BoxConstraints(maxWidth: 400),
                    child: Stack(
                        children: [
                            SingleChildScrollView(
                                padding: EdgeInsets.only(top: sizeWith * 0.05, bottom: 0, left: 20, right: 20),
                                child: Form(
                                    key: _formKey,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    Image(
                                                        image: AssetImage('lib/assets/images/wisus-logo.png'), 
                                                        width: 80,
                                                        height: 80,
                                                    ),
                                                ],
                                            ),

                                            const SizedBox(height: 20),

                                            //const Text('Registro', style: TextStyle(fontFamily: 'bool', fontSize: 22, fontWeight: FontWeight.bold)),

                                            const SizedBox(height: 20),

                                            TextFormField(
                                                controller: _nameController,
                                                decoration: InputDecoration(
                                                    labelText: Location.of(context)!.trans('name'), 
                                                    prefixIcon: const Icon(Icons.person_outline),
                                                    border: const OutlineInputBorder(),
                                                ),
                                                validator: (value) {
                                                    if (value!.isEmpty) {
                                                        return 'Por favor ingresa tu nombre';
                                                    }
                                                    // Aquí puedes agregar más validaciones para el nombre
                                                    return null;
                                                },
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                                controller: _emailController,
                                                decoration: InputDecoration(
                                                    labelText: Location.of(context)!.trans('email'), 
                                                    prefixIcon: const Icon(Icons.email_outlined),
                                                    border: const OutlineInputBorder(),
                                                ),
                                                validator: (value) {
                                                    if (value!.isEmpty) {
                                                        return 'Por favor ingresa tu correo electrónico';
                                                    }
                                                    // Aquí puedes agregar más validaciones para el correo electrónico
                                                    return null;
                                                },
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                                controller: _passwordController,
                                                decoration: InputDecoration(
                                                    labelText: Location.of(context)!.trans('password'),  
                                                    prefixIcon: const Icon(Icons.lock_outline),
                                                    border: const OutlineInputBorder(),
                                                ),
                                                obscureText: true,
                                                validator: (value) {
                                                    if (value!.isEmpty) {
                                                        return 'Por favor ingresa tu contraseña';
                                                    }
                                                    // Aquí puedes agregar más validaciones para la contraseña
                                                    return null;
                                                },
                                            ),
                                            const SizedBox(height: 20),
                                            TextFormField(
                                                controller: _confirmPasswordController,
                                                decoration: InputDecoration(
                                                    labelText: Location.of(context)!.trans('confirm_password'),  
                                                    prefixIcon: const Icon(Icons.lock_outline),
                                                    border: const OutlineInputBorder(),
                                                ),
                                                obscureText: true,
                                                validator: (value) {
                                                    if (value!.isEmpty) {
                                                        return 'Por favor ingresa tu contraseña';
                                                    }
                                                    // Aquí puedes agregar más validaciones para la contraseña
                                                    return null;
                                                },
                                            ),
                                            
                                            const SizedBox(height: 30),

                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                                    foregroundColor: Theme.of(context).colorScheme.primary,
                                                    minimumSize: const Size(double.infinity, 50),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20)
                                                    )
                                                ),
                                                onPressed: (){
                                                    if (_formKey.currentState!.validate()) {
                                                        _formKey.currentState!.save();

                                                        print('El nombre es: ${_nameController.text}');
                                                        print('El correo electrónico es: ${_emailController.text}');
                                                        print('La contraseña es: ${_passwordController.text}');
                                                        print('La confirmación de la contraseña es: ${_confirmPasswordController.text}');

                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text('Procesando datos...'))
                                                        );
                                                    }
                                                }, 
                                                child: Text(Location.of(context)!.trans('sign_up'))
                                            ),
                                        ],
                                    ),
                                ),
                            ),

                            Positioned(
                                child: Container(
                                    padding: EdgeInsets.only(top: sizeWith * 1.70),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text(Location.of(context)!.trans('already_have_an_account')),
                                            TextButton(
                                                child: Text(Location.of(context)!.trans('sign_in')),
                                                onPressed: () {
                                                    Navigator.pushNamed(context, 'login');
                                                },
                                            ),
                                        ],
                                    ),
                                )
                            )
                        ],
                    ),
                ),
            ),
		);
  	}
}