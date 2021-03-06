params ["_obj", "_type"];
_item = "";
switch (_type) do {
    case ("ammo"): {
        _item = (typeOf _obj) select [((typeOf _obj) find "_") + 1, count (typeOf _obj)];
        _item = (getarray(configfile >> "CfgWeapons" >> _item >> "Magazines") select 0);
    };
    case ("weapon"): {
        _item = (typeOf _obj) select [((typeOf _obj) find "_") + 1, count (typeOf _obj)];
    };
    case ("attatchment"): {
        _item = (typeOf _obj) select [((typeOf _obj) find "_") + 1, count (typeOf _obj)];
    };
    case ("clothing"): {
        _item = (typeOf _obj) select [((typeOf _obj) find "_") + 1, count (typeOf _obj)];
    };
    case ("headgear"): {
        _item = (typeOf _obj) select [((typeOf _obj) find "_") + 1, count (typeOf _obj)];
    };
    case ("backpack"): {
        _item = [_obj] call misc_fnc_getSimpleObjectClass;
    };
    default {};
};

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

if (!simulationEnabled cursorObject) exitWith {[_clientOwnerId, "Something went wrong! #1"]call sync_fnc_hint};
if (_clientObject distance _obj > 5) exitWith {[_clientOwnerId, ("Something went wrong! #3 " + str (_clientObject distance _obj))]call sync_fnc_hint};
if (_type != "backpack") then {
    if (isNil {_obj getVariable "buyable"}) exitWith {[_clientOwnerId, "Something went wrong! #2"]call sync_fnc_hint};
    if !(_clientObject canAdd  _item) exitWith {[_clientOwnerId, "you dont have enough room to carry this!"]call sync_fnc_hint};
};

_price = 0;

switch (_type) do {
    case ("ammo"): {
        _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Weapons" >> typeOf _obj >> "ammoPrice");
    };
    case ("weapon"): {
        _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Weapons" >> typeOf _obj >> "price");
    };
    case ("attatchment"): {
        _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Attatchments" >> typeOf _obj >> "price");
    };
    case ("clothing"): {
        _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Clothing" >> typeOf _obj >> "price");
    };
    case ("headgear"): {
        _price = getNumber (missionConfigFile >>  "CfgPrices" >> "HeadGear" >> typeOf _obj >> "price");
    };
    case ("backpack"): {
        _price = getNumber (missionConfigFile >>  "CfgPrices" >> "Backpacks" >> _item >> "price");
    };
    default {};
};
if (_price == 0) exitWith {[_clientOwnerId, "Price was not defined! #4"]call sync_fnc_hint};

_money = [_clientObject] call stats_fnc_getCash;
if ((typeName _money) != "SCALAR") exitWith {[_clientOwnerId, (str _money)]call sync_fnc_hint};
if (_money < _price) exitWith {[_clientOwnerId, "You cant afford that!"]call sync_fnc_hint};

[_clientObject, _price] call stats_fnc_removeCash;

if (_type == "backpack") then {
    removeBackpackGlobal _clientObject;
    _clientObject addBackpackGlobal _item;
} else {
    _clientObject addItem _item;
};

[_clientOwnerId, "purchase was sucessfull!"]call sync_fnc_hint;
