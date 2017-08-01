params ["_plant"];

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;
if ((str _plant) find ": b_" == -1) exitWith {[_clientOwnerId, "Something went wrong! #487"]call sync_fnc_hint};
if (isNil {varTower getvariable (str _plant)}) exitWith {[_clientOwnerId, "Something went wrong! #488"]call sync_fnc_hint};
_timeStart = (varTower getVariable (str _plant));

if (_timeStart > realServerTime) exitWith {[_clientOwnerId, "Something went wrong! #489"]call sync_fnc_hint};
varTower setVariable [str _plant, nil, true];
