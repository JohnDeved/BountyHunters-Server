params ["_gun", "_type"];
_classname = (typeOf _gun) select [7,count (typeOf _gun)];
_ammo = (getarray(configfile >> "CfgWeapons" >> _classname >> "Magazines") select 0);

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

if (!simulationEnabled cursorObject) exitWith {[_clientOwnerId, "Something went wrong! #1"]call sync_fnc_hint};
if (isNil {_gun getVariable "buyable"}) exitWith {[_clientOwnerId, "Something went wrong! #2"]call sync_fnc_hint};
if (_clientObject distance _gun > 5) exitWith {[_clientOwnerId, ("Something went wrong! #3 " + str (_clientObject distance _gun))]call sync_fnc_hint};

_price = 0;
if (_type == "ammo") then {
    _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Weapons" >> typeOf _gun >> "ammoPrice");
} else {
    _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Weapons" >> typeOf _gun >> "price");
};

if (_price == 0) exitWith {[_clientOwnerId, "Price was not defined! #4"]call sync_fnc_hint};

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;
_money = ["read", ["stats", "Cash", "NOTFOUND"]] call _inidbi;

if ((str _money) == "NOTFOUND") exitWith {[_clientOwnerId, "Could not get Player's Money! #5"]call sync_fnc_hint};
if ((typeName _money) != "SCALAR") exitWith {[_clientOwnerId, "Wrong value Type! #6"]call sync_fnc_hint};
if (_money < _price) exitWith {[_clientOwnerId, "You cant afford that!"]call sync_fnc_hint};

["write", ["stats", "Cash", _money - _price]] call _inidbi;
[missionNamespace, ["Cash", _money - _price]] remoteExecCall ["setVariable", _clientOwnerId];

if (_type == "ammo") then {
    _clientObject addMagazine _ammo;
} else {
    _clientObject addMagazine _ammo;
    _clientObject addWeapon _classname;
};

[_clientOwnerId, "purchase was sucessfull!"]call sync_fnc_hint;
