import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Premium',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final _bbController = TextEditingController();
  final _tbController = TextEditingController();

  double? _hasilBMI;
  double _progressBMI = 0;

  String _keterangan = "Masukkan Data Anda";
  String _jenisKelamin = "Laki-laki";

  Color _hasilColor = Colors.blue;

  List<Map<String, String>> _history = [];

  void _hitungBMI() {
    final double bb = double.tryParse(_bbController.text) ?? 0;
    final double tbCm = double.tryParse(_tbController.text) ?? 0;

    if (bb <= 0 || tbCm <= 0) {
      setState(() {
        _hasilBMI = null;
        _keterangan = "Data Tidak Valid";
        _progressBMI = 0;
      });
      return;
    }

    final double tbM = tbCm / 100;
    final double hasil = bb / (tbM * tbM);

    setState(() {
      _hasilBMI = hasil;
      _progressBMI = (hasil / 40).clamp(0.0, 1.0);

      if (_jenisKelamin == "Laki-laki") {
        if (hasil < 20) {
          _keterangan = "Kurus";
          _hasilColor = Colors.orange;
        } else if (hasil < 25) {
          _keterangan = "Ideal";
          _hasilColor = Colors.green;
        } else if (hasil < 30) {
          _keterangan = "Gemuk";
          _hasilColor = Colors.amber;
        } else {
          _keterangan = "Obesitas";
          _hasilColor = Colors.red;
        }
      } else {
        if (hasil < 18) {
          _keterangan = "Kurus";
          _hasilColor = Colors.orange;
        } else if (hasil < 24) {
          _keterangan = "Ideal";
          _hasilColor = Colors.green;
        } else if (hasil < 29) {
          _keterangan = "Gemuk";
          _hasilColor = Colors.amber;
        } else {
          _keterangan = "Obesitas";
          _hasilColor = Colors.red;
        }
      }

      _history.insert(0, {
        "bmi": hasil.toStringAsFixed(1),
        "status": _keterangan,
        "gender": _jenisKelamin,
      });

      if (_history.length > 10) {
        _history.removeLast();
      }
    });
  }

  void _resetForm() {
    setState(() {
      _bbController.clear();
      _tbController.clear();
      _hasilBMI = null;
      _progressBMI = 0;
      _keterangan = "Masukkan Data Anda";
      _jenisKelamin = "Laki-laki";
      _hasilColor = Colors.blue;
    });
  }

  @override
  void dispose() {
    _bbController.dispose();
    _tbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff6A11CB),
              Color(0xff2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 50,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "BMI PREMIUM",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Kalkulator Berat Badan Ideal",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [

                        TextField(
                          controller: _bbController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.monitor_weight),
                            labelText: "Berat Badan (kg)",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _tbController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.height),
                            labelText: "Tinggi Badan (cm)",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<String>(
                          value: _jenisKelamin,
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.person),
                            labelText: "Jenis Kelamin",
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Laki-laki",
                              child: Text("Laki-laki"),
                            ),
                            DropdownMenuItem(
                              value: "Perempuan",
                              child: Text("Perempuan"),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _jenisKelamin = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _hitungBMI,
                            icon: const Icon(Icons.calculate),
                            label: const Text("Hitung BMI"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _resetForm,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Reset"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [

                      Icon(
                        Icons.health_and_safety,
                        size: 70,
                        color: _hasilColor,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        _hasilBMI?.toStringAsFixed(1) ?? "-",
                        style: TextStyle(
                          fontSize: 55,
                          fontWeight: FontWeight.bold,
                          color: _hasilColor,
                        ),
                      ),

                      Text(
                        _keterangan,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _hasilColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      LinearProgressIndicator(
                        value: _progressBMI,
                        minHeight: 12,
                        borderRadius:
                            BorderRadius.circular(25),
                        color: _hasilColor,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Jenis Kelamin : $_jenisKelamin",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          const Row(
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.deepPurple,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Riwayat BMI",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          if (_history.isNotEmpty)
                            IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                setState(() {
                                  _history.clear();
                                });
                              },
                            ),
                        ],
                      ),

                      const Divider(),

                      _history.isEmpty
                          ? const Padding(
                              padding:
                                  EdgeInsets.all(20),
                              child: Center(
                                child: Text(
                                  "Belum ada riwayat BMI",
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount:
                                  _history.length,
                              itemBuilder:
                                  (context, index) {

                                final item =
                                    _history[index];

                                return Card(
                                  child: ListTile(
                                    leading:
                                        CircleAvatar(
                                      backgroundColor:
                                          Colors
                                              .deepPurple,
                                      child: Text(
                                        "${index + 1}",
                                        style:
                                            const TextStyle(
                                          color: Colors
                                              .white,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      "BMI : ${item["bmi"]}",
                                    ),
                                    subtitle: Text(
                                      "${item["gender"]} • ${item["status"]}",
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}