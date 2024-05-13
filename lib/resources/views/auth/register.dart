import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/config/app.dart';
import 'package:todolist_flutter/resources/views/auth/login.dart';
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
		final size = MediaQuery.of(context).size;

		return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                body: SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.only(left: 20, right: 20, top: size.height * 0.08, bottom: size.height * 0.06),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Image(image: AssetImage(logoApp), width: 80, height: 80,),
                                            ],
                                        ),
                                        
                                        const SizedBox(height: 40),

                                        Text(Location.of(context)!.trans('register'), style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w100)),

                                        const SizedBox(height: 10),

                                        TextFormField(
                                            controller: _usernameController,
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('userName')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Por favor ingresa tu nombre';
                                                }
                                                return null;
                                            },
                                        ),

                                        const SizedBox(height: 10),

                                        Row(
                                            children: [
                                                Expanded(
                                                    child: TextFormField(
                                                        controller: _firstnameController,
                                                        decoration: inputDecoration(labelText: Location.of(context)!.trans('firstName')),
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
                                                        decoration: inputDecoration(labelText: Location.of(context)!.trans('lastName')),
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

                                        const SizedBox(height: 10),

                                        TextFormField(
                                            controller: _emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('email')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Por favor ingresa tu correo electrónico';
                                                }
                                                // Aquí puedes agregar más validaciones para el correo electrónico
                                                return null;
                                            },
                                        ),

                                        const SizedBox(height: 10),

                                        TextFormField(
                                            controller: _passwordController,
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('password')),
                                            obscureText: true,
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Por favor ingresa tu contraseña';
                                                }
                                                // Aquí puedes agregar más validaciones para la contraseña
                                                return null;
                                            },
                                        ),
                                        const SizedBox(height: 10),

                                        TextFormField(
                                            controller: _confirmPasswordController,
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('confirmPassword')),
                                            obscureText: true,
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Por favor ingresa tu contraseña';
                                                }
                                                // Aquí puedes agregar más validaciones para la contraseña
                                                return null;
                                            },
                                        ),

                                        const SizedBox(height: 40),

                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(Theme.of(context).colorScheme.primary.value),
                                                padding: const EdgeInsets.all(13),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            ),
                                            child: Center(
                                                child: Text(Location.of(context)!.trans('register'), style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Sofia",
                                                    color: Color(Theme.of(context).colorScheme.onPrimary.value),
                                                    fontSize: 18.0
                                                ))
                                            ),
                                            onPressed: () {
                                                if (_formKey.currentState!.validate()) {
                                                    _formKey.currentState!.save();

                                                    register(context);
                                                }
                                            },
                                        ),
                                    ],
                                ),
                                const SizedBox(height: 40),
                                Column(
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                InkWell(
                                                    onTap: () {
                                                        Navigator.pushAndRemoveUntil(
                                                            context, 
                                                            MaterialPageRoute(builder: (context) => const AuthLogin()), 
                                                            (route) => false
                                                        );
                                                    },
                                                    child: Text(Location.of(context)!.trans('login'), style: const TextStyle(fontFamily: 'Sofia'))
                                                )
                                            ],
                                        )
                                    ],
                                )
                            ],
                        )       
                    ),
                ),
            ),
        );
  	}

    void register(context) async {
        Map<String, String> data = {
            'type': 'users',
            'username': _usernameController.text,
            'first_name': _firstnameController.text,
            'last_name': _lastnameController.text,
            'email': _emailController.text,
            'password': _passwordController.text,
            'password_confirmation': _confirmPasswordController.text,
        };

        var registerResponse = await AuthService().register(data: data);

        if (registerResponse) {
            Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const AuthLogin()), 
                (route) => false
            );
        } else {
            getScafoldMessage(context, 'Error al registrar');
        }
    }
}

InputDecoration inputDecoration({required String labelText}){
    return InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.transparent)
        ),
    );
}