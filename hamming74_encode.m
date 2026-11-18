function c = hamming74_encode(m)

G = [
    1 0 0 0 1 1 0;
    0 1 0 0 0 1 1;
    0 0 1 0 1 1 1;
    0 0 0 1 1 0 1
];

c = mod(m * G, 2);

end