CODI_Path_markers = [];
CODI_Path_markersLocal = [];
CODI_Path_variables = [];
CODI_Path_fnc_aStar = {
	params["_src","_dst"];
	private _closed = [];
	private _open = [_src];
	missionNamespace setVariable ["CODI_Path_g_" + str _src, 0];
	CODI_Path_variables pushBack ("CODI_Path_g_" + str _src);
	missionNamespace setVariable ["CODI_Path_f_" + str _src, [_src, _dst] call CODI_Path_fnc_h];
	CODI_Path_variables pushBack ("CODI_Path_f_" + str _src);
	while {!(_open isEqualTo [])} do
	{
		private _current = objNull;
		{
			if ((missionNamespace getVariable ["CODI_Path_f_" + str _x, 999999]) < (missionNamespace getVariable ["CODI_Path_f_" + str _current, 999999])) then
			{
				_current = _x;
			};
			nil
		}
		count _open;
		if (_current == _dst) exitWith
		{
			[_dst] call CODI_Path_fnc_mark;
		};
		_open = _open - [_current];
		_closed pushBack _current;
		private _roads = roadsConnectedTo _current;
		{
			if (_x != _current) then
			{
				_roads pushBackUnique _x;
			};
			nil
		}
		count ((getPos _current) nearRoads 20);
		{
			if (!(_x in _closed)) then
			{
				private _tentativeG = (missionNamespace getVariable ["CODI_Path_g_" + str _current, 999999]) + ([_current, _x] call CODI_Path_fnc_cost);
				private _continue = false;
				if (!(_x in _open)) then
				{
					_open pushBack _x;
				}
				else
				{
					if (_tentativeG >= (missionNamespace getVariable ["CODI_Path_g_" + str _x, 999999])) then
					{
						_continue = true;
					};
				};
				if (!_continue) then
				{
					private _marker = createMarkerLocal [str _x, getPos _x];
					_marker setMarkerShapeLocal "ICON";
					_marker setMarkerColorLocal "ColorWEST";
					_marker setMarkerTypeLocal "MIL_DOT";
					_marker setMarkerAlphaLocal 0.25;
					CODI_Path_markersLocal pushBack _marker;
					missionNamespace setVariable ["CODI_Path_parent_" + str _x, _current];
					CODI_Path_variables pushBack ("CODI_Path_parent_" + str _x);
					missionNamespace setVariable ["CODI_Path_g_" + str _x, _tentativeG];
					CODI_Path_variables pushBack ("CODI_Path_g_" + str _x);
					missionNamespace setVariable ["CODI_Path_f_" + str _x, (missionNamespace getVariable ["CODI_Path_g_" + str _x, 999999]) + ([_x, _dst] call CODI_Path_fnc_h)];
					CODI_Path_variables pushBack ("CODI_Path_f_" + str _x);
				};
			};
			nil
		}
		count _roads;
	};
};
CODI_Path_fnc_h = {
	params["_src","_dst"];
	private _dist = ((getPos _src) distance (getPos _dst))*1.5;
	_dist
};
CODI_Path_fnc_cost = {
	params["_src","_dst"];
	private _dist = ((getPos _src) distance (getPos _dst))*1;
	_dist
};
CODI_Path_fnc_mark = {
	{
		deleteMarkerLocal _x;
		nil
	}
	count CODI_Path_markersLocal;
	CODI_Path_markersLocal = [];
	private _dst = param[0, objNull];
	private _marker = createMarker [str _dst, getPos _dst];
	_marker setMarkerShape "ICON";
	_marker setMarkerColor "ColorWEST";
	_marker setMarkerType "MIL_DOT";
	CODI_Path_markers pushBack _marker;
	while {!isNull _dst} do
	{
		if ((getMarkerPos _marker) distance2d (getPos _dst) > 75) then
		{
			_marker = createMarker [str _dst, getPos _dst];
			_marker setMarkerShape "ICON";
			_marker setMarkerColor "ColorWEST";
			_marker setMarkerType "MIL_DOT";
		};
		CODI_Path_markers pushBack _marker;
		_dst = missionNamespace getVariable ["CODI_Path_parent_" + str _dst, objNull];
	};
};
CODI_Path_fnc_calcRoute = {
	params["_src","_dst"];
	private _srcRoad = [_src] call CODI_Path_fnc_getNearestRoad;
	private _dstRoad = [_dst] call CODI_Path_fnc_getNearestRoad;
	if (isNull _srcRoad || isNull _dstRoad) exitWith {hint "src or dst not close to a road"};
	[_srcRoad, _dstRoad] call CODI_Path_fnc_aStar;
};
CODI_Path_fnc_removeMarkers = {
	{
		deleteMarker _x;
		nil
	}
	count CODI_Path_markers;
	CODI_Path_markers = [];
	{
		missionNamespace setVariable[_x, nil];
		nil
	}
	count CODI_Path_variables;
	CODI_Path_variables = [];
};
CODI_Path_fnc_start = {
    ["CODI_Path_mapClick", "onMapSingleClick",{
        [getPos player, _pos] spawn CODI_Path_fnc_calcRoute;
		openMap false;
    }] call BIS_fnc_addStackedEventHandler;
    openMap true;
    [] spawn {
        waitUntil{!visibleMap};
        ["CODI_Path_mapClick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
    };
};
CODI_Path_fnc_getNearestRoad = {
    params["_pos"];
    private _roads = _pos nearRoads 1000;
    if (_roads isEqualTo []) exitWith {objNull};
    private _road = _roads deleteAt 0;
    {
        if (((getPos _x) distance2d _pos) < ((getPos _road) distance2d _pos)) then
		{
            _road = _x;
        };
		nil
    }
	count _roads;
    _road
};
player addAction["Calculate Route", {call CODI_Path_fnc_start;}, [], 0, false, true, "", "count CODI_Path_markers == 0"];
player addAction["Delete Route", {call CODI_Path_fnc_removeMarkers;}, [], 0, false, true, "", "count CODI_Path_markers > 0"];
player addEventHandler ["Respawn", {
	player addAction["Calculate Route", {call CODI_Path_fnc_start;}, [], 0, false, true, "", "count CODI_Path_markers == 0"];
	player addAction["Delete Route", {call CODI_Path_fnc_removeMarkers;}, [], 0, false, true, "", "count CODI_Path_markers > 0"];
}];
