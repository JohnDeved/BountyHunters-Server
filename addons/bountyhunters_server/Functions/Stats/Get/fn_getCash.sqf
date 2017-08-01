params ["_client"];

_inidbi = ["new", getPlayerUID _client] call OO_INIDBI;
_money = ["read", ["stats", "Cash", "NOTFOUND"]] call _inidbi;

if (_money isEqualTo "NOTFOUND") exitWith {"could not get Players Cash! #RC1"};
if ((typeName _money) != "SCALAR") exitWith {"could not get Players Cash! #RC2"};

_money
