params ["_marker"];

private _marker = _this param [0];
private _pos = getMarkerPos _marker;
private _dir = random 360;
private _compFile = "genericSHORAD";


[
	_pos, 
	_dir, 
	call (compile (preprocessFileLineNumbers (format ["comps\%1.sqf", _compFile])))
] call BIS_fnc_ObjectsMapper;
sleep 2.5;

//Get all the empty turrets that were spawned and add crew
private _turrets = [];
_turrets = nearestObjects [_pos, ["StaticWeapon"], 100];
{
	if (count (crew _x) < 1) then {createVehicleCrew _x};
	sleep 1;
} forEach _turrets;

systemChat str format ["LOG: Spawned a %1 at %2", _compFile, _marker];