# 🧭 Gezi Rehberi

Flutter ve Firebase kullanılarak geliştirilmiş bir mobil gezi rehberi uygulamasıdır. Kullanıcılar giriş yapabilir, gezilecek yerleri inceleyebilir, favorilerine ekleyebilir ve harita üzerinden yerleri görüntüleyebilir.

## 🚀 Özellikler

- 🔐 Firebase Authentication ile kullanıcı girişi
- 📍 Harita üzerinde gezilecek yerleri görüntüleme
- ❤️ Favori mekanları kaydetme
- 🔎 Arama sayfası ile mekan filtreleme
- 📸 Görsellerle zenginleştirilmiş detay sayfaları
- 🎯 E-posta doğrulama desteği

## 🛠️ Kullanılan Teknolojiler

| Teknoloji       | Açıklama                            |
|----------------|-------------------------------------|
| Flutter         | Mobil uygulama geliştirme          |
| Firebase Auth   | Kullanıcı doğrulama                 |
| Firestore       | (Planlanan) Veri tabanı altyapısı  |
| Google Maps     | Harita entegrasyonu                |


## 📁 Proje Yapısı

```bash
lib/
├── main.dart                # Giriş noktası
├── screens/
│   ├── Pages/               # Login, Map, Profile, Search gibi sayfalar
│   ├── Details/             # Yer detaylarını içeren ekranlar
│   └── home/                # Ana sayfa ve navigasyon yapısı
assets/
└── images/                  # Mekan görselleri
