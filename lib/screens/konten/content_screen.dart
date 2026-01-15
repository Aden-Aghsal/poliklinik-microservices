import 'package:flutter/material.dart';
import '../../models/news_model.dart';
import '../../services/api_service_kon.dart';
import '../../widgets/article_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiServiceKon _apiService = ApiServiceKon();
  
  // Variabel untuk mengontrol navigasi bawah
  int _currentIndex = 1; // Default di index 1 (Log) sesuai gambar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF133E87),
      appBar: _currentIndex == 1 ? AppBar( // AppBar hanya muncul jika di tab Log
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFF133E87)),
          ),
        ),
        title: const Text(
          "Berita & Artikel",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ) : null,
      
      // Menggunakan Switch Case untuk konten body berdasarkan tab yang dipilih
      body: _buildBodyContent(),

      // Penempatan Tombol Floating Tengah (Daftar)
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.list_alt, color: Color(0xFF133E87), size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Desain Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
  shape: const CircularNotchedRectangle(),
  notchMargin: 8.0,
  clipBehavior: Clip.antiAlias,
  child: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: const Color(0xFF133E87),
    unselectedItemColor: Colors.grey,
    
    // UBAH DUA BARIS INI JADI FALSE
    showSelectedLabels: false, 
    showUnselectedLabels: false, 
    
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Beranda"),
      BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: "Log"),
      BottomNavigationBarItem(icon: SizedBox.shrink(), label: ""), 
      BottomNavigationBarItem(icon: Icon(Icons.history), label: "Artikel"),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
    ],
  ),
),
    );
  }

  // Fungsi untuk memisahkan konten Body
  Widget _buildBodyContent() {
    if (_currentIndex == 1) {
      // Halaman LOG (Halaman utama kamu yang ada FutureBuilder)
      return FutureBuilder<List<NewsModel>>(
        future: _apiService.getNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data.", style: TextStyle(color: Colors.white)));
          }

          final listBerita = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {});
              await Future.delayed(const Duration(seconds: 1));
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: listBerita.length,
              itemBuilder: (context, index) {
                final berita = listBerita[index];
                return _buildModernCard(berita);
              },
            ),
          );
        },
      );
    } else {
      // Tampilan placeholder untuk tab lain
      return Center(
        child: Text(
          "Halaman Tab $_currentIndex",
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
  }

  Widget _buildModernCard(NewsModel berita) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FE),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              berita.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF133E87)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                const Text("15 Januari 2026", style: TextStyle(color: Color(0xFF555555), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 10),
                Text("Author ID: ${berita.author_id}", style: const TextStyle(color: Color(0xFF555555), fontSize: 14)),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.circle, size: 10, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text("Kategori ${berita.kategori_id}",
                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
  width: double.infinity,
  height: 45,
  child: ElevatedButton(
    onPressed: () {
      // TAMBAHKAN NAVIGASI DI SINI
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleSection( item : berita), // Sesuaikan nama Class Detail kamu
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6895C8),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: const Text(
      "Lihat Detail", 
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
    ),
  ),
),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.white54),
          const SizedBox(height: 15),
          Text("Gagal: $error", style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text("Coba Lagi"),
          ),
        ],
      ),
    );
  }
}