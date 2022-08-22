params ["_compFile"];

private _pos = getMarkerPos "testMarker";
private _dir = random 360;
private _compFile = _this param [0];


[
	_pos, 
	_dir, 
	call (compile (preprocessFileLineNumbers (format ["comps\%1", _compFile])))
] call BIS_fnc_ObjectsMapper;
sleep 2.5;

//Get all the empty turrets that were spawned and add crew
private _turrets = [];
_turrets = nearestObjects [_pos, ["StaticWeapon"], 100];
{
	if (count (crew _x) < 1) then {createVehicleCrew _x};
	sleep 1;
} forEach _turrets;



