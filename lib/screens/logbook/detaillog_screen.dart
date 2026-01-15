import 'package:flutter/material.dart';

class DetailLogScreen extends StatelessWidget {
  final Map<String, dynamic> logbook;

  const DetailLogScreen({
    Key? key,
    required this.logbook,
  }) : super(key: key);

  // ===============================
  // STATUS STYLE
  // ===============================
  Map<String, dynamic> _getStatusStyle(String status) {
    switch (status) {
      case 'approved':
        return {
          'color': Colors.green,
          'text': 'Disetujui Dosen',
          'icon': Icons.check_circle,
        };
      case 'rejected':
        return {
          'color': Colors.red,
          'text': 'Ditolak',
          'icon': Icons.cancel,
        };
      default:
        return {
          'color': Colors.amber,
          'text': 'Menunggu Persetujuan',
          'icon': Icons.hourglass_bottom,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = logbook['status'] ?? 'pending';
    final statusStyle = _getStatusStyle(status);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Detail Logbook"),
        backgroundColor: const Color(0xFF3B64A7),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===============================
            // HEADER STATUS
            // ===============================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: statusStyle['color'].withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    statusStyle['icon'],
                    color: statusStyle['color'],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    statusStyle['text'],
                    style: TextStyle(
                      color: statusStyle['color'],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // ===============================
            // CONTENT
            // ===============================
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // JUDUL
                  Text(
                    logbook['kegiatan'] ?? 'Logbook',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E40AF),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // CARD INFO
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          Icons.person,
                          "Dosen Pembimbing",
                          logbook['dosen'] ?? "-",
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.calendar_today,
                          "Tanggal Praktik",
                          logbook['tanggal'] ?? "-",
                        ),
                        const Divider(),
                        _buildDetailRow(
                          Icons.location_on,
                          "Lokasi",
                          logbook['lokasi'] ?? "-",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // DESKRIPSI
                  const Text(
                    "Deskripsi Kegiatan",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    logbook['kegiatan'] ?? "-",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 24),

                  // FOTO BUKTI
                  const Text(
                    "Bukti Foto",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildImage(logbook['foto']),

                  const SizedBox(height: 24),

                  // CATATAN DOSEN (OPSIONAL)
                  if (logbook['notes'] != null &&
                      logbook['notes'].toString().isNotEmpty) ...[
                    const Text(
                      "Catatan Dosen",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusStyle['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusStyle['color'].withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        logbook['notes'],
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // WIDGET HELPERS
  // ===============================
  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: const Color(0xFF3B64A7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
              SizedBox(height: 6),
              Text("Tidak ada foto lampiran"),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
