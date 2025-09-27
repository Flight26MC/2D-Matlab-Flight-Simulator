function plot_results(t, log_data, LOG_IDX)
% REVİZYON: Bu fonksiyon artık zenginleştirilmiş 'log_data' matrisini alır
% ve 6'lı bir analiz paneli (dashboard) çizer.

figure('Name', 'Simülasyon Sonuçları Dashboard', 'NumberTitle', 'off');

% 1. Uçuş Yörüngesi (x vs h)
subplot(3,2,1);
plot(log_data(:,LOG_IDX.x) , log_data(:,LOG_IDX.h)); 
title('Uçuş Yörüngesi');
xlabel('Yatay Mesafe (m)');
ylabel('İrtifa (m)');
grid on;
axis equal;

% 2. Hız Değişimi (t vs v)
subplot(3,2,2);
plot(t, log_data(:,LOG_IDX.v));
title('Hız Değişimi');
xlabel('Zaman (s)');
ylabel('Hız (m/s)');
grid on;

% 3. İrtifa Değişimi (t vs h)
subplot(3,2,3);
plot(t, log_data(:,LOG_IDX.h));
title('İrtifa Değişimi');
xlabel('Zaman (s)');
ylabel('İrtifa (m)');
grid on;

% 4. Uçuş Yolu Açısı Değişimi (t vs gamma)
subplot(3,2,4);
plot(t, log_data(:,LOG_IDX.gamma_deg)); % Zaten derece cinsinden loglandı
title('Uçuş Yolu Açısı Değişimi');
xlabel('Zaman (s)');
ylabel('Açı (derece)');
grid on;

% --- YENİ GRAFİKLER ---

% 5. Gaz Kolu Değişimi (t vs throttle)
subplot(3,2,5);
plot(t, log_data(:,LOG_IDX.throttle));
title('Gaz Kolu Değişimi (Throttle)');
xlabel('Zaman (s)');
ylabel('Ayar (0-1)');
ylim([-0.1 1.1]); % Eksen limitlerini ayarla
grid on;

% 6. Hücum Açısı Değişimi (t vs alpha)
subplot(3,2,6);
plot(t, log_data(:,LOG_IDX.alpha_deg)); % Zaten derece cinsinden loglandı
title('Hücum Açısı Değişimi');
xlabel('Zaman (s)');
ylabel('Açı (derece)');
grid on;

end