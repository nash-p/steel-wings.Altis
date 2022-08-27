//Close Air Support


//Prefix for markers used to spawn enemy ground targets for CAS mission
private _prefix = "CAS_SITE";

//Filter markers for CAS markers
private _casTriggers = allMapmarkers select {toUpper _x find _prefix >=0};
private _siteMark = selectRandom _casTriggers;

private _groupEnemies = [_siteMark] call compile preprocessFileLineNumbers "scripts\spawnEnemyGround.sqf";
private _groupFriends = [_siteMark] call compile preprocessFileLineNumbers "scripts\spawnFriendlyGround.sqf";

//waitUntil {scriptDone _handle && scriptDone _handleF;};

//Task creator

private _taskID = "tsk_cas_" + str (NSH_TASK_COUNT + 1);

private _taskDesc = "Provide Close Air Support to nearby Friendlies";
private _taskTitle = "CAS";
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
	"attack"

] call BIS_fnc_taskCreate;



//Grab all vehicles, turrets etc in 100m around task area 
private _targets = [];
_targets = units _groupEnemies;

missionNamespace setVariable [(_taskID + "_targets"), _targets];

_checkComplete_Tsk = {
	params ["_taskID", "_group", "_size"];

	private ["_taskID", "_group", "_size"];
	private ["_taskDone", "_alive"];

	//Once enemies are dead, or task is failed, end loop
	_taskState = _taskID call BIS_fnc_taskState;
	_alive = ({alive _x} count units _group) > round (0.25 * _size);

	while {_alive && !(_taskState == "FAILED")} do {
		sleep 5;
		_alive = ({alive _x} count units _group) > round (0.25 * _size);
		_taskState = _taskID call BIS_fnc_taskState;
	};

	//Loop should only break if task is failed or enemies are not alive
	if (_alive) exitWith {false};

	//If they are not alive then they are dead which is good
	systemChat "LOG: CAS Mission was a success";
	[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
	true;
};

_checkFail_Tsk = {
	params ["_taskID", "_group", "_size"];

	private ["_taskID", "_group", "_size"];
	private ["_taskDone", "_alive"];

	//Once friendlies are dead, or task is succeeded, end loop
	_taskState = _taskID call BIS_fnc_taskState;
	_alive = ({alive _x} count units _group) > round (0.1 * _size);

	while {_alive && !(_taskState == "SUCCEEDED")} do {
		sleep 1;
		_alive = ({alive _x} count units _group) > round (0.1 * _size);
		_taskState = _taskID call BIS_fnc_taskState;
	};


	//Loop should only break if task is succeeded or friendlies are not alive
	if (_alive) exitWith {false};

	//If they are not alive then they are dead which is bad
	systemChat "LOG: CAS Mission was a failure, friendlies are dead";
	[_taskID, "FAILED"] call BIS_fnc_taskSetState;
	true;
};


NSH_TASK_COUNT = NSH_TASK_COUNT + 1;
_checkSucceed = [_taskID, _groupEnemies, ({alive _x} count units _groupEnemies)] spawn _checkComplete_Tsk;
_checkFail = [_taskID, _groupFriends, ({alive _x} count units _groupFriends)] spawn _checkFail_Tsk;



