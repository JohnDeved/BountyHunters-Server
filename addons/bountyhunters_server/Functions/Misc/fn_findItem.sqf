params ["_item", "_items"];
diag_log _this;
_return = [];
{
    diag_log _x;
    if (_item in _x) then {
        _return = [_x, _forEachIndex]
    };
} forEach _items;
_return
