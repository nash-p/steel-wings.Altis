NSH_DEBUG = true;
NSH_TASK_COUNT = 0;
publicVariable "NSH_DEBUG";
publicVariable "NSH_TASK_COUNT";


0 = [] execVM "config.sqf";

missionNamespace setVariable ["activeMission", false];

{_x setMarkerAlpha 0} forEach allMapMarkers;
