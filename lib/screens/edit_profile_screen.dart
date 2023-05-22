import 'dart:io';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../model/profile_data.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen(
      {super.key, required this.data, required this.onProfileDataUpdate, required this.onImageChanged});
  ProfileData data;
  final void Function(File image)onImageChanged;
  final void Function(ProfileData data) onProfileDataUpdate;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? imageFile;
  final List<String> countries = [
    'Nigeria',
    'Pakistan',
    'India',
    'US',
    'Canada'
  ];
  final ImagePicker _picker = ImagePicker();
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _dobController;
  TextEditingController? _countryController;
  String? _image;
  List<DateTime?> _dates = [];
  var _emailValidate = true;
  var _passwordValidate = true;
  var _nameValidate = true;
  @override
  void initState() {
    super.initState();
    _dates.add(widget.data.dob);
    _image = widget.data.image;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _dobController = TextEditingController();
    _countryController = TextEditingController();
    _nameController?.text = widget.data.name;
    _emailController?.text = widget.data.email;
    _passwordController?.text = widget.data.password;
    _dobController?.text = DateFormat('yyyy-MM-dd').format(widget.data.dob);
    _countryController?.text = widget.data.country;
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _countryController?.dispose();
    _dobController?.dispose();
    _passwordController?.dispose();
    _emailController?.dispose();
    super.dispose();
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Select where You want your picture taken from',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Camera'),
              onPressed: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.camera);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.of(context).pop();
                _getImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  _getImage(ImageSource source) async {
    XFile? file = await _picker.pickImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    setState(() {
      if (file !=null) {
        imageFile = File(file.path);
      }
    });
  }

  Future<void> showCalender(BuildContext ctx) async {
    var results = await showCalendarDatePicker2Dialog(
      context: ctx,
      config: CalendarDatePicker2WithActionButtonsConfig(
        lastDate: DateTime.now(),
      ),
      dialogSize: const Size(325, 400),
      value: _dates,
      borderRadius: BorderRadius.circular(15),
    );
    setState(() {
      _dates = results ?? [DateTime.now()];
      widget.data.dob = _dates[0] ?? DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(90.0),

                        child:imageFile == null
                               ? Image.asset(_image ?? "none",fit: BoxFit.fill,height: 170,width: 170,)
                              : Image.file(imageFile!,fit: BoxFit.fill,height: 170,width: 170, ),
                      ),),
                  //     CircleAvatar(radius: 120,child:imageFile == null
                  //       ? Image.asset(_image ?? "none",)
                  //       : Image.file(imageFile!,fit: BoxFit.cover ),),
                  // ),),
                Positioned(
                  right: 100,
                    bottom: -10,
                    child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    size: 26,
                    color: Color(0xCF242760),
                  ),
                  onPressed: () {
                    _dialogBuilder(context);
                  },
                ))
              ]),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Name',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF544C4C)),
                controller: _nameController ?? TextEditingController(),
                decoration: InputDecoration(
                  errorText: _nameValidate ? null : 'Enter Valid Name',
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0x26544C4C), width: 1.0)),
                ),
                onSubmitted: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      _nameValidate = false;
                    } else {
                      _nameValidate = true;
                    }
                    widget.data.name = _nameController?.text ?? "";
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Email',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF544C4C)),
                controller: _emailController ?? TextEditingController(),
                decoration: InputDecoration(
                  errorText: _emailValidate ? null : 'Enter Valid Email',
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0x26544C4C), width: 1.0)),
                ),
                onSubmitted: (value) {
                  setState(() {
                    if (value.isEmpty ||
                        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                      _emailValidate = false;
                    } else {
                      _emailValidate = true;
                    }
                    widget.data.email = _emailController?.text ?? "";
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Password',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                obscureText: true,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF544C4C)),
                controller: _passwordController ?? TextEditingController(),
                decoration: InputDecoration(
                  errorText: _passwordValidate
                      ? null
                      : 'Enter Valid Password with least 8 character length,1 lower,1 Capital and a number',
                  border: const OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0x26544C4C), width: 1.0)),
                ),
                onSubmitted: (value) {
                  setState(() {
                    if (value.isEmpty ||
                        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$')
                            .hasMatch(value)) {
                      _passwordValidate = false;
                    } else {
                      _passwordValidate = true;
                    }
                    widget.data.password = _passwordController?.text ?? "";
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Date of Birth',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showCalender(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border:
                          Border.all(width: 1, color: const Color(0x26544C4C))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(widget.data.dob),
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF544C4C)),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Country/Region',
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(width: 1, color: const Color(0x26544C4C))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        widget.data.country,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF544C4C)),
                      ),
                      const Spacer(),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Color(0xFF544C4C)),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              widget.data.country = value ?? "Nigeria";
                            });
                          },
                          items: countries
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_emailValidate && _nameValidate && _passwordValidate) {
                      widget.onImageChanged(imageFile!);
                      widget.onProfileDataUpdate(widget.data);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF242760),
                      foregroundColor: Colors.white),
                  child: const Text(
                    "Save Changes",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
