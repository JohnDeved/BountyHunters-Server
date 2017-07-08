params ["_veh"];

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

if (!simulationEnabled cursorObject) exitWith {[_clientOwnerId, "Something went wrong! #1"]call sync_fnc_hint};
if (isNil {_veh getVariable "buyable"}) exitWith {[_clientOwnerId, "Something went wrong! #2"]call sync_fnc_hint};
if (_clientObject distance _veh > 5) exitWith {[_clientOwnerId, ("Something went wrong! #3 " + str (_clientObject distance _veh))]call sync_fnc_hint};

_price = getNumber (missionConfigFile >>  "CfgPrices" >> "Vehicles" >> typeOf _veh >> "price");

if (_price == 0) exitWith {[_clientOwnerId, "Price was not defined! #4"]call sync_fnc_hint};

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;
_money = ["read", ["stats", "Cash", "NOTFOUND"]] call _inidbi;

if ((str _money) == "NOTFOUND") exitWith {[_clientOwnerId, "Could not get Player's Money! #5"]call sync_fnc_hint};
if ((typeName _money) != "SCALAR") exitWith {[_clientOwnerId, "Wrong value Type! #6"]call sync_fnc_hint};
if (_money < _price) exitWith {[_clientOwnerId, "You cant afford that!"]call sync_fnc_hint};

_pos = [];
if !((nearestObjects[(getMarkerPos "vehicleSpawn1"),["Car","Ship","Air"],5]) isEqualTo []) then {
    _pos = (getMarkerPos "vehicleSpawn1") findEmptyPosition [5,15,typeOf _veh];
} else {
    _pos = (getMarkerPos "vehicleSpawn1");
};

if (_pos isEqualTo []) exitWith {[_clientOwnerId, "Something is blocking Spawn!"]call sync_fnc_hint};

["write", ["stats", "Cash", _money - _price]] call _inidbi;
[missionNamespace, ["Cash", _money - _price]] remoteExecCall ["setVariable", _clientOwnerId];

_veh = createVehicle [typeOf _veh, (getMarkerPos "vehicleSpawn1"), [], 0, "NONE"];
_veh setPos _pos;
_veh setVectorUp (surfaceNormal (getMarkerPos "vehicleSpawn1"));
_veh setDir (markerDir "vehicleSpawn1");
/*_veh lock 2;*/

[_clientOwnerId, "purchase was sucessfull!"]call sync_fnc_hint;
