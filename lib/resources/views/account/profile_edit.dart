import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/error_manager.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/http/controllers/account_controller.dart';

class ProfileEdit extends StatefulWidget {
    const ProfileEdit({super.key});

    @override
    State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
    final _formKey = GlobalKey<FormState>();

    final AccountController _accountController = AccountController();
    final TextEditingController _firstnameController = TextEditingController();
	final TextEditingController _lastnameController = TextEditingController();
	final TextEditingController _emailController = TextEditingController();
    final TextEditingController _avatarController = TextEditingController();
    final TextEditingController _languageController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    String _userKey = '';
    bool _isLoading = false;

    final ErrorManager errorManager = ErrorManager(initialErrors: {
        'first_name': null,
        'last_name': null,
        'email': null,
        'avatar': null,
        'language': null,
    });

    XFile? _imageFile;

    @override
    void initState() {
        super.initState();

        SharedPreferences.getInstance().then((prefs) {
            var userJson = prefs.getString('user');
            var userKey = prefs.getString('user_id');

            if (userJson != null) {
                var user = json.decode(userJson);
                setState(() {
                    _firstnameController.text = user['first_name'] ?? '';
                    _lastnameController.text = user['last_name'] ?? '';
                    _emailController.text = user['email'] ?? '';
                    _avatarController.text = user['avatar'] ?? '';
                    _languageController.text = user['language'] ?? '';
                    _userKey = userKey ?? '';
                });
            }
        });
    }

    Future<void> _pickImage() async {
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

        setState(() {
            _imageFile = pickedFile;
        });
    }

    @override
    Widget build(BuildContext context) {
        String userLanguageDropdownValue = _languageController.text.isEmpty ? 'es' : _languageController.text;

        return Scaffold(
            appBar: AppBar(
                leading: BackButton(
                    color: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                        Navigator.pop(context, 'update');
                    },
                ),
                title: Text(
                    capitalizeText('${Location.of(context)!.trans('edit')} ${Location.of(context)!.trans('profile')}'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            
            body: Stack(
                children: [
                    SingleChildScrollView(
                        child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        Row(
                                            children: [
                                                Expanded(
                                                    child: TextFormField(
                                                        controller: _firstnameController,
                                                        decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('firstName')),
                                                        validator: (value) {
                                                            if (value!.isEmpty) {
                                                                return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                            }
                    
                                                            if(errorManager.errors['first_name'] != null){
                                                                return errorManager.errors['first_name'];
                                                            }
                                                            
                                                            return null;
                                                        },
                                                    ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                    child: TextFormField(
                                                        controller: _lastnameController,
                                                        decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('lastName')),
                                                        validator: (value) {
                                                            if (value!.isEmpty) {
                                                                return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                            }
                    
                                                            if(errorManager.errors['last_name'] != null){
                                                                return errorManager.errors['last_name'];
                                                            }
                    
                                                            return null;
                                                        },
                                                    ),
                                                )
                                            ],
                                        ),
                    
                                        const SizedBox(height: 20),
                    
                                        TextFormField(
                                            controller: _emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('email')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                }
                    
                                                if(errorManager.errors['email'] != null){
                                                    return errorManager.errors['email'];
                                                }
                    
                                                return null;
                                            },
                                        ),
                    
                                        const SizedBox(height: 20),
                    
                                        InputDecorator(
                                            decoration: inputDecorationStyle(labelText: Location.of(context)!.trans('language')),
                                            child: DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                value: userLanguageDropdownValue,
                                                isDense: true,
                                                onChanged: (String? value) {
                                                    setState(() {
                                                    userLanguageDropdownValue = value!;
                                                    _languageController.text = value;
                                                    });
                                                },
                                                items: <String>['es', 'en']
                                                    .map<DropdownMenuItem<String>>((String value) {
                                                    return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(Location.of(context)!.trans(value)),
                                                    );
                                                    })
                                                    .toList(),
                                                ),
                                            ),
                                        ),
                    
                                        const SizedBox(height: 20),
                                        
                                        ElevatedButton(
                                            onPressed: _pickImage,
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                    const Icon(Icons.camera_alt),
                                                    const SizedBox(width: 10),
                                                    Text(Location.of(context)!.trans('selectAPicture')),
                                                ],
                                            ),
                                        ),

                                        _imageFile != null ? const SizedBox(height: 20) : Container(),

                                        Center(
                                            child: _imageFile != null ? Container(
                                                height: 200,
                                                width: 200,
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3), borderRadius: BorderRadius.circular(10)),
                                                child: Image.file(File(_imageFile!.path)),
                                            ) : Container(),
                                        ),

                                        const SizedBox(height: 40),
                    
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                                padding: const EdgeInsets.all(13),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            ),
                                            child: Center(
                                                child: Text(Location.of(context)!.trans('save'), style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Sofia",
                                                    color: Theme.of(context).colorScheme.onPrimary,
                                                    fontSize: 18.0
                                                ))
                                            ),
                                            onPressed: () {
                                                resetErrorMessages();
                                                if (_formKey.currentState!.validate()) {
                                                    setState(() {
                                                        _isLoading = true;
                                                    });

                                                    Map<String, String> data = {
                                                        'type': 'profile',
                                                        'id': _userKey,
                                                        'first_name': _firstnameController.text,
                                                        'last_name': _lastnameController.text,
                                                        'email': _emailController.text,
                                                        'language': _languageController.text,
                                                    };
                                                    
                                                    _accountController.updateProfile(context, data, _imageFile, setErrorMessages).then((_) {
                                                        setState(() {
                                                            _isLoading = false;
                                                        });
                                                    });
                                                }
                                            },
                                        )
                                    ],
                                )
                            ),
                        ),
                    ),
                    if (_isLoading)
                        Container(
                            color: Colors.black.withAlpha(128), // 128 es equivalente a 0.5 en opacidad
                            child: const Center(
                                child: CircularProgressIndicator(),
                            ),
                        ),
                ],
            ),
        );
    }

    void setErrorMessages(Map<String, dynamic> errors) {
        setState(() {
            errorManager.setErrors(errors);
        });
    }

    resetErrorMessages(){
        setState(() {
            errorManager.setErrors({
                'first_name': null,
                'last_name': null,
                'email': null,
                'avatar': null,
                'language': null,
            });
        });
    }
}