params ["_client", "_ammount"];

_inidbi = ["new", getPlayerUID _client] call OO_INIDBI;
_money = ["read", ["stats", "Cash", "NOTFOUND"]] call _inidbi;

if (_money isEqualTo "NOTFOUND") exitWith {"could not get Players Cash! #AC1"};
if ((typeName _money) != "SCALAR") exitWith {"could not get Players Cash! #AC2"};

["write", ["stats", "Cash", _money + _ammount]] call _inidbi;
[missionNamespace, ["Cash", _money + _ammount]] remoteExecCall ["setVariable", owner _client];
