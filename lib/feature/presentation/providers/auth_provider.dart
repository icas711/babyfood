import 'dart:convert';

import 'package:babyfood/feature/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(FirebaseAuth.instance));

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.read(authRepositoryProvider).userChanges);

final dataProvider = StreamProvider<Map?>(
  (ref) {
    final userStream = ref.watch(authStateProvider);

    var user = userStream.value; //.asData?.value;

    if (user != null) {
      var docRef =
          FirebaseFirestore.instance.collection('accounts').doc(user.uid);
      return docRef.snapshots().map((userdata) => userdata.data());
    } else {
      return Stream.empty();
    }
  },
);

// Listen to data in Firestore
class AccountDetails extends ConsumerStatefulWidget {
  @override
  ConsumerState<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends ConsumerState<AccountDetails> {
  late final prefs;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);

    return data.when(
      data: (account) {
        Uint8List? image;
        if (account?['image'] != null) {
          image = Base64Codec().decode(account!['image']);
        }
        return Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed('upload_image');
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: (account?['image'] != null)
                                ? Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.memory(
                                        image!,
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                                  )
                                : const CircleAvatar(
                                    radius: 50,
                                    child: Icon(
                                      color: Colors.grey,
                                      Icons.person,
                                      size: 100,
                                    ),
                                  ),
                          ),
                          const Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.edit,
                                size: 30,
                              ))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              account!['name'] ?? 'Неизвесто',
                              style: const TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Text(
                                  'Дата рождения: ',
                                ),
                                Text(account!['date_of_birth'] ??
                                    'Не установлена!')
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
      error: (e, s) => Text('error'),
      loading: () => Text('waiting for data...'),
    );
  }
}
