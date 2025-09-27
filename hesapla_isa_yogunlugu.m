% hesapla_isa_yogunlugu.m

function rho = hesapla_isa_yogunlugu(h)
% Bu fonksiyon, verilen geometrik irtifaya (h) göre Uluslararası Standart
% Atmosfer (ISA) modelini kullanarak hava yoğunluğunu (rho) hesaplar.
%
% GİRDİ:
%   h   : Geometrik irtifa (metre)
%
% ÇIKTI:
%   rho : Hava yoğunluğu (kg/m^3)
%
% Model, 20 km irtifaya kadar olan Troposfer ve Stratosfer katmanlarını
% dikkate alır. Daha yüksek irtifalar için modelin genişletilmesi gerekir.

    % --- ISA Model Sabitleri ---
    R = 287.058;     % Özgül gaz sabiti (J/(kg·K))
    g0 = 9.80665;    % Deniz seviyesi yerçekimi ivmesi (m/s^2)
    
    % Deniz Seviyesi (SL) Şartları
    T0 = 288.15;     % Sıcaklık (K)
    P0 = 101325;     % Basınç (Pa)
    rho0 = 1.225;    % Yoğunluk (kg/m^3)
    
    % Katman Bilgileri
    h_tropopoz = 11000; % Troposferin bittiği irtifa (m)
    T_tropopoz = 216.65; % Tropopozdaki sıcaklık (K)
    
    L = -0.0065;     % Sıcaklık değişim oranı (Lapse Rate) (K/m)

    % --- Hesaplama ---
    if h <= h_tropopoz
        % TROPOSFER (0 <= h <= 11000 m)
        % Sıcaklık, irtifa ile doğrusal olarak azalır.
        T = T0 + L * h;
        
        % Basınç ve yoğunluk formülleri
        P = P0 * (T / T0)^(-g0 / (L * R));
        
    else
        % STRATOSFER (11000 m < h <= 20000 m)
        % Sıcaklık bu katmanda sabit kabul edilir.
        T = T_tropopoz;
        
        % Tropopozdaki basıncı hesapla (geçiş noktası)
        P_tropopoz = P0 * (T_tropopoz / T0)^(-g0 / (L * R));
        
        % Basınç, irtifa ile üssel olarak azalır.
        P = P_tropopoz * exp(-g0 * (h - h_tropopoz) / (R * T));
    end
    
    % İdeal Gaz Yasası'ndan yoğunluğu hesapla: rho = P / (R * T)
    rho = P / (R * T);

end


