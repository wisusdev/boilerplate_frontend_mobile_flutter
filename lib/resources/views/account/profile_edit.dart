import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/helpers/text.dart';

class ProfileEdit extends StatefulWidget {
    const ProfileEdit({super.key});

    @override
    State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _firstnameController = TextEditingController();
	final TextEditingController _lastnameController = TextEditingController();
	final TextEditingController _emailController = TextEditingController();
    final TextEditingController _avatarController = TextEditingController();
    final TextEditingController _languageController = TextEditingController();
    final ImagePicker _picker = ImagePicker();

    Map<String, dynamic> errorMessage = {
        'first_name': null,
        'last_name': null,
        'email': null,
        'avatar': null,
        'language': null,
    };

    XFile? _imageFile;

    @override
    void initState() {
        super.initState();

        SharedPreferences.getInstance().then((prefs) {
            var userJson = prefs.getString('user');
            if (userJson != null) {
                var user = json.decode(userJson);
                setState(() {
                    _firstnameController.text = user['first_name'] ?? '';
                    _lastnameController.text = user['last_name'] ?? '';
                    _emailController.text = user['email'] ?? '';
                    _avatarController.text = user['avatar'] ?? '';
                    _languageController.text = user['language'] ?? '';
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
                leading: BackButton(color: Theme.of(context).colorScheme.onPrimary),
                title: Text(
                    capitalizeText('${Location.of(context)!.trans('edit')} ${Location.of(context)!.trans('profile')}'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: Container(
                padding: const EdgeInsets.all(20),
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
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('firstName')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                }

                                                if(errorMessage['first_name'] != null){
                                                    return errorMessage['first_name'];
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
                                                    return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                }

                                                if(errorMessage['last_name'] != null){
                                                    return errorMessage['last_name'];
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: inputDecoration(labelText: Location.of(context)!.trans('email')),
                                validator: (value) {
                                    if (value!.isEmpty) {
                                        return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                    }

                                    if(errorMessage['email'] != null){
                                        return errorMessage['email'];
                                    }

                                    return null;
                                },
                            ),

                            const SizedBox(height: 20),

                            InputDecorator(
                                decoration: inputDecoration(labelText: Location.of(context)!.trans('language')),
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
                                child: Text(Location.of(context)!.trans('selectAPicture')),
                            ),

                        ],
                    )
                ),
            ),
        );
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