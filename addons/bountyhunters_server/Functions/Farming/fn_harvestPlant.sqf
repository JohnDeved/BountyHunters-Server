params ["_plant", "_className", "_name", "_time"];

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


    _plant setDamage 1;
    varTower setVariable [str _plant, (_time + _respawnTime), true];

    _itemCount = round ((random (_maxItems - 1)) + 1);
    [_clientOwnerId, "You harvested " + str _itemCount + " X"]call sync_fnc_hint;
    [_clientObject, "AmovPercMstpSnonWnonDnon_AinvPercMstpSnonWnonDnon_Putdown"] remoteExecCall ["playmove", _clientOwnerId];
};
if ((str _plant) find ": t_" != -1) then {
    //code
};
