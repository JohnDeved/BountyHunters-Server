params ["_vItemVar", "_ammount"];
_weigth = getNumber (missionConfigFile >> "CfgvItems" >> _vItemVar >> "weigth");
if (_vItemVar isEqualTo "") exitWith {[_clientOwnerId, "Item Variable was not Defined! " + _vItemVar]call sync_fnc_hint; false};
if (_weigth isEqualTo 0) exitWith {[_clientOwnerId, "Item Variable was not Defined! " + _vItemVar]call sync_fnc_hint; false};
_weigth = _weigth * _ammount;

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;
_items = ["read", ["stats", "vItems", "NOTFOUND"]] call _inidbi;
if (_items isEqualTo "NOTFOUND") exitWith {[_clientOwnerId, "Something went wrong! #8"]call sync_fnc_hint; false};

_backpack = backpack _clientObject;
_weigths = [_items, _backpack] call misc_fnc_getPlayerTotalWeigth;
_weigths params ["_currentWeigth", "_maxWeigth"];
if (_maxWeigth isEqualTo 0) exitWith {[_clientOwnerId, "Carry weigth was not defined! #9"]call sync_fnc_hint; false};
if (_maxWeigth < (_currentWeigth + _weigth)) exitWith {[_clientOwnerId, "You dont have enought room!"]call sync_fnc_hint; false};

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
