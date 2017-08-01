params ["_item", "_items"];
_return = [];
{
    if (_item in _x) then {
        _return = [_x, _forEachIndex]
    };
} forEach _items;
_return
