% ucus_olaylari.m

function [value, isterminal, direction] = ucus_olaylari(t, y, params)
% Bu olay fonksiyonu, simülasyon sırasında belirli koşulları denetler.
% Şu anki tek amacı, uçağın yere çarpıp çarpmadığını kontrol etmektir.
%
% GİRDİLER (ode45 tarafından otomatik olarak sağlanır):
%   t     : Mevcut zaman
%   y     : Mevcut durum vektörü [v, gamma, x, h]
%   params: Tüm simülasyon parametrelerini içeren yapı
%
% ÇIKTILAR:
%   value      : MATLAB'in sıfıra ulaşıp ulaşmadığını kontrol edeceği değer.
%                Bizim durumumuzda bu, irtifadır (h).
%   isterminal : Olay gerçekleştiğinde simülasyonun durup durmayacağını
%                belirten bir bayrak (1 = durdur, 0 = devam et).
%   direction  : Olayın sadece belirli bir yönde gerçekleştiğinde
%                tetiklenmesini sağlar (0 = her yönde, 1 = artarken, -1 = azalırken).

    % Durum vektöründen anlık irtifayı al
    h = y(params.indices.h);

    % --- Olay 1: Yere Çarpma ---
    value = h;          % MATLAB'in izleyeceği değer irtifadır. h=0 olduğu an olay gerçekleşir.
    
    isterminal = 1;     % Bu olay gerçekleştiğinde (h=0), simülasyonu DURDUR.
    
    direction = -1;     % Sadece irtifa azalırken (negatif yönde) sıfıra ulaştığında 
                        % olayı tetikle. Bu, uçağın yerden havalanırken (h=0'dan 
                        % artarken) simülasyonu hemen durdurmasını engeller.

end