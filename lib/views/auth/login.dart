import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';

class AuthLogin extends StatefulWidget {
	const AuthLogin({super.key});
	
	@override
  	State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  	final _formKey = GlobalKey<FormState>();
  
    final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

  	@override
  	Widget build(BuildContext context) {

        final sizeWith = MediaQuery.of(context).size.width;

		return Scaffold(
            appBar: AppBar(
				title: const Text('Inicio de sesión'),
			),
	  		body: Stack(
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
                                                image: AssetImage('lib/assets/images/kyan.png'), 
                                                width: 80,
                                                height: 80,
                                            ),
                                        ],
                                    ),
                            
                                    //const SizedBox(height: 20),
                                                    
                                    //const Text('Login', style: TextStyle(fontFamily: 'bool', fontSize: 22, fontWeight: FontWeight.bold)),
                                
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
                                        }
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
                                        }
                                    ),
                            
                                    const SizedBox(height: 30),
                                
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            InkWell(
                                                onTap: () {
                                                    Navigator.pushNamed(context, 'forgot_password');
                                                },
                                                child: Text(Location.of(context)!.trans('forgot_your_pwd')),
                                            )
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
                                        onPressed: (){
                                            if (_formKey.currentState!.validate()) {
                                                _formKey.currentState!.save();
                                                
                                                print('Correo electrónico: ${_emailController.text}');
                                                print('Contraseña: ${_passwordController.text}');

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Procesando datos...'))
                                                );
                                            }
                                            print('Iniciar Sesión');
                                        }, 
                                        child: Text(Location.of(context)!.trans('sign_in'), style: const TextStyle(fontSize: 16))
                                    ),    

                                    const SizedBox(height: 10),
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
                                    Text(Location.of(context)!.trans('you_dont_have_an_account')),
                                    InkWell(
                                        onTap: () {
                                            Navigator.pushNamed(context, 'register');
                                        },
                                        child: Text(' ${Location.of(context)!.trans('sign_up')}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                ],
                            ),
                        )
                    )
                ]
            ),
		);
  	}
}
