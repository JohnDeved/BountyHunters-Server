params ["_vars"];

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;

{
    _varName = (configName _x);
    if (_varName in _vars) then {
        _val = ["read", ["stats", _varName, "NOTFOUND"]] call _inidbi;
        if ((str _val) != "NOTFOUND") then {
            [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
        } else {
            _val = [_varName] call sync_fnc_getDefaultValue;
            ["write", ["stats", _varName, _val]] call _inidbi;
            [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
        };
    };
} forEach ("true" configClasses (missionConfigFile >> "CfgVariables" >> "Sync"));
