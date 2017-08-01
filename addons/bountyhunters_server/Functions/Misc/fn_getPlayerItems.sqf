params ["_player"];

if (isNil {_player}) exitWith {false};
_inidbi = ["new", getPlayerUID _player] call OO_INIDBI;
_items = ["read", ["stats", "vItems", "NOTFOUND"]] call _inidbi;
if (_items isEqualTo "NOTFOUND") exitWith {false};

_items
