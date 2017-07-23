markers = [];
drawDirections = {
    params [["_start", objNull], ["_goal", objNull]];
    _startTime = time;
    _checked = [];
    _queue = [];
    _found = false;
    if (_goal isEqualTo objNull || _start isEqualTo objNull) exitWith {
        systemchat "goal or start not on road!";
    };

    _createMarker = {
        params ["_obj", ["_color", "ColorGrey"]];
        _marker = createMarkerLocal [str _obj, getpos _obj];
        _marker setMarkerShapeLocal "ICON";
        _marker setMarkerTypeLocal "hd_dot";
        _marker setMarkerAlphaLocal 0.5;
        _marker setMarkerColorLocal _color;
        _marker
    };

    _drawRoute = {
        params ["_road", ["_path", []]];

        systemchat ("found goal in " + str (time - _startTime) + "sec!");
        _found = true;
        {
            deleteMarkerLocal _x;
        } forEach markers;
        {
            markers pushBack (_x call _createMarker);
        } forEach (_checked select {!(_x in _path)});
        {
            markers pushBack ([_x, "ColorGreen"] call _createMarker);
        } forEach _path;
    };

    _processRoad = {
        params ["_road", ["_path", []]];
        _time = time;
        _path pushback _road;
        _checked pushBackUnique _road;

        markers pushBack (_road call _createMarker);
        if (_road isEqualTo _goal) exitWith {
            _this call _drawRoute;
        };

        _roads = roadsConnectedTo _road;
        _roads = _roads - _checked;
        _queue append (_roads apply {[(_x distance2D _goal) * (count ([] + _path)), [_x, [] + _path]]});
        _queue sort true;
        _next = _queue deleteAt 0;
        systemchat (str (count _checked) + ":" + str (count _roads) + " processed in " + str (time - _time) + "sec");
        (_next select 1) call _processRoad;
    };

    _start call _processRoad;
};

onMapSingleClick {
    {
        deleteMarkerLocal _x;
    } forEach markers;
    [roadAt player, roadAt _pos] spawn drawDirections;
};
