import 'dart:async';

import 'package:babyfood/feature/presentation/pages/user/widgets/date_text_formatter.dart';
import 'package:babyfood/feature/presentation/providers/auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UserEditScreen extends ConsumerStatefulWidget {
  const UserEditScreen({super.key});

  @override
  ConsumerState<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends ConsumerState<UserEditScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider);
    final data = ref.watch(dataProvider);

    return user.when(
      data: (user) {
print(data.asData);
        return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.goNamed('account');
            },
            icon: const Icon(
              Icons.arrow_back_ios, // add custom icons also
            ),
          ),
          title: const Text('Редактировать данные'),
        ),
        body: Form(
          key: formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    autocorrect: false,
                    controller: nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value!.trim().isEmpty
                        ? 'Поле не должно быть пустывм'
                        : null,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      hintText: data.asData!.value?['name']??'Введите имя малыша',
                      filled: true,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(

                      inputFormatters: [DateTextFormatter()],
                      keyboardType: TextInputType.datetime,
                      autocorrect: false,
                      controller: dateOfBirthController,
                    validator: (value) => value!.trim().length<6
                        ? 'Некорректно установлена дата'
                        : null,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        hintText: data.asData!.value!['date_of_birth']??
                         'Введите дату рождения',
                        filled: true,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2051));
                        if (pickedDate != null) {
                          final formattedDate =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                          setState(() {
                            dateOfBirthController.text =
                                formattedDate;
                          });
                        }
                      },),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton(
                        onPressed: () async {
                          final isValid = formKey.currentState!.validate();
                          if (!isValid) return;
                          final ref = FirebaseFirestore.instance
                              .collection('accounts')
                              .doc(user?.uid);
                          await ref.set({'name': nameController.text.trim(), 'date_of_birth':dateOfBirthController.text.trim()});
                          context.goNamed('account');
                        },
                        child: const Text('Сохранить')),
                  ),
                  const SizedBox(
                    height: 16,
                  )
                ],
              ),
            ),
          ),
        ),
      );},
      error: (e, s) => const Text('error'),
      loading: () => const Text('loading'),
    );
  }
}


