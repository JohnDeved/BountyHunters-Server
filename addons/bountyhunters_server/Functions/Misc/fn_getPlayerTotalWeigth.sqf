params ["_items", "_backpack"];

_return = [];
_maxWeigth = 0;
if !(_backpack isEqualTo "") then {
    _maxWeigth = getNumber (missionConfigFile >> "CfgClothing" >> _backpack >> "carryweigth");
} else {
    _maxWeigth = getNumber (missionConfigFile >> "CfgClothing" >> "None" >> "carryweigth");
};
_totalWeigth = 0;
{
    _item = _x select 0;
    _count = _x select 1;
    _itemWeigth = getNumber (missionConfigFile >> "CfgvItems" >> _item >> "weigth");
    _itemWeigth = _itemWeigth * _count;
    _totalWeigth = _totalWeigth + _itemWeigth;
} forEach _items;
_return = [_totalWeigth, _maxWeigth];
_return
