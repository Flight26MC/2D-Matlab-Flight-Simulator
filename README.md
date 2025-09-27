# MATLAB ile Geliştirilmiş 2D Uçuş Simülatörü v1.0

![Platform](https://img.shields.io/badge/Platform-MATLAB-orange)
![Lisans](https://img.shields.io/badge/License-MIT-yellow)

## Giriş: Projenin Amacı ve Felsefesi

Bu proje, MATLAB ortamında geliştirilmiş, bir uçağın 2D uçuş dinamiklerini simüle eden modüler bir yazılımdır. Proje, sadece bir uçağın uçuşunu taklit etmekten daha derin bir amaçla tasarlanmıştır: Karmaşık dinamik sistemlerin **kapalı çevrim kontrolü (closed-loop control)** prensiplerini keşfetmek için modüler ve analize dayalı bir **"sanal laboratuvar" (sandbox)** ortamı yaratmak.

Bu felsefe doğrultusunda, uçağın kendisi fotogerçekçi bir model olarak değil, 2D nokta kütleli bir sistem olarak soyutlanmıştır. Bu sayede tüm odak, uçağın kendisinden ziyade, onu kontrol etmeye çalışan **PID (Oransal-İntegral-Türevsel) kontrollü otopilotun davranışına** çevrilmiştir. Simülasyonun asıl amacı, bu üç temel kontrol kuvveti (`Kp`, `Ki`, `Kd`) arasındaki mükemmel dengeyi bulma sanatını ve mühendisliğini veri odaklı bir yaklaşımla keşfetmektir.

Bu ilk sürüm (**v1.0**), temel simülasyon altyapısını ve **Hafif Eğitim Uçağı** profilini içermektedir.

---

## Simülasyon Çıktısı

Aşağıda, Hafif Eğitim Uçağı için hedeflenen irtifaya minimum salınımla oturan, başarılı bir otopilot ayarının sonuç paneli görülmektedir.

<img width="988" height="613" alt="Manuel Uçuş Örnek Sonuçlar" src="https://github.com/user-attachments/assets/dd4d23b7-afc4-4478-a0e8-cbc2a442ab04" />


<img width="984" height="624" alt="İrtifa Sabitleme Örnek Sonuçlar" src="https://github.com/user-attachments/assets/fa2b4296-5ed2-411e-8f85-142bfbc86e9d" />


---

## Gelişme: Proje Mimarisi ve Teknik Detaylar

Proje, her biri net bir sorumluluğa sahip olan (Single Responsibility Principle) modüler `.m` dosyaları kullanılarak yapılandırılmıştır. Bu mimari, kodun okunabilirliğini, bakımını ve gelecekteki genişletilebilirliğini artırmaktadır.

### Modül Sorumlulukları

- `ucus_simulasyon.m`: **Ana Kontrol ve Simülasyon Yöneticisi (Main Controller & Simulation Manager)**
  - Programın ana giriş noktasıdır. Kullanıcı menüsünü sunar, simülasyon senaryosunu ayarlar ve MATLAB'in `ode45` diferansiyel denklem çözücüsünü çağırarak simülasyonu başlatır. Simülasyon sonrası veri işleme (post-processing) ve loglama işlemlerini yürüterek sonuçları görselleştirme modülüne aktarır.

- `ucus_denklemleri.m`: **Dinamik Model ve Kontrol Mantığı (Dynamic Model & Control Logic)**
  - Simülasyonun her zaman adımında çağrılan temel fonksiyondur. Uçağın 2D nokta kütleli hareket denklemlerini (Equations of Motion) içerir. Aerodinamik kuvvetleri (Kaldırma, Sürükleme), itkiyi ve yerçekimini hesaplayarak durum vektörünün türevlerini (`dydt`) döndürür. Otopilot modu için kapalı çevrim PID kontrol mantığını barındırır.

- `initialize_parameters.m`: **Yapılandırma ve Parametre Yönetimi (Configuration & Parameter Management)**
  - Tüm simülasyon parametrelerinin merkezi olarak tanımlandığı modüldür. Uçak fiziksel özellikleri (kütle, kanat alanı vb.), aerodinamik katsayılar ve otopilot PID kazançları (`Kp`, `Ki`, `Kd`) bu dosyada yapılandırılır. Projenin esnekliğinin ve ayarlanabilirliğinin temelini oluşturur.

- `plot_results.m`: **Veri Görselleştirme Modülü (Data Visualization Module)**
  - Simülasyon yöneticisinden gelen işlenmiş zaman serisi verilerini alır ve kullanıcıya anlamlı grafikler halinde sunar. Bu panel, otopilotun performansını (overshoot, oturma süresi, salınım) analiz etmek ve bir sonraki iterasyon için bilinçli kararlar vermek amacıyla kullanılan temel geri bildirim (feedback) aracıdır.

- `hesapla_isa_yogulugu.m` & `olay_fabrikasi.m`: **Yardımcı ve Güvenlik Modülleri**
  - Bu yardımcı fonksiyonlar, sırasıyla, Uluslararası Standart Atmosfer (ISA) modeline göre anlık hava yoğunluğunu hesaplar ve uçağın yere çarpması gibi olayları tespit ederek simülasyonu güvenli bir şekilde sonlandırır.

### Mevcut Sürümün Kontrol Stratejisi (v1.0)

Bu ilk sürümde, irtifayı kontrol etmek için bilinçli olarak basit bir strateji seçilmiştir: **"İrtifa için Gücü Ayarla" (Power for Altitude).** Otopilot, irtifa hatasını düzeltmek için sadece motor gücünü (gaz kolunu) ayarlar. Bu yaklaşım, PID kontrolünün temellerini anlamak için ideal bir başlangıç noktasıdır, ancak projenin ilerleyen versiyonlarında daha gelişmiş stratejilerle değiştirilmesi planlanmaktadır.

---

## Sonuç: Kurulum, Kullanım ve Gelecek Planları

### Kurulum ve Kullanım

1.  Bu depodaki tüm `.m` dosyalarını bilgisayarınızda tek bir klasöre indirin.
2.  MATLAB programını açın ve bu klasörü "Current Folder" olarak ayarlayın.
3.  MATLAB komut satırına `ucus_simulasyon` yazıp Enter'a basarak simülatörü başlatın.
4.  Ekrana gelen menüden istediğiniz uçuş senaryosunu ve başlangıç koşullarını seçin.

### Yol Haritası (Roadmap)

Bu proje aktif olarak geliştirilmektedir. Gelecek sürümler için planlanan özellikler ve iyileştirmeler:

- [ ] **Yeni Uçak Profilleri:**
    - [ ] İş Jeti (Cessna Citation Benzeri)
    - [ ] KAAN (MMU) 5. Nesil Savaş Uçağı
- [ ] **Gelişmiş Kontrol Stratejileri:**
    - [ ] "İrtifa için Burnunu Ayarla, Hız için Gücü Ayarla" (Pitch for Altitude, Power for Speed) felsefesine geçiş.
- [ ] **Grafiksel Kullanıcı Arayüzü (GUI):**
    - [ ] MATLAB App Designer kullanılarak daha kullanıcı dostu bir arayüz geliştirilmesi.

### Lisans

Bu proje MIT Lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakınız.
