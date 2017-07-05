params ["_vars"];

_clientOwnerId = remoteExecutedOwner;
_clientObject = [_clientOwnerId]call sync_fnc_getOwnerObject;

_inidbi = ["new", getPlayerUID _clientObject] call OO_INIDBI;

{
    _varName = (configName _x);
    if (_varName in _vars) then {
        _random = str random 1;
        _val = ["read", ["stats", _varName, ("_NOTFOUND_" + _random)]] call _inidbi;
        if !(_val isEqualTo ("_NOTFOUND_" + _random)) then {
            switch (_varName) do {
                case ("Gear"): {
                    _clientObject setUnitLoadout _val;
                    [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
                };
                case ("vItems"): {
                    [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
                };
                default {
                    [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
                };
            };
        } else {
            _val = [_varName] call sync_fnc_getDefaultValue;
            if !(_val isEqualTo 0 || _val isEqualTo "" || _val isEqualTo []) then {
                switch (_varName) do {
                    case ("Gear"): {
                        _val = getUnitLoadout (configFile >> "CfgVehicles" >> (selectRandom _val));
                        _clientObject setUnitLoadout _val;
                        ["write", ["stats", _varName, _val]] call _inidbi;
                        [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
                    };
                    case ("vItems"): {
                        ["write", ["stats", _varName, []]] call _inidbi;
                        [missionNamespace, [_varName, []]] remoteExecCall ["setVariable", _clientOwnerId];
                    };
                    default {
                        ["write", ["stats", _varName, _val]] call _inidbi;
                        [missionNamespace, [_varName, _val]] remoteExecCall ["setVariable", _clientOwnerId];
                    };
                };
            };
        };
    };
} forEach ("true" configClasses (missionConfigFile >> "CfgVariables" >> "Sync"));
