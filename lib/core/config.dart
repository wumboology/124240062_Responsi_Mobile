// ============================================================
// SEMUA YANG SERING DIGANTI SAAT RESPONSI ADA DI FILE INI.
// Default-nya sudah diisi API TVMaze supaya bisa langsung dites.
// Tanda "GANTI" = bagian yang biasanya berubah di soal.
// ============================================================

// ---------- Teks & tampilan ----------
const String kAppName = 'Keripikroll'; // GANTI: nama aplikasi
const String kHomeTitle = 'Beranda'; // GANTI: judul halaman utama
const String kSavedWord = 'Favorit'; // GANTI: Favorit / Bookmark / Keranjang / Library
const String kProfileMessage =
    'Kesan: Praktikum mobile seru\n'
    'Pesan: Terima kasih kak aslab'; // GANTI
const String kAllLabel = 'Semua'; // label chip filter "semua"
const bool kUseGrid = true; // true = grid, false = list (bisa ditoggle di app)
const bool kShowCategoryFilter = true; // false = sembunyikan chip filter

// ---------- Login ----------
const bool kUseFixedLogin = true; // true = wajib pakai akun di bawah; false = username/password apa saja
const String kFixedUsername = '124240062'; // GANTI: sesuai soal (NIM / email)
const String kFixedPassword = '123'; // GANTI
const String kUsernameLabel = 'Username'; // GANTI: 'Username' / 'Email' / 'NIM'
const bool kShowRegister = true; // false = sembunyikan tombol Register

// ---------- API ----------
const String kApiBase = 'https://kitsu.io/api/edge/anime'; // GANTI
const String kListPath = '/?page[limit]=20&page[offset]=0'; // GANTI: endpoint daftar
const String kListKey = 'data'; // GANTI: '' = JSON langsung list. Kalau dibungkus {"results":[...]} isi 'results'
const String kDetailPath = '/anime/{id}'; // GANTI: {id} diganti id item. Contoh query: '/game?id={id}'. '' = tidak ada endpoint detail
const String kDetailKey = 'data'; // GANTI: '' = detail langsung object. Kalau dibungkus isi nama key-nya
const Map<String, String> kHeaders = {}; // GANTI kalau API minta header, mis. {'Authorization': 'Bearer xxx'}

// ---------- Nama key JSON ----------
// Isi satu atau beberapa nama key; dicoba berurutan, yang pertama ada isinya dipakai.
// Key bersarang pakai titik: 'image.medium'. Kalau nilainya list ['a','b'] -> diambil/gabung otomatis.
const List<String> kIdKeys = ['attributes.id']; // GANTI
const List<String> kTitleKeys = ['attributes.titles.en']; // GANTI: judul item (title / name / ...)
const List<String> kSubtitleKeys = ['attributes.ageRating']; // GANTI: teks kecil di bawah judul
const List<String> kCategoryKeys = ['attributes.categories']; // GANTI: dipakai untuk chip filter (list -> ambil elemen pertama)
const List<String> kImageKeys = ['attributes.posterImage.original', 'attributes.posterImage.medium']; // GANTI
const List<String> kDescriptionKeys = ['attributes.synopsis']; // GANTI (tag HTML dibuang otomatis)
const List<String> kDateKeys = ['attributes.ageRating', 'attributes.episodeCount']; // GANTI (belum diverifikasi untuk TVMaze; kosong kalau tidak ada)
const List<String> kRatingKeys = ['attributes.ageRating']; // GANTI
const List<String> kLinkKeys = ['url']; // GANTI: tautan web (belum dipakai di UI, lihat catatan)

// ---------- Nama box Hive ----------
const String kUsersBox = 'users'; // akun hasil register
const String kSavedBox = 'saved_items'; // favorit / keranjang / bookmark
