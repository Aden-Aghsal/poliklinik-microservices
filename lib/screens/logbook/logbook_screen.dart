import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'formlog_screen.dart';
import 'detaillog_screen.dart';
import '../../services/hubunganbackend/apilogbook_service.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  List<Map<String, dynamic>> _logbooks = [];
  Map<int, String> _lecturerMap = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    
    // 1. Fetch Lecturers for Mapping Name
    final lecturers = await ApiLogbookService.getLecturers();
    final Map<int, String> lectureMap = {};
    for (var l in lecturers) {
      if (l['id'] != null) {
        lectureMap[l['id']] = l['name'] ?? 'Unknown';
      }
    }

    // 2. Fetch Logbooks
    final res = await ApiLogbookService.getLogbooks();
    List<Map<String, dynamic>> loadedLogbooks = []; // default empty

    if (res['success'] == true && res['data'] != null) {
      loadedLogbooks = List<Map<String, dynamic>>.from(res['data']);
    }

    if (mounted) {
      setState(() {
        _lecturerMap = lectureMap;
        _logbooks = loadedLogbooks;
        _isLoading = false;
      });
    }
  }

  // Name Helper
  String _getLecturerName(dynamic id) {
    if (id == null) return "-";
    int? parsedId = int.tryParse(id.toString());
    return _lecturerMap[parsedId] ?? "ID: $id";
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Logbook Mahasiswa",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.add, color: Color(0xFF133E87)),
          ),
          onPressed: () async {
            final refresh = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormLogScreen()),
            );

            if (refresh == true) {
              _fetchData();
            }
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF133E87), Color(0xFF608BC1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : _logbooks.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      MediaQuery.of(context).padding.top + kToolbarHeight + 20,
                      16,
                      20,
                    ),
                    itemCount: _logbooks.length,
                    itemBuilder: (context, index) {
                      final item = _logbooks[index];
                      // Inject mapped name for display
                      final displayItem = Map<String, dynamic>.from(item);
                      displayItem['dosen'] = _getLecturerName(item['lecturer_id']);
                      
                      return LogbookCard(logbook: displayItem);
                    },
                  ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text(
        "Belum ada logbook",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class LogbookCard extends StatelessWidget {
  final Map<String, dynamic> logbook;

  const LogbookCard({super.key, required this.logbook});

  Color _statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = logbook['status'] ?? 'pending';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            logbook['kegiatan'] ?? 'Logbook',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF133E87),
            ),
          ),
          const SizedBox(height: 8),
          Text("📅 ${logbook['tanggal']}"),
          Text("👨‍🏫 ${logbook['dosen']}"),
          const SizedBox(height: 12),
          Chip(
            label: Text(status.toUpperCase()),
            backgroundColor: _statusColor(status).withOpacity(0.2),
            labelStyle: TextStyle(color: _statusColor(status)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF608BC1),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailLogScreen(logbook: logbook),
                  ),
                );
              },
              child: const Text("Lihat Detail"),
            ),
          ),
        ]),
      ),
    );
  }
}
