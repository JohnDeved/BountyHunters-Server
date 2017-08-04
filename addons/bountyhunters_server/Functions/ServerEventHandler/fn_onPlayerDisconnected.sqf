{
    if (getPlayerUID _x isEqualTo _uid) then {
        _gear = getUnitLoadout _x;
        _pos = getPos _x;
        _dir = getDir _x;

        _inidbi = ["new", getPlayerUID _x] call OO_INIDBI;
        ["write", ["stats", "Gear", _gear]] call _inidbi;
        ["write", ["stats", "SpawnPosition", _pos]] call _inidbi;
        ["write", ["stats", "SpawnRotation", _dir]] call _inidbi;

        deleteVehicle _x;
    };
} forEach playableUnits;
