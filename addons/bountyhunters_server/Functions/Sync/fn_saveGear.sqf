{
    if (getPlayerUID _x isEqualTo _uid) then {
        _gear = getUnitLoadout _x;

        _inidbi = ["new", getPlayerUID _x] call OO_INIDBI;
        ["write", ["stats", "Gear", _gear]] call _inidbi;

        deleteVehicle _x;
    };
} forEach playableUnits;
