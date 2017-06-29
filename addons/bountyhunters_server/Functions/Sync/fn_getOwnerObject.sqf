params ["_ownerId"];

_object = objNull;
{
    if (_ownerId == owner _x) then {
        _object = _x;
    };
} forEach playableUnits;
_object
