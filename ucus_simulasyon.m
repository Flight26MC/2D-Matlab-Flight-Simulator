% =========================================================================
% == UÇUŞ SİMÜLATÖRÜ ANA KONTROL SCRİPTİ (MODÜLER YAPI) ===================
% =========================================================================
% REVİZYON: Bu script artık kullanıcıya "Manuel Uçuş" ve "Otopilot"
% modları arasında seçim yapma imkanı sunar ve tüm kontrol girdilerini
% de loglayarak detaylı analiz için hazırlar.

clear; clc; close all;

% --- 1. Adım: Parametrelerin Yüklenmesi ---
params = initialize_parameters();
IDX = params.indices;
LOG_IDX = params.log_indices;

% =========================================================================
% --- 2. Adım: Ana Menü ve Uçuş Modu Seçimi ---
% =========================================================================
while true
    clc;
    fprintf('====== UÇUŞ SİMÜLATÖRÜ ANA MENÜSÜ ======\n\n');
    fprintf('1. Manuel Uçuş (Open-Loop)\n');
    fprintf('2. Otopilot Görevi: İrtifa Sabitleme (Closed-Loop)\n');
    fprintf('3. Uçak Modelini Değiştir\n'); % Bu özellik aynı kalıyor
    fprintf('4. Çıkış\n\n');
    
    choice = input('Lütfen seçiminizi yapın [1, 2, 3, 4]: ');

    % Menüden bir uçuş senaryosu seçilmediyse (3 veya 4 gibi), döngüye devam et
    if isempty(choice) || ~ismember(choice, [1, 2])
        switch choice
            case 3
                % Uçak değiştirme mantığı (Bu bölüm aynı kalıyor)
                clc;
                fprintf('--- UÇAK MODELİ PARAMETRELERİ ---\n');
                % ... (Mevcut 'case 2' kodunuzu buraya kopyalayabilirsiniz) ...
                params.aircraft.m = input(sprintf('Yeni Kütle (kg) [Mevcut: %.0f]: ', params.aircraft.m));
                params.aircraft.A = input(sprintf('Yeni Kanat Alanı (m^2) [Mevcut: %.1f]: ', params.aircraft.A));
                params.aircraft.T_max_sl = input(sprintf('Yeni Maksimum Deniz Seviyesi İtkisi (N) [Mevcut: %.0f]: ', params.aircraft.T_max_sl));
                input('\n--> Parametreler güncellendi. Menüye dönmek için Enter''a basın...', 's');
                continue; % Ana menüye dön
            case 4
                fprintf('\nSimülatör kapatılıyor...\n');
                break; % Ana döngüyü kır ve çık
            otherwise
                input('HATA: Geçersiz seçim. Devam etmek için Enter''a basın...', 's');
                continue; % Ana menüye dön
        end
    end
    
    % =====================================================================
    % --- 3. Adım: Senaryo Parametrelerini ve Başlangıç Koşullarını Ayarla ---
    % =====================================================================
    clc;
    if choice == 1 % MANUEL MOD
        params.sim.mode = 'manual';
        fprintf('--- MANUEL UÇUŞ (OPEN-LOOP) ---\n');
        
        % Kullanıcıdan sabit kontrol girdilerini al
        params.controls.throttle = input('Gaz Kolu Ayarı (0.0-1.0): ');
        alpha_deg = input('Hücum Açısı (derece): ');
        params.controls.alpha = deg2rad(alpha_deg);
        
    else % OTOPİLOT MODU (choice == 2)
        params.sim.mode = 'autopilot';
        fprintf('--- OTOPİLOT: İRTİFA SABİTLEME (CLOSED-LOOP) ---\n');

        % Kullanıcıdan hedef irtifayı al
        params.autopilot.target.h = input('Hedef İrtifa (m): ');
    end
    
    % Ortak başlangıç koşullarını al
    fprintf('\n--- BAŞLANGIÇ KOŞULLARI ---\n');
    v0 = input('Başlangıç Hızı (m/s): ');
    h0 = input('Başlangıç İrtifası (m): ');

    % Başlangıç durum vektörünü oluştur
    y0 = zeros(5, 1);
    y0(IDX.v)     = v0;
    y0(IDX.gamma) = 0;
    y0(IDX.x)     = 0;
    y0(IDX.h)     = h0;
    y0(IDX.h_error_int)   = 0; % YENİ: İntegral hatası her zaman 0'dan başlar

    % =====================================================================
    % --- 4. Adım: Simülasyonu Çalıştır ---
    % =====================================================================
    tspan = [0 10000];
    fprintf('\n--> Simülasyon çalıştırılıyor...\n');
    
    % Olay fonksiyonunu ayarla
    event_handle = olay_fabrikasi(params.indices);
    options = odeset('Events', event_handle);
    
    % Simülasyonu çöz
    [t, y] = ode45(@(t,y) ucus_denklemleri(t, y, params), tspan, y0, options);
    
    fprintf('--> Simülasyon tamamlandı!\n');

    % =====================================================================
    % --- 5. Adım: YENİ BÖLÜM - Veri Toplama ve Loglama ---
    % =====================================================================
    % ode45 sadece durumları (y) döndürür. Kontrol girdilerini ve diğer
    % hesaplanan değerleri almak için, her bir zaman adımı için denklemleri
    % tekrar çağırıp sonuçları bir log matrisinde birleştirmeliyiz.
    
    num_steps = length(t);
    log_data = zeros(num_steps, length(fieldnames(LOG_IDX))); % Log matrisini hazırla
    
    fprintf('--> Veriler işleniyor ve loglanıyor...\n');
    
    for i = 1:num_steps
        % Mevcut durum ve zaman için denklemleri TEKRAR çağır
        % Bu sefer türevlerle ilgilenmiyoruz, sadece hesaplanan değerlerle.
        [dydt_dummy, calculated_values] = ucus_denklemleri_log(t(i), y(i,:)', params);

        % Log matrisinin ilgili satırını doldur
        log_data(i, LOG_IDX.v)         = y(i, IDX.v);
        log_data(i, LOG_IDX.gamma_deg) = rad2deg(y(i, IDX.gamma));
        log_data(i, LOG_IDX.x)         = y(i, IDX.x);
        log_data(i, LOG_IDX.h)         = y(i, IDX.h);
        log_data(i, LOG_IDX.throttle)  = calculated_values.throttle;
        log_data(i, LOG_IDX.alpha_deg) = rad2deg(calculated_values.alpha);
        log_data(i, LOG_IDX.T)         = calculated_values.T;
    end

    % =====================================================================
    % --- 6. Adım: Sonuçları Görselleştir ---
    % =====================================================================
    % Grafik fonksiyonuna artık ham 'y' matrisini değil, işlenmiş ve
    % tüm verileri içeren 'log_data' matrisini gönderiyoruz.
    plot_results(t, log_data, LOG_IDX);
    
    input('\nGrafikleri inceledikten sonra menüye dönmek için Enter''a basın...', 's');
end