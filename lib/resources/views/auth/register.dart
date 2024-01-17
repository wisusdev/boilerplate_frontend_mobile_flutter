import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/resources/widgets/snack_bar.dart';

class AuthRegister extends StatefulWidget {
  	const AuthRegister({super.key});

  	@override
  	State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
	final _formKey = GlobalKey<FormState>();

    final TextEditingController _usernameController = TextEditingController();
	final TextEditingController _firstnameController = TextEditingController();
	final TextEditingController _lastnameController = TextEditingController();
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
                                                controller: _usernameController,
                                                decoration: InputDecoration(
                                                    labelText: Location.of(context)!.trans('username'), 
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

                                            Row(
                                                children: [
                                                    Expanded(
                                                        child: TextFormField(
                                                            controller: _firstnameController,
                                                            decoration: InputDecoration(
                                                                labelText: Location.of(context)!.trans('firstName'), 
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
                                                    ),

                                                    const SizedBox(width: 10),

                                                    Expanded(
                                                        child: TextFormField(
                                                            controller: _lastnameController,
                                                            decoration: InputDecoration(
                                                                labelText: Location.of(context)!.trans('lastName'), 
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
                                                    )
                                                ],
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

                                            Row(
                                                children: [
                                                    Expanded(
                                                        child: TextFormField(
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
                                                    ), 

                                                    const SizedBox(width: 10),

                                                    Expanded(
                                                        child: TextFormField(
                                                            controller: _confirmPasswordController,
                                                            decoration: InputDecoration(
                                                                labelText: Location.of(context)!.trans('confirmPassword'),  
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
                                                    ),
                                                ],
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

                                                        register(context);

                                                        getScafoldMessage(context, 'Procesando registro...');
                                                    }
                                                }, 
                                                child: Text(Location.of(context)!.trans('signUp'))
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
                                            Text(Location.of(context)!.trans('alreadyHaveAnAccount')),
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

    void register(context) async {
        Map<String, String> data = {
            'username': _usernameController.text,
            'first_name': _firstnameController.text,
            'last_name': _lastnameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'password_confirmation': _confirmPasswordController.text,
        };

        var response = await AuthService().register(data);

        if (response['status']) {
            if (!mounted) return;
            getScafoldMessage(context, 'Registro exitoso', backgroundColor: Colors.green);
            Navigator.pushNamed(context, 'login');
        } else {
            getScafoldMessage(context, response);
        }
    }
}