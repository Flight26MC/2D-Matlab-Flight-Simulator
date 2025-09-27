function [dydt, calculated_values] = ucus_denklemleri_log(t, y, params)
% REVİZYON: Bu fonksiyon da artık tam PID kontrolcü içerir ve 5 durumun
% türevini döndürürken, loglama için ek veriler üretir.

% --- Parametreleri ve İndeksleri yapıdan çıkar ---
m               = params.aircraft.m;
A               = params.aircraft.A;
CL_alpha        = params.aircraft.CL_alpha;
CD0             = params.aircraft.CD0;
K               = params.aircraft.K;
T_max_sl        = params.aircraft.T_max_sl;
alpha_stall_deg = params.aircraft.alpha_stall_deg;
g               = params.environment.g;
IDX             = params.indices;

% --- Simülasyon Modunu ve Otopilot Parametrelerini Al ---
sim_mode      = params.sim.mode;
Kp            = params.autopilot.Kp;
Ki            = params.autopilot.Ki;
Kd            = params.autopilot.Kd;
target_h      = params.autopilot.target.h;

% --- Anlık Durum Değişkenlerini Al ---
v           = y(IDX.v);
gamma       = y(IDX.gamma);
h           = y(IDX.h);
h_error_int = y(IDX.h_error_int);

% =========================================================================
% === GÜNCELLENMİŞ KONTROL MANTIĞI: Tam PID-Kontrolcü ======================
% =========================================================================
if strcmp(sim_mode, 'manual')
    throttle = params.controls.throttle;
    alpha    = params.controls.alpha;
    error_h = 0;
else % autopilot
    % --- 1. HATA ve HATA TÜREVİ HESAPLAMASI ---
    error_h = target_h - h;
    error_h_dot = - (v * sin(gamma));
    
    % --- 2. PID-KONTROLCÜ MANTIĞI ---
    p_term = Kp * error_h;
    i_term = Ki * h_error_int;
    d_term = Kd * error_h_dot;
    
    throttle_cmd = p_term + i_term + d_term;
    
    % --- 3. KONTROL ÇIKTISINI SINIRLANDIRMA (Saturation) ---
    throttle = max(0, min(1, throttle_cmd));
    
    alpha = deg2rad(5); 
end
% =========================================================================

% --- Çevre, Motor ve Aerodinamik Modelleri ---
rho0 = 1.225;
rho = hesapla_isa_yogunlugu(h);
T = throttle * T_max_sl * (rho / rho0);
alpha_stall_rad = deg2rad(alpha_stall_deg);
if abs(alpha) < alpha_stall_rad
    CL = CL_alpha * alpha;
else
    CL = CL_alpha * alpha_stall_rad * sign(alpha) * 0.7;
end
CD = CD0 + K * CL^2;
L = 0.5 * rho * v^2 * A * CL;
D = 0.5 * rho * v^2 * A * CD;

% --- Hareket Denklemleri (4 adet) ---
dv_dt = (T * cos(alpha) - D - m * g * sin(gamma)) / m;
dgamma_dt = (T * sin(alpha) + L - m * g * cos(gamma)) / (m * v);
dx_dt = v * cos(gamma);
dh_dt = v * sin(gamma);

% --- YENİ 5. DENKLEM: İntegral Hatasının Türevi ---
d_h_error_int_dt = error_h;

% --- Çıktı Vektörünü Oluştur (Artık 5 elemanlı) ---
dydt = zeros(5, 1);
dydt(IDX.v)             = dv_dt;
dydt(IDX.gamma)         = dgamma_dt;
dydt(IDX.x)             = dx_dt;
dydt(IDX.h)             = dh_dt;
dydt(IDX.h_error_int)   = d_h_error_int_dt;

% --- HESAPLANAN DEĞERLERİ LOGLAMA İÇİN PAKETLE ---
calculated_values.throttle = throttle;
calculated_values.alpha    = alpha;
calculated_values.T        = T;

end