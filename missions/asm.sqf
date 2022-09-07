//Air Superiority Mission



//Prefix for markers enemy planes will fly to (must be in all caps)
private _prefix = "ASM_SITE";

//Filter map markers for ASM markers
private _asmMarkers = allMapMarkers select {toUpper _x find _prefix >=0};
private _siteMark = selectRandom _asmMarkers;
private _dest = getMarkerPos _siteMark;


/*
	Try to spawn enemy air from at least 25km away
	This way enemy aircraft aren't loitering near their objective too early
	Especially useful if the ASM site is near the players airbase
*/


private _spawnPoints = [];
private _spawn = "";

{_spawnPoints pushBackUnique (position _x)} forEach NSH_SPAWN_AIR_LIST;

[
	_spawnPoints,
	[_dest],
	{_x distance2D _input0},
	"DESCEND",
	{(_x distance2D _input0) < 20000}

] call BIS_fnc_sortBy;

_spawn = selectRandom _spawnPoints;
_spawn set [2, 2500];

sleep 1;
private _group = false;
_group = [_spawn, _dest] call compile preprocessFileLineNumbers "scripts\spawnEnemyAir.sqf";


//waitUntil {scriptDone _group};
sleep 4;
systemChat str format ["LOG: Started ASM mission from %1 headed to %2", _spawn, _dest];





//Task Creator
private _taskID = "tsk_asm_" + str (NSH_TASK_COUNT + 1);

private _taskDesc = "Maintain air superiority over the designated area.";
private _taskTitle = "Air Superiority Mission";
private _taskMarker = _siteMark;
private _descrip = [
	_taskDesc,
	_taskTitle,
	_taskMarker
];

private _destin = getMarkerPos _siteMark;
private _state = "AUTOASSIGNED";
private _priority = NSH_TASK_COUNT + 1;

[
	player,
	_taskID,
	_descrip,
	_destin,
	_state,
	_priority,
	true,
	"plane"

] call BIS_fnc_taskCreate;

//Grab all enemy aircraft
private _planes = [];
{_planes pushBackUnique (assignedVehicle _x)} forEach units _group;

missionNamespace setVariable [(_taskID + "_targets"), _planes];

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
_checkTskHandle = [_taskID] spawn _checkComplete_Tsk;


