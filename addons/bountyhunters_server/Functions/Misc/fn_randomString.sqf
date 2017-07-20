_length = 100;
_arr = [];
for "_i" from 1 to _length do {
    _letter = toString [(0x41 + (random 25))];
    _arr pushBack (selectRandom [_letter, toLower _letter]);
};
_arr joinString ""
