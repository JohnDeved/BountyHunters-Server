params ["_config", "_ammount"];
_vItemVar = getText (_config >> "variable");
_weigth = getNumber (_config >> "weigth");
if (_vItemVar isEqualTo "") exitWith {[_clientOwnerId, "Item Variable was not Defined! " + str _config]call sync_fnc_hint; false};
if (_weigth isEqualTo 0) exitWith {[_clientOwnerId, "Item Variable was not Defined! " + str _config]call sync_fnc_hint; false};
_weigth = _weigth * _ammount;

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;
_items = ["read", ["stats", "vItems", "NOTFOUND"]] call _inidbi;
if (_items isEqualTo "NOTFOUND") exitWith {[_clientOwnerId, "Something went wrong! #8"]call sync_fnc_hint; false};

_backpack = backpack _clientObject;
if (_backpack isEqualTo "") exitWith {[_clientOwnerId, "You cant carry this without a Backpack!"]call sync_fnc_hint; false};

_weigths = [_items, _backpack] call misc_fnc_getPlayerTotalWeigth;
_currentWeigth = _weigths select 0;
_carryWeigth = _weigths select 1;
if (_carryWeigth isEqualTo 0) exitWith {[_clientOwnerId, "Carry weigth was not defined! #9"]call sync_fnc_hint; false};
if (_carryWeigth < (_currentWeigth + _weigth)) exitWith {[_clientOwnerId, "You dont have enought room!"]call sync_fnc_hint; false};

_return = [_vItemVar, _items] call misc_fnc_findItem;
if (_return isEqualTo []) then {
    _items pushBack [_vItemVar, _ammount];
    ["write", ["stats", "vItems", _items]] call _inidbi;
    [missionNamespace, ["vItems", _items]] remoteExecCall ["setVariable", _clientOwnerId];
} else {
    _vitemArr = _return select 0;
    _index = _return select 1;
    _vitem = _vitemArr select 0;
    _vitemCount = _vitemArr select 1;
    _vitemCount = _ammount + _vitemCount;
    _items set [_index, [_vItemVar, _vitemCount]];
    ["write", ["stats", "vItems", _items]] call _inidbi;
    [missionNamespace, ["vItems", _items]] remoteExecCall ["setVariable", _clientOwnerId];
};
true
