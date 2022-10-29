import 'package:flutter/material.dart';
import 'package:mod3_kel30/screens/profile.dart';
import 'package:mod3_kel30/screens/profiles.dart';

class Profiles extends StatelessWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KELOMPOK 30'),
      ),
      body: Column(
        children: [
          Anggota(
            nama: "Septian Agung Permana",
            nim: "21120120140129",
            kelompok: "30",
          ),
          Anggota(
            nama: "Juanda Ritonga",
            nim: "21120120140150",
            kelompok: "30",
          ),
          Anggota(
            nama: "Naura Sharfina Azarine",
            nim: "21120120140159",
            kelompok: "30",
          ),
          Anggota(
            nama: "Nabila Hana Saphira ",
            nim: "21120120140112",
            kelompok: "30",
          )
        ],
      ),
    );
  }
}
