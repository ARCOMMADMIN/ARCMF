private ["_groupsToDrawMarkers", "_playerSide", "_colour", "_marker"];

{deleteMarkerLocal _x; false} count ARC_tracker_markers;

ARC_tracker_markers = [];

if (ARC_tracker_enabled && {(!isNil "ACE_player") && {alive ACE_player}}) then {
    _groupsToDrawMarkers = [];
    _playerSide = playerSide;
    _enableGroupMarkers = [false,true] select (getNumber (missionConfigFile >> "CfgARCMF" >> "markers" >> (_playerSide call ARC_fnc_getFactionFromSide) >> "enableGroupMarkers") == 1);

    if (!_enableGroupMarkers) exitWith {};

    _groupsToDrawMarkers = allGroups select {side _x == _playerSide};

    if (ARC_tracker_hideAiGroups) then {
        _groupsToDrawMarkers = _groupsToDrawMarkers select {{isPlayer _x} count units _x > 0};
    };
    
    _markerIndex = 0;
    
    {
        private _markerType = _x call ARC_fnc_getMarkerType;
        private _colour = _x getVariable ["ARC_groupColour", format ["Color%1", side _x]];

        private _marker = createMarkerLocal [format ["ARC_TRACKER_%1", _markerIndex], [(getPos leader _x) select 0, (getPos leader _x) select 1]];
        _marker setMarkerTypeLocal _markerType;
        _marker setMarkerColorLocal _colour;
        _marker setMarkerTextLocal (groupId _x);

        ARC_tracker_markers pushBack _marker;
        _markerIndex = _markerIndex + 1;

        false
    } count _groupsToDrawMarkers;
};