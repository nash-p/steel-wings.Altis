//Airstrike


//Prefix for markers used to spawn enemy ground targets for strike mission
private _prefix = "STRIKE_SITE";

//Filter markers for Strike  markers
private _strikeMarkers = allMapmarkers select {toUpper _x find _prefix >=0};
private _site = selectRandom _strikeMarkers;
_site setMarkerAlpha 1;




//Get the layer for this marker
private _str = _site splitString "_";			//["strike", "site", "00"]
private _id = (_str select 0) + "_" + (_str select 2);
private _layer = _id + "_layer";
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

//Get all HVTs for this layer 
//MUST follow the same naming pattern of 'strike_n_target_XXX'
//Where n is the site number and XXX is anything
private _hvts = _layerObjects select {str _x find (_id + "_target") >=0};




//Task creator

//Create Parent Task first


private _taskID = "tsk_strike_hvt_" + str (NSH_TASK_COUNT + 1);

private _taskDesc = "Eliminate the High Value Target";
private _taskTitle = "HVT Strike";
private _taskMarker = _taskTitle;
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
	"kill"

] call BIS_fnc_taskCreate;

private _targets = [];
_targets append _hvts;

missionNamespace setVariable [(_taskID + "_targets"), _targets];
systemChat str format ["Target list is %1", str _targets];



_checkComplete_Tsk = {
	params ["_taskID", "_targets"];
	
	private _taskID = _this param [0];
	private _targets = _this param [1];
	_alive = true;
	_taskState = _taskID call BIS_fnc_taskState;

	while {_alive && !(_taskState == "FAILED")} do {
		sleep 2;
		_alive = (_targets findIf {alive _x}) > -1;
		_taskState = _taskID call BIS_fnc_taskState;
	};

	if (_alive) exitWith {false};

	systemChat "LOG: HVT Strike was successful";
	[_taskID, "SUCCEEDED"] call BIS_fnc_taskSetState;
	true;

};

_checkFail_Tsk = {
	params ["_taskID", "_badGuys"];

	private _taskID = _this param [0];
	private _badGuys = _this param [1];
	private _spotted = false;
	private _noticedMe_UwU  = false;

	_taskState = _taskID call BIS_fnc_taskState;

	while {!(_spotted) && !(_taskState == "SUCCEEDED")} do {
		sleep 2;
		_taskState = _taskID call BIS_fnc_taskState;

		//Check if spotted
		_noticedMe_UwU = ({_x knowsAbout vehicle player > 1} count _badGuys) > 0;

		if (_noticedMe_UwU) then {
			systemChat "LOG: Player has been made, 30s till alarm"; 
			sleep 30;
			if (_taskState == "SUCCEEDED") exitWith {_spotted = false};
			_spotted = true;
			};
		};

	if (!(_spotted)) exitWith {false};

	systemChat "LOG: HVT Strike failed";
	[_taskID, "FAILED"] call BIS_fnc_taskSetState;
	true;

};


NSH_TASK_COUNT = NSH_TASK_COUNT + 1;
_checkSucceed = [_taskID, _targets] spawn _checkComplete_Tsk;
_checkFail = [_taskID, _badGuys] spawn _checkFail_Tsk;