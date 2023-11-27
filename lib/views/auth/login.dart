import 'package:flutter/material.dart';

class AuthLogin extends StatefulWidget {
	const AuthLogin({super.key});
	
	@override
  	State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  	final _formKey = GlobalKey<FormState>();
  
  	String _email = '';
  	String _password = '';

  	@override
  	Widget build(BuildContext context) {

        final registerLink = MediaQuery.of(context).size.width;

		return Scaffold(
	  		body: Stack(
                children: [
                    SingleChildScrollView(
                        padding: EdgeInsets.only(top: registerLink * 0.25, bottom: 0, left: 20, right: 20),
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
                            
                                    const SizedBox(height: 20),
                                                    
                                    const Text('Login', style: TextStyle(fontFamily: 'bool', fontSize: 22, fontWeight: FontWeight.bold)),
                                
                                    const SizedBox(height: 20),
                            
                                    TextFormField(
                                        decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined)),
                                        validator: (value) {
                                            if (value!.isEmpty) {
                                                return 'Por favor ingresa tu correo electrónico';
                                            }
                                            // Aquí puedes agregar más validaciones para el correo electrónico
                                            return null;
                                        },
                                        onSaved: (value) {
                                            _email = value!;
                                        },

                                    ),
                            
                                    const SizedBox(height: 20),
                                
                                    TextFormField(
                                        decoration: const InputDecoration(labelText: 'Contraseña',  prefixIcon: Icon(Icons.lock_outline)),
                                        obscureText: true,
                                        validator: (value) {
                                            if (value!.isEmpty) {
                                                return 'Por favor ingresa tu contraseña';
                                            }
                                            // Aquí puedes agregar más validaciones para la contraseña
                                            return null;
                                        },
                                        onSaved: (value) {
                                            _password = value!;
                                        },
                                    ),
                            
                                    const SizedBox(height: 30),
                                
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            InkWell(
                                                onTap: () {
                                                    print('Olvidaste tu contraseña');
                                                },
                                                child: const Text('¿Olvidaste tu contraseña?'),
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
                                                // Aquí puedes realizar la lógica de inicio de sesión
                                            }
                                            print('Iniciar Sesión');
                                        }, 
                                        child: Text('Iniciar Sesión', style: TextStyle(fontSize: 16))
                                    ),    

                                    const SizedBox(height: 10),
                                ],
                            ),
                        ),
                    ),
                    
                    Positioned(
                        child: Container(
                            padding: EdgeInsets.only(top: registerLink * 1.96),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    const Text('¿No tienes una cuenta? '),
                                    InkWell(
                                        onTap: () {
                                            print('Regístrate');
                                        },
                                        child: const Text('Regístrate', style: TextStyle(fontWeight: FontWeight.bold)),
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
