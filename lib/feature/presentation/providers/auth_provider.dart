import 'dart:convert';
import 'dart:typed_data';

import 'package:babyfood/feature/domain/repositories/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(FirebaseAuth.instance));

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.read(authRepositoryProvider).userChanges);

// Join provider Streams
final dataProvider = StreamProvider<Map?>(
  (ref) {
    final userStream = ref.watch(authStateProvider);

    var user = userStream.value; //.asData?.value;

    if (user != null) {
      var docRef =
          FirebaseFirestore.instance.collection('accounts').doc(user.uid);
      return docRef.snapshots().map((doc) => doc.data());
    } else {
      return Stream.empty();
    }
  },
);

// Listen to data in Firestore
class AccountDetails extends ConsumerWidget {
  @override
  Widget build(context, ref) {
    final data = ref.watch(dataProvider);

    return data.when(
      data: (account) {
        return Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    context.goNamed('upload_image');
                  },
                  child: Stack(
                    children: [
                      if (account?['image']!=null)
                        Image.memory(
                          base64Decode(account?['image']),
                          width: 100,
                          height: 100,
                        )
                      else
                        const CircleAvatar(
                          radius: 50,
                          child: Icon(
                            color: Colors.grey,
                            Icons.person,
                            size: 100,
                          ),
                        ),
                      const Positioned(
                        right: 0,
                          bottom: 0,
                          child: Icon(Icons.edit))
                    ],

                  ),
                )
              ],
            ),
            Text(account?['name'] ?? 'empty'),
          ],
        );
      },
      error: (e, s) => Text('error'),
      loading: () => Text('waiting for data...'),
    );
  }
}
