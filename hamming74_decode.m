function [m_decode, c_corrige, syndrome, position] = hamming74_decode(r)

H = [
    1 0 1 1 1 0 0;
    1 1 1 0 0 1 0;
    0 1 1 1 0 0 1
];

syndrome = mod(r * H', 2);

c_corrige = r;
position = 0;

if any(syndrome)

    for i = 1:7

        if isequal(syndrome', H(:,i))

            position = i;
            c_corrige(i) = 1 - c_corrige(i);
            break;

        end
    end
end

m_decode = c_corrige(1:4);

end