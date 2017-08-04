do3DENAction "ToggleMapIDs";
exportSimpelObjects = [];
allSimpelObjects = [];
allHideObjects = [];
allReplaceObjects = [];
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
                        case ((_desc find "a3\" != -1) && (_desc find ".p3d" != -1 && _desc find "replace:" == -1)): {
                            allObjects pushBack _x;
                            allSimpelObjects pushBack [_x, createSimpleObject [_desc, getPosASL _x], _desc];
                        };
                        case ((_desc find "a3\" == -1) && (_desc find ".p3d" != -1) && _desc find "replace:" == -1): {
                            _model = (str missionConfigFile select [0, count str missionConfigFile - 15]) + _desc;
                            allObjects pushBack _x;
                            allSimpelObjects pushBack [_x, createSimpleObject [_model, getPosASL _x], _desc];
                        };
                        case (_desc find "hide:" != -1): {
                            _objId = parseNumber (_desc select [5]);
                            _obj = (getPosATL _x) nearestObject _objId;
                            _obj hideObject true;
                            allHideObjects pushBack [_x, _obj, _objId];
                            allObjects pushBack _x;
                        };
                        case (_desc find "replace:" != -1 && _desc find "|" != -1 && _desc find ".p3d" != -1): {
                            comment "replace:b_vitis_vinifera_f|Models\p_cannabis.p3d";
                            _args = _desc select [8];
                            _find = _args select [0, _args find "|"];
                            _replace = _args select [(_args find "|")+1];
                            _radius = (_x get3DENAttribute "placementRadius") select 0;
                            {
                                if ((str _x) find _find != -1) then {
                                    _pos = (getPosATL _x);
                                    _vectorDir = (vectorDir _x);
                                    _vectorUp = (vectorUp _x);
                                    _x hideObject true;
                                    _simpelObject = objNull;
                                    if (_replace find "a3\" == -1) then {
                                        _simpelObject = createSimpleObject [(str missionConfigFile select [0, count str missionConfigFile - 15]) + _replace, _pos];
                                    } else {
                                        _simpelObject = createSimpleObject [_replace, _pos];
                                    };
                                    _simpelObject setPosATL _pos;
                                    _simpelObject setVectorDirAndUp [_vectorDir, _vectorUp];
                                };
                            } forEach (nearestObjects [getPosATL _x, [], _radius, true]);
                            allReplaceObjects pushBack [_x, _find, _replace, _radius, getPosATL _x];
                            allObjects pushBack _x;
                        };
                    };
                };
            };
        };
    } forEach _allSelected3DENObjects;

    {
        switch (true) do {
            case (_x in allSimpelObjects): {
                _x params ["_object", "_simpelObject", "_model"];
                if (_object in _all3DENObjects) then {
                    if (_object in _allSelected3DENObjects) then {
                        _pos = (getPosATL _object);
                        _vectorDir = (vectorDir _object);
                        _vectorUp = (vectorUp _object);
                        _simpelObject setPosATL _pos;
                        _simpelObject setVectorDirAndUp [_vectorDir, _vectorUp];
                        if (_model find "a3\" != -1) then {
                            _object set3DENAttribute ["Init", ("if ((!isMultiplayer) || isServer) then {deleteVehicle this; _sObj = createSimpleObject ['" +
                            _model + "', ATLToASL " + str _pos + "]; _sObj setVectorDirAndUp " + str [_vectorDir, _vectorUp] + "; _sObj setPosATL" + str _pos + "; };")]
                        } else {
                            _object set3DENAttribute ["Init", ("if ((!isMultiplayer) || isServer) then {deleteVehicle this; _sObj = createSimpleObject [(str missionConfigFile select [0, count str missionConfigFile - 15]) + '" +
                            _model + "', ATLToASL " + str _pos + "]; _sObj setVectorDirAndUp " + str [_vectorDir, _vectorUp] + "; _sObj setPosATL" + str _pos + "; };")]
                        };
                    };
                } else {
                    allObjects deleteAt (allObjects find _object);
                    allSimpelObjects deleteAt _forEachIndex;
                    deleteVehicle _simpelObject;
                };
            };
            case (_x in allHideObjects): {
                _x params ["_object", "_hideObject", "_objId"];
                if (_object in _all3DENObjects) then {
                    _object set3DENAttribute ["Init", ("if ((!isMultiplayer) || isServer) then {deleteVehicle this}; (" + str (getPosATL _hideObject) + " nearestObject " + str _objId + ") hideObject true;")]
                } else {
                    _hideObject hideObject false;
                    allObjects deleteAt (allObjects find _object);
                    allHideObjects deleteAt _forEachIndex;
                };
            };
            case (_x in allReplaceObjects): {
                _x params ["_object", "_find", "_replace", "_radius", "_pos"];
                _object set3DENAttribute ["Init", ("if ((!isMultiplayer) || isServer) then {deleteVehicle this; {" +
                    "if ((str _x) find '" + _find + "' != -1) then {" +
                        "_pos = (getPosATL _x);" +
                        "_vectorDir = (vectorDir _x);" +
                        "_vectorUp = (vectorUp _x);" +
                        "hideObjectGlobal _x;" +
                        "_simpelObject = objNull;" +
                        (call {
                            if (_replace find "a3\" == -1) then {
                                "_simpelObject = createSimpleObject [(str missionConfigFile select [0, count str missionConfigFile - 15]) + '" + _replace + "', _pos];"
                            } else {
                                "_simpelObject = createSimpleObject ['" + _replace + "', _pos];"
                            }
                        }) +
                        "_simpelObject setPosATL _pos;" +
                        "_simpelObject setVectorDirAndUp [_vectorDir, _vectorUp];" +
                    "};" +
                "} forEach (nearestObjects [" + str _pos + ", [], " + str _radius + ", true]);};")];
            };
            default {};
        };
    } forEach (allSimpelObjects + allHideObjects + allReplaceObjects);
};
