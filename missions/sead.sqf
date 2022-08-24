//Suppression of Enemy Air Defenses



//Prefix for markers used to spawn AntiAir units for SEAD mission
private _prefix = "ADS_SITE";
private _handle = 0;

//Filter map markers for SEAD markers
private _seadMarkers = allMapMarkers select {toUpper _x find _prefix >=0};
private _siteMark = selectRandom _seadMarkers;

_handle = [_siteMark] execVM "scripts\spawnComp.sqf";


//Task creator
waitUntil {scriptDone _handle};

private _taskID = "tsk_sead_" + str (NSH_TASK_COUNT + 1);

private _taskDesc = "Destroy the Enemy Air Defense System";
private _taskTitle = "SEAD";
private _taskMarker = _taskTitle;
private _descrip = [
	_taskDesc,
	_taskTitle,
	_taskMarker
];

private _destin = getMarkerPos _siteMark;
private _state = "AUTOASSIGNED";
private _priority = 1;

[
	player,
	_taskID,
	_descrip,
	_destin,
	_state,
	_priority,
	true,
	"destroy"

] call BIS_fnc_taskCreate;


//Grab all vehicles, turrets etc in 100m around task area 
private _vehicles = [];
_vehicles = nearestObjects [_destin, ["AllVehicles"], 100];

missionNamespace setVariable [(_taskID + "_targets"), _vehicles];


_checkComplete_Tsk = {
	
	private _taskID = _this param [0];
	private _targets = missionNamespace getVariable [(_taskID + "_targets"), []];
	private _alive = true;

	while {_alive} do {
		sleep 2;
		_alive = (_targets findIf {alive _x}) > -1;
	};

	[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;

};

NSH_TASK_COUNT = NSH_TASK_COUNT + 1;
_handleCheckComplete = [_taskID] spawn _checkComplete_Tsk;


