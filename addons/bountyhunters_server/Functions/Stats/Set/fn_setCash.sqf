params ["_client", "_ammount"];

_inidbi = ["new", getPlayerUID _client] call OO_INIDBI;
_money = ["read", ["stats", "Cash", "NOTFOUND"]] call _inidbi;

if (_money isEqualTo "NOTFOUND") exitWith {};
if ((typeName _money) != "SCALAR") exitWith {};

["write", ["stats", "Cash", _ammount]] call _inidbi;
[missionNamespace, ["Cash", _ammount]] remoteExecCall ["setVariable", owner _client];
