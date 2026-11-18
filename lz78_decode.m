function sequence = lz78_decode(couples)
%LZ78_DECODE Décode une liste de couples LZ78

dict = cell(1,1);
dict{1} = '';

sequence = '';
nextIndex = 2;

for i = 1:length(couples)

    indice = couples{i}{1};
    symbole = couples{i}{2};

    phrase = [dict{indice+1} symbole];

    sequence = [sequence phrase];

    dict{nextIndex} = phrase;
    nextIndex = nextIndex + 1;

end

end