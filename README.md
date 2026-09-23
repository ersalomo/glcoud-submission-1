# Profile App — Google Cloud Submission 1

Aplikasi profil pribadi yang di-hosting di **Google App Engine** dengan aset gambar disimpan di **Google Cloud Storage**.

## Struktur Proyek

```
submission-1/
├── index.html          # Halaman profil utama (HTML saja)
├── style.css           # Styling premium dark mode
├── app.yaml            # Konfigurasi App Engine
├── deploy.sh           # Script deployment otomatis
├── url.txt             # URL App Engine (diisi setelah deploy)
├── hero_banner.jpg     # Banner hero (upload ke GCS)
├── skill_cloud.jpg     # Badge Google Cloud (upload ke GCS)
├── skill_python.jpg    # Badge Python (upload ke GCS)
├── bg_pattern.jpg      # Background pattern (upload ke GCS)
└── education_badge.jpg # Badge pendidikan (upload ke GCS)
```

## Gambar dari Cloud Storage

Aplikasi ini menggunakan **6 gambar** dari Google Cloud Storage:

| File | Digunakan di |
|------|-------------|
| `profile_photo.jpg` | Hero - foto profil |
| `hero_banner.jpg` | Hero - banner background + skills DevOps |
| `skill_cloud.jpg` | Skills GCP + Skills Networking + Education Dicoding |
| `skill_python.jpg` | Skills Python + About section |
| `bg_pattern.jpg` | Body background + Skills Web Dev |
| `education_badge.jpg` | Skills ML + Education University |

Semua URL menggunakan format: `https://storage.googleapis.com/BUCKET_NAME/FILE.jpg`

## Cara Deploy

### Prasyarat
- Google Cloud SDK (`gcloud`) terinstal dan terautentikasi
- Project GCP aktif dengan billing diaktifkan

### Langkah Deploy

**Opsi 1: Gunakan script otomatis**
```bash
chmod +x deploy.sh
./deploy.sh YOUR_PROJECT_ID YOUR_BUCKET_NAME
```

**Opsi 2: Manual step-by-step**

1. **Set project GCP:**
```bash
gcloud config set project YOUR_PROJECT_ID
```

2. **Buat bucket GCS:**
```bash
gsutil mb -l asia-southeast2 gs://YOUR_BUCKET_NAME
gsutil iam ch allUsers:objectViewer gs://YOUR_BUCKET_NAME
```

3. **Upload gambar:**
```bash
gsutil cp hero_banner.jpg gs://YOUR_BUCKET_NAME/
gsutil cp skill_cloud.jpg gs://YOUR_BUCKET_NAME/
gsutil cp skill_python.jpg gs://YOUR_BUCKET_NAME/
gsutil cp bg_pattern.jpg gs://YOUR_BUCKET_NAME/
gsutil cp education_badge.jpg gs://YOUR_BUCKET_NAME/
# Upload foto profil Anda:
gsutil cp FOTO_ANDA.jpg gs://YOUR_BUCKET_NAME/profile_photo.jpg
```

4. **Ganti `YOUR_BUCKET_NAME` di file HTML dan CSS:**
```bash
sed -i "s/YOUR_BUCKET_NAME/NAMA_BUCKET_ANDA/g" index.html style.css
```

5. **Deploy ke App Engine:**
```bash
gcloud app deploy app.yaml --quiet
```

6. **Ambil URL dan update url.txt:**
```bash
gcloud app describe --format="value(defaultHostname)"
# Salin hasilnya ke url.txt (tanpa prefix "https://")
# Format: PROJECT_ID.REGION.r.appspot.com
```

## Kustomisasi Profil

Edit `index.html` dan ganti placeholder berikut:

| Placeholder | Ganti dengan |
|-------------|--------------|
| `Nama Lengkap Anda` | Nama Anda |
| `Cloud Engineer & Developer` | Role/jabatan Anda |
| `Seorang developer...` | Bio singkat Anda |
| `Universitas Nama Anda` | Nama universitas Anda |
| `USERNAME_ANDA` (GitHub) | Username GitHub Anda |
| `USERNAME_ANDA` (LinkedIn) | Username LinkedIn Anda |
| `email@example.com` | Email Anda |

## Kriteria Submission

- [x] Hosting di App Engine (nilai lebih tinggi dari Compute Engine)
- [x] Menampilkan informasi profil
- [x] Foto profil dari Cloud Storage
- [x] Minimal 5 gambar dari Cloud Storage (ini: 6 gambar)
- [x] URL gambar menggunakan `storage.googleapis.com/...`
- [x] Hanya HTML + CSS (tidak ada JS untuk konten)
- [x] File `url.txt` dengan URL App Engine
# glcoud-submission-1
