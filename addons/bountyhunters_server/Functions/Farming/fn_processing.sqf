params ["_processorObj"];

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

_processorType = _processorObj getVariable "processor";

_config = (missionConfigFile >> "CfgProcessors" >> _processorType);
_processInput = getText (_config >> "processinput");
_processTime = getNumber (_config >> "processtime");
_processInputAmmount = getNumber (_config >> "processinputammount");
_displayName = getText (_config >> "displayname");
_vItemVar = getText (_config >> "variable");

_items = [_clientObject] call misc_fnc_getPlayerItems;
if (_items isEqualTo false) exitWith {[_clientOwnerId, "couldnt get player's items! #1"]call sync_fnc_hint};

diag_log _items;

_inputItem = "";
_inputItemAmmount = 0;
{
    if ((_x select 0) isEqualTo _processInput) then {
        _inputItem = _x select 0;
        _inputItemAmmount = _x select 1;
    };
} forEach _items;

if (_inputItem isEqualTo "") exitWith {[_clientOwnerId, "You dont have any " + _processInput + "!"]call sync_fnc_hint};
if (_processInputAmmount > _inputItemAmmount) exitWith {[_clientOwnerId, "You dont have enougth " + _processInput + "!"]call sync_fnc_hint};

_inputLeftovers = _inputItemAmmount % _processInputAmmount;
_returnAmmount = (_inputItemAmmount - _inputLeftovers) / _processInputAmmount;

_itemReturn = [_inputItem, _items] call misc_fnc_findItem;
_itemIndex = _itemReturn select 1;

_items set [_itemIndex, [_inputItem, _inputLeftovers]];

_itemReturn2 = [_vItemVar, _items] call misc_fnc_findItem;
if (_itemReturn2 isEqualTo []) then {
    _items pushBack [_vItemVar, _returnAmmount];
} else {
    _itemIndex2 = _itemReturn2 select 1;
    _items set [_itemIndex2, [_vItemVar, _returnAmmount]];
};

[_clientOwnerId, ("You Processed " + str (_inputItemAmmount - _inputLeftovers) + " into " + str _returnAmmount + " " + _vItemVar + "!")]call sync_fnc_hint;

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;
["write", ["stats", "vItems", _items]] call _inidbi;
[missionNamespace, ["vItems", _items]] remoteExecCall ["setVariable", _clientOwnerId];
