do3DENAction "ToggleMapIDs";
exportSimpelObjects = [];
allSimpelObjects = [];
allHideObjects = [];
allObjects = [];
onEachFrame {
    all3DENEntities params ["_all3DENObjects"];
    _allSelected3DENObjects = get3DENSelected "object";

    {
        if (_x isKindOf "Land_HelipadEmpty_F") then {
            _desc = (_x get3DENAttribute "description") select 0;
            if !(_desc isEqualTo "") then {
                if !(_x in allObjects) then {
                    switch (true) do {
                        case ((_desc find "a3\" != -1) && (_desc find ".p3d" != -1)): {
                            allObjects pushBack _x;
                            allSimpelObjects pushBack [_x, createSimpleObject [_desc, getPosASL _x], _desc];
                        };
                        case ((_desc find "a3\" == -1) && (_desc find ".p3d" != -1)): {
                            _model = (str missionConfigFile select [0, count str missionConfigFile - 15]) + _desc;
                            allObjects pushBack _x;
                            allSimpelObjects pushBack [_x, createSimpleObject [_model, getPosASL _x], _model];
                        };
                        case (_desc find "hide:" != -1): {
                            _objId = parseNumber (_desc select [5]);
                            _obj = (getPosATL _x) nearestObject _objId;
                            _obj hideObject true;
                            allHideObjects pushBack [_x, _obj, _objId];
                            allObjects pushBack _x;
                        };
                    };
                };
            };
        };
    } forEach _allSelected3DENObjects;

    {
        _x params ["_object", "_simpelObject", "_model"];
        if (_object in _all3DENObjects) then {
            if (_object in _allSelected3DENObjects) then {
                _pos = (getPosATL _object);
                _vectorDir = (vectorDir _object);
                _vectorUp = (vectorUp _object);
                _simpelObject setPosATL _pos;
                _simpelObject setVectorDirAndUp [_vectorDir, _vectorUp];
                _object set3DENAttribute ["Init", ("if ((!isMultiplayer) || isServer) then {deleteVehicle this; _sObj = createSimpleObject ['" + _model + "', ATLToASL " + str _pos + "]; _sObj setVectorDirAndUp " + str [_vectorDir, _vectorUp] + "; _sObj setPosATL" + str _pos + "; };")]
            };
        } else {
            allObjects deleteAt (allObjects find _object);
            allSimpelObjects deleteAt _forEachIndex;
            deleteVehicle _simpelObject;
        };
    } forEach allSimpelObjects;

    {
        _x params ["_object", "_hideObject", "_objId"];
        if (_object in _all3DENObjects) then {
            _object set3DENAttribute ["Init", ("if ((!isMultiplayer) || isServer) then {deleteVehicle this}; (" + str (getPosATL _hideObject) + " nearestObject " + str _objId + ") hideObject true;")]
        } else {
            _hideObject hideObject false;
            allObjects deleteAt (allObjects find _object);
            allHideObjects deleteAt _forEachIndex;
        };
    } forEach allHideObjects;
};
