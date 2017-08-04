[] spawn {
    initMarker = {
        params ["_obj", ["_color", "ColorGrey"], ["_text", ""]];
        _marker = createMarkerLocal [str _obj, getpos _obj];
        _marker setMarkerShapeLocal "ICON";
        _marker setMarkerTypeLocal "mil_dot_noShadow";
        _marker setMarkerAlphaLocal 1;
        _marker setMarkerColorLocal _color;
        _marker setMarkerTextLocal _text;
        _marker
    };

    analyzeRoads = {
        openMap true;

        _mapCenter = [worldSize / 2, worldSize / 2];
        _allRoads = _mapCenter nearRoads worldSize;
        _deadEnds = [];
        _roads = [];
        _intersects = [];
        _output = [];

        {
            _road = _x;
            _nearRoads = roadsConnectedTo _road;
            switch (true) do {
                case (roadAt _road isEqualTo objNull): {
                    if (roadsConnectedTo _road isEqualTo []) then {
                        [_road, "ColorBlue"] call initMarker;
                    } else {
                        [_road, "ColorRed"] call initMarker;
                        _intersects pushBack _road;
                    };
                };
                case (count _nearRoads >= 3): {
                    [_road, "ColorOrange"] call initMarker;
                    _intersects pushBack _road;
                };
                case (count _nearRoads <= 1): {
                    _near = _road nearRoads 20;
                    if (count _near >= 4) then {
                        [_road, "ColorYellow"] call initMarker;
                        _intersects pushBack _road;
                    } else {
                        [_road, "ColorBlack"] call initMarker;
                        _deadEnds pushBack _road;
                    };
                };
                default {
                };
            };
        } forEach _allRoads;

        _findConnection = {
            params [["_callback", {}], ["_parent", objNull], ["_road", objNull], ["_path", []]];

            if (_road in _intersects) exitWith {
                [count _path, 0, _road, _path] call _callback;
            };
            if (_road in _deadEnds) exitWith {
                [count _path, 1, _road, _path] call _callback;
            };
            _markers pushBack (_road call initMarker);
            _path pushBack _road;
            _next = roadsConnectedTo _road;
            _next = _next - (_path + [_parent]);
            [_callback, _parent, _next select 0, _path] call _findConnection;
        };

        {
            systemChat str (_forEachIndex + 1);

            _road = _x;
            _nearRoads = roadsConnectedTo _road;
            if (count _nearRoads <= 1 && _road in _intersects) then {
                _nearRoads = _road nearRoads 20;
            };

            _connections = [];
            {
                _markers = [];
                [{
                    _connections pushBack _this;
                }, _road, _x] call _findConnection;
                {
                    deleteMarkerLocal _x;
                } forEach _markers;
            } forEach _nearRoads;

            _connections sort true;
            if (_road in _intersects) then {
                _output pushBack [0, _road, _connections];
            };
            if (_road in _deadEnds) then {
                _output pushBack [1, _road, _connections];
            };
        } forEach (_intersects + _deadEnds);

        _output sort true;
        {
            deleteMarkerLocal _x;
        } forEach allMapMarkers;
        _output
    };
    if (isNil "streetMap") then {
        streetMap = call analyzeRoads;
    };
    copyToClipboard str ([] + streetMap);
    systemChat "bulding Street-Map done!";

    aStar = {
        if (isNil "markers") then {
            markers = [];
        } else {
            {
                deleteMarkerLocal _x;
            } forEach markers;
        };
        params ["_start", "_goal"];
        _streetMap = ([] + streetMap);
        _markers = [];
        _checked = [];
        _queue = [];
        _startPoint = (([] + _streetMap) apply {[(_x select 1) distance _start, _x]});
        _startPoint sort true;
        _startPoint = (_startPoint select 0) select 1;

        _processPoint = {
            params ["_type", "_point", "_connections", ["_path", []]];
            _path pushBack _point;
            _markers pushBack ([_point, nil, str _point] call initMarker);

            systemChat (str _point);

            _connections = _connections apply {[parseNumber !(_goal in (_x select 3)), _x select 1, (_x select 2) distance _goal, _x, _path + (_x select 3)]};
            _queue append _connections;
            _queue = (([] + _queue) select {!(((_x select 3) select 2) in _checked)});
            _queue sort true;
            if (count _queue == 0) exitWith {
                systemchat "no road found!";
                {
                    deleteMarkerLocal _x;
                } forEach _markers;
            };
            _next = _queue deleteAt 0;

            systemChat (str (count _checked) + " | " + str (count _queue));

            (_next select 3) params ["_length", "_type", "_nextPoint", "_nextPointPath"];
            _checked pushBackUnique _nextPoint;

            _nextPath = _next select 4;
            if ((_next select 0) == 0) exitWith {
                systemChat "found goal!";
                {
                    deleteMarkerLocal _x;
                } forEach _markers;
                {
                    markers pushback (_x call initMarker);
                } forEach _nextPath;
            };

            _nextConnections = (([] + _streetMap) select {_nextPoint in _x});
            _nextParams = (_nextConnections select 0);
            _nextParams pushBack _nextPath;

            _nextParams call _processPoint;
        };
        _startPoint call _processPoint;
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
        _goal = (roadAt _pos);
        _start = (roadAt player);
        if (_start isEqualTo objNull) then {
            _start = [player] call getNearestRoad;
        };
        if (_goal isEqualTo objNull) then {
            _goal = [_pos] call getNearestRoad;
        };
        [_start, _goal] spawn aStar;
    };
};
