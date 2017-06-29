params ["_varName"];
_val = false;

if (isNumber (missionConfigFile >> "CfgVariables" >> "Sync" >> _varName >> "val")) then {
    _val = getNumber (missionConfigFile >> "CfgVariables" >> "Sync" >> _varName >> "val");
};
if (isText (missionConfigFile >> "CfgVariables" >> "Sync" >> _varName >> "val")) then {
    _val = getText (missionConfigFile >> "CfgVariables" >> "Sync" >> _varName >> "val");
};
_val
