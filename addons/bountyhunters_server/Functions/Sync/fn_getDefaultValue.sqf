params ["_varName"];
_val = (missionConfigFile >> "CfgVariables" >> "Sync" >> _varName >> "val");
switch (true) do {
    case (isNumber _val): {_val = getNumber _val};
    case (isText _val): {_val = getText _val};
    case (isArray _val): {_val = getArray _val;};
    default {_val = 0};
};
_val
