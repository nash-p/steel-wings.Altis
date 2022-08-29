//Interdiction/Deep Air Strike


//Prefix for markers used to filter the markers for interdiction mission
private _prefix = "DAS_SITE";

//Filter markers for Interdiction markers which is then used to select the layer
private _dasMarkers = allMapmarkers select {toUpper _x find _prefix >=0};
private _site = selectRandom _dasMarkers;
_site setMarkerAlpha 1;

//Get the layer for this marker
private _layer = _site + "_layer";
private _layerObjects = (getMissionLayerEntities _layer) select 0;
private _badGuys = [];

//Activate the layer objects and filter the living ones
{
	
	_x enableSimulation true;
	_x hideObject false;

	//Get all the bad guys in this layer
	private _bad = (side _x == east) or (side _x == independent);

	if ((_x isKindOf "Man") && _bad) then {_badGuys pushBackUnique _x};

} forEach _layerObjects;

//Get all targets in this layer
//Must follow the same naming pattern of 'das_site_n_target_XXX'
//Where n is the site number and XXX is anything

private _targets = _layerObjects select {str _x find (_site + "_target") >=0};




//Task Creator

private _taskID = "tsk_interdict_" + str (NSH_TASK_COUNT + 1);

private _taskDesc = "Destroy Enemy Assets";
private _taskTitle = "Deep Air Strike";
private _taskMarker = "Interdict";
private _descrip = [
	_taskDesc,
	_taskTitle,
	_taskMarker
];

private _destin = getMarkerPos _site;
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

missionNamespace setVariable [(_taskID + "_targets"), _targets];
systemChat str format ["Target list is %1", str _targets];

_checkComplete_Tsk = {
	params ["_taskID", "_targets"];

	private ["_taskID", "_targets"];
	private _taskState = _taskID call BIS_fnc_taskState;
	private _alive = (_targets findIf {damage _x < 0.75}) >= 0;

	//If targets are destroyed or task is failed end this loop
	while {_alive && !(_taskState == "FAILED")} do {
		sleep 5;
		_alive = (_targets findIf {damage _x < 0.75} >= 0);
		_taskState = _taskID call BIS_fnc_taskState;
	};

	if (_alive) exitWith {false};

	systemChat "LOG: Interdiction mission was a success";
	[_taskId, "SUCCEEDED"] call BIS_fnc_taskSetState;
	true;
};

_checkFail_Tsk = {
	params ["_taskID"];

	private ["_taskID"];
	private _taskState = _taskID call BIS_fnc_taskState;
	private _planeAlive = canMove NSH_PLANE;

	while {_planeAlive && !(_taskState == "SUCCEEDED")} do {
		sleep 5;
		_planeAlive = canMove NSH_PLANE;
		_taskState = _taskID call BIS_fnc_taskState;
	};

	if (_planeAlive) exitWith {false};

	systemChat "LOG: Interdiction FAILED, player shot down.";
	[_taskId, "FAILED"] call BIS_fnc_taskSetState;
	true;
};


NSH_TASK_COUNT = NSH_TASK_COUNT + 1;
_checkWin = [_taskID, _targets] spawn _checkComplete_Tsk;
_checkLose = [_taskID] spawn _checkFail_Tsk;