function event_function_handle = olay_fabrikasi(IDX)
% Ana fonksiyonun içinde tanımlanan bir "iç içe fonksiyon" (nested function)
% Bu iç fonksiyon, dışındaki IDX değişkenine erişebilir.
function [value, isterminal, direction] = ucus_olaylari_nested(t, y)
    h = y(IDX.h); % 'IDX' değişkenini doğrudan kullanır

    % --- Olay 1: Yere Çarpma ---
    value = h;
    isterminal = 1;
    direction = -1;
end

% Oluşturulan iç içe fonksiyonun tutamacını ana programa geri döndür
event_function_handle = @ucus_olaylari_nested;
end