params ["_items", "_backpack"];

_return = [];
_maxWeigth = getNumber (missionConfigFile >> "CfgClothing" >> "Backpacks" >> _backpack >> "carryweigth");
_totalWeigth = 0;
{
    _item = _x select 0;
    _count = _x select 1;
    _className = "";
    {
        _harvest = getText (_x >> "harvest");
        if (_harvest isEqualTo _item) then {
            _className = configName _x;
        };
    } forEach ("true" configClasses (missionConfigFile >> "CfgPlants" >> "Bushes"));
    _itemWeigth = getNumber (missionConfigFile >> "CfgPlants" >> "Bushes" >> _className >> "weigth");
    _itemWeigth = _itemWeigth * _count;
    _totalWeigth = _totalWeigth + _itemWeigth;
} forEach _items;
_return = [_totalWeigth, _maxWeigth];
_return
