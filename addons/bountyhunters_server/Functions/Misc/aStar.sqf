markers = [];
drawDirections = {
    params [["_start", objNull], ["_goal", objNull], ["_lazy", false]];
    _startTime = time;
    _checked = [];
    _queue = [];
    _deadEnds = [];
    if (_goal isEqualTo objNull || _start isEqualTo objNull) exitWith {
        systemchat "goal or start not on road!";
    };

    _createMarker = {
        params ["_obj", ["_color", "ColorWhite"]];
        _marker = createMarkerLocal [str _obj, getpos _obj];
        _marker setMarkerShapeLocal "ICON";
        _marker setMarkerTypeLocal "mil_dot_noShadow";
        _marker setMarkerAlphaLocal 1;
        _marker setMarkerColorLocal _color;
        _marker
    };

    _drawRoute = {
        params ["_road", ["_path", []]];

        systemchat ("found goal in " + str (time - _startTime) + "sec!");
        {
            deleteMarkerLocal _x;
        } forEach markers;
        {
            markers pushBack ([_x, "ColorGreen"] call _createMarker);
        } forEach _path;
    };

    _timeOut = {
        systemchat ("time out!");
        {
            deleteMarkerLocal _x;
        } forEach markers;
    };

    _analyzeRoad = {
        params ["_road", "_roads"];
        if (_roads isEqualTo []) exitWith {
            _deadEnds pushBack _road;
            markers pushBack ([_road, "ColorGrey"] call _createMarker);
        };
        if (count _roads > 1) exitWith {
            markers pushBack ([_road, "ColorYellow"] call _createMarker);
        };
        markers pushBack (_road call _createMarker);
    };

    _processRoad = {
        params ["_road", ["_path", []]];
        _time = time;
        _path pushback _road;
        _checked pushBackUnique _road;
        _apply = {};

        if (_road isEqualTo _goal) exitWith {
            _this call _drawRoute;
        };
        if ((time - _startTime) > 5) exitWith {
            call _timeOut;
        };
        if (_lazy) then {
            _apply = {[(_x distance2D _goal), [_x, [] + _path]]};
        } else {
            _apply ={[(_x distance2D _goal) * (count ([] + _path)), [_x, [] + _path]]};
        };

        _roads = roadsConnectedTo _road;
        _roads = _roads - _checked;
        [_road, _roads] call _analyzeRoad;
        _queue append (_roads apply _apply);
        _queue sort true;
        _next = _queue deleteAt 0;
        systemchat (str (count _checked) + ":" + str (count _queue) + " processed in " + str (time - _time) + "sec");
        (_next select 1) call _processRoad;
    };

    _start call _processRoad;
};

getNearestRoad = {
    params [["_position", []], ["_radius", 50]];
    _nearRoad = _position nearRoads _radius;
    if !(_nearRoad isEqualTo []) then {
        _nearRoad = (_nearRoad apply {[(_x distance2D _position), _x]});
        _nearRoad sort true;
        _nearRoad = (_nearRoad select 0) select 1;
    } else {
        _nearRoad = [_position, (_radius + 50)] call getNearestRoad;
    };
    _nearRoad
};

onMapSingleClick {
    {
        deleteMarkerLocal _x;
    } forEach markers;
    _goal = (roadAt _pos);
    _start = (roadAt player);
    if (_start isEqualTo objNull) then {
        _start = [player] call getNearestRoad;
    };
    if (_goal isEqualTo objNull) then {
        _goal = [_pos] call getNearestRoad;
    };
    [_start, _goal, ((roadAt player) distance (roadAt _pos)) > 5000] spawn drawDirections;
};
