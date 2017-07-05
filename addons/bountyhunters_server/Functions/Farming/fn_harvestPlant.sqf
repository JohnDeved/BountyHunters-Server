params ["_plant", "_className", "_name", "_time"];
diag_log _className;

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

if !(typeof _plant == "") exitWith {[_clientOwnerId, "Something went wrong! #1"]call sync_fnc_hint};
if !((str _plant) find _className != -1) exitWith {[_clientOwnerId, "Something went wrong! #2"]call sync_fnc_hint};
if !(getDammage _plant == 0) exitWith {[_clientOwnerId, "Something went wrong! #3"]call sync_fnc_hint};
if !((_clientObject distance _plant) < 5) exitWith {[_clientOwnerId, "Something went wrong! #4"]call sync_fnc_hint};
if !(isNil {varTower getvariable (str _plant)}) exitWith {[_clientOwnerId, "Something went wrong! #5"]call sync_fnc_hint};

if ((str _plant) find ": b_" != -1) then {
    _respawnTime = getNumber (missionConfigFile >> "CfgPlants" >> "Bushes" >> _className >> "respawntime");
    if (_respawnTime == 0) exitWith {[_clientOwnerId, "respawntime was not defined! #6"]call sync_fnc_hint};
    _maxItems = getNumber (missionConfigFile >> "CfgPlants" >> "Bushes" >> _className >> "maxitems");
    if (_maxItems == 0) exitWith {[_clientOwnerId, "maxitems was not defined! #7"]call sync_fnc_hint};

    _harvest = getText (missionConfigFile >> "CfgPlants" >> "Bushes" >> _className >> "harvest");
    diag_log _harvest;
    _itemCount = round ((random (_maxItems - 1)) + 1);
    _weigth = getNumber (missionConfigFile >> "CfgPlants" >> "Bushes" >> _className >> "weigth");
    _weigth = _weigth * _itemCount;

    _inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;
    _items = ["read", ["stats", "vItems", "NOTFOUND"]] call _inidbi;
    if (_items isEqualTo "NOTFOUND") exitWith {[_clientOwnerId, "Something went wrong! #8"]call sync_fnc_hint};

    _backpack = backpack _clientObject;
    if (_backpack isEqualTo "") exitWith {[_clientOwnerId, "You cant carry this without a Backpack!"]call sync_fnc_hint};

    _weigths = [_items, _backpack] call misc_fnc_getPlayerTotalWeigth;
    _currentWeigth = _weigths select 0;
    _carryWeigth = _weigths select 1;
    if (_carryWeigth isEqualTo 0) exitWith {[_clientOwnerId, "Carry weigth was not defined! #9"]call sync_fnc_hint};
    if (_carryWeigth < (_currentWeigth + _weigth)) exitWith {[_clientOwnerId, "You dont have enought room!"]call sync_fnc_hint};

    diag_log _harvest;
    _return = [_harvest, _items] call misc_fnc_findItem;
    diag_log _harvest;
    if (_return isEqualTo []) then {
        _items pushBack [_harvest, _itemCount];
        ["write", ["stats", "vItems", _items]] call _inidbi;
        [missionNamespace, ["vItems", _items]] remoteExecCall ["setVariable", _clientOwnerId];
    } else {
        _vitemArr = _return select 0;
        _index = _return select 1;
        _vitem = _vitemArr select 0;
        _vitemCount = _vitemArr select 1;
        _vitemCount = _itemCount + _vitemCount;
        _items set [_index, [_harvest, _vitemCount]];
        ["write", ["stats", "vItems", _items]] call _inidbi;
        [missionNamespace, ["vItems", _items]] remoteExecCall ["setVariable", _clientOwnerId];
    };

    diag_log _harvest;
    [_clientOwnerId, "You harvested " + str _itemCount + " " + _harvest]call sync_fnc_hint;
    _plant setDamage 1;
    varTower setVariable [str _plant, (_time + _respawnTime), true];

    [_clientObject, "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExecCall ["playmove", _clientOwnerId];
};
if ((str _plant) find ": t_" != -1) then {
    //code
};
