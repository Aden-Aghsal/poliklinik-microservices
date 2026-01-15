import 'package:flutter/material.dart';
import '../../services/hubunganbackend/apilogbook_service.dart';

class FormLogScreen extends StatefulWidget {
  const FormLogScreen({super.key});

  @override
  State<FormLogScreen> createState() => _FormLogScreenState();
}

class _FormLogScreenState extends State<FormLogScreen> {
  final TextEditingController kegiatanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  // Ganti Controller Dosen dengan Variable ID Seleksi
  int? selectedLecturerId;
  String? selectedLokasi;
  DateTime? selectedDate;
  
  bool isLoading = false;
  bool isLoadingLecturers = true;
  List<Map<String, dynamic>> lecturers = [];

  final List<String> lokasiList = [
    "Mini Poli Anak",
    "Mini Poli Gigi",
    "Mini Poli Umum",
    "Mini Poli Ibu & Anak",
    "Mini Poli Lansia",
  ];

  @override
  void initState() {
    super.initState();
    _fetchLecturers();
  }

  Future<void> _fetchLecturers() async {
    final data = await ApiLogbookService.getLecturers();
    setState(() {
      lecturers = data;
      isLoadingLecturers = false;
    });
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        tanggalController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    kegiatanController.dispose();
    tanggalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Logbook"),
        backgroundColor: const Color(0xFF133E87),
        foregroundColor: Colors.white,
      ),
      body: isLoadingLecturers 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // ===== DOSEN (DROPDOWN) =====
                DropdownButtonFormField<int>(
                  value: selectedLecturerId,
                  items: lecturers.map((lecturer) {
                    return DropdownMenuItem<int>(
                      value: lecturer['id'],
                      child: Text(lecturer['name'] ?? 'Unknown'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() => selectedLecturerId = val);
                  },
                  decoration: InputDecoration(
                    labelText: "Pilih Dosen Pembimbing",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ===== TANGGAL =====
                TextField(
                  controller: tanggalController,
                  readOnly: true,
                  onTap: pickDate,
                  decoration: InputDecoration(
                    labelText: "Tanggal Praktik",
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ===== LOKASI =====
                DropdownButtonFormField<String>(
                  value: selectedLokasi,
                  items: lokasiList
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() => selectedLokasi = val);
                  },
                  decoration: InputDecoration(
                    labelText: "Lokasi Praktek (Mini Poli)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // ===== KEGIATAN =====
                TextField(
                  controller: kegiatanController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Deskripsi Kegiatan",
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ===== BUTTON SIMPAN =====
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF133E87),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (selectedLecturerId == null ||
                                tanggalController.text.isEmpty ||
                                kegiatanController.text.isEmpty ||
                                selectedLokasi == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Harap isi semua data wajib!"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }

                            setState(() => isLoading = true);

                            // ==== PANGGIL API ====
                            final result = await ApiLogbookService.createLogbook(
                              lecturerId: selectedLecturerId!,
                              tanggal: tanggalController.text, // Format YYYY-MM-DD
                              kegiatan: kegiatanController.text,
                              lokasi: selectedLokasi!,
                              // Foto belum diimplementasikan di UI
                            );

                            setState(() => isLoading = false);

                            if (result['success'] == true) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message']),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              Navigator.pop(context, true); // Return true agar halaman depan refresh
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(result['message']),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Simpan Logbook",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
