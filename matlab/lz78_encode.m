function couples = lz78_encode(sequence)
%LZ78_ENCODE Encode une séquence avec LZ78
% Sortie : couples{i} = {indice, symbole}

sequence = char(sequence);

dict = containers.Map;
dict('') = 0;

couples = {};
phrase = '';
nextIndex = 1;

i = 1;

while i <= length(sequence)

    symbole = sequence(i);

    candidat = [phrase symbole];

    if isKey(dict, candidat)

        phrase = candidat;
        i = i + 1;

    else

        indice = dict(phrase);

        couples{end+1,1} = {indice, symbole};

        dict(candidat) = nextIndex;
        nextIndex = nextIndex + 1;

        phrase = '';
        i = i + 1;

    end
end

% Si une phrase connue reste à la fin
if ~isempty(phrase)
    indice = dict(phrase);

    couples{end+1,1} = {indice, ''};
end

end