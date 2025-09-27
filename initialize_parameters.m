function params = initialize_parameters()
% REVİZYON: PID kontrolcünün integral terimi için altyapı eklendi.
% Durum vektörü artık 5 elemanlı.

    % --- Durum Vektörü İndeksleri (ode45 için) ---
    % YENİ: Durum vektörüne 5. eleman olarak integral hatası eklendi.
    IDX.v             = 1; % Hız (Velocity)
    IDX.gamma         = 2; % Uçuş Yolu Açısı (Flight Path Angle)
    IDX.x             = 3; % Yatay Pozisyon (Horizontal Position)
    IDX.h             = 4; % İrtifa (Altitude)
    IDX.h_error_int   = 5; % YENİ: İrtifa Hatasının İntegrali
    params.indices = IDX;

    % --- Kayıt (Log) İndeksleri (DEĞİŞMEDİ) ---
    LOG_IDX.v         = 1;
    LOG_IDX.gamma_deg = 2;
    LOG_IDX.x         = 3;
    LOG_IDX.h         = 4;
    LOG_IDX.throttle  = 5;
    LOG_IDX.alpha_deg = 6;
    LOG_IDX.T         = 7;
    params.log_indices = LOG_IDX;

    % --- Simülasyon ve Otopilot Parametreleri ---
    params.sim.mode = 'manual';
    
    % PID Kazanç Katsayıları
    params.autopilot.Kp = 0.012;
    params.autopilot.Ki = 0.00002; % YENİ DEĞER: İntegral kazancını aktive et
    params.autopilot.Kd = 0.5;
    
    params.autopilot.target.h = 2000;

    % --- Uçak Parametreleri (DEĞİŞMEDİ) ---
    params.aircraft.m = 1200;
    params.aircraft.A = 16;
    params.aircraft.CL_alpha = 4.5;
    params.aircraft.CD0 = 0.035;
    params.aircraft.K = 0.055;
    params.aircraft.T_max_sl = 3500;
    params.aircraft.alpha_stall_deg = 16;

    % --- Çevre Parametreleri (DEĞİŞMEDİ) ---
    params.environment.g = 9.81;
end