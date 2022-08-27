params ["_marker"];


private _marker = _this param [0];
private _pos = _marker call BIS_fnc_randomPosTrigger;
private _classes = NSH_genericGroundEnemies;
private _manClasses = [];
private _carClasses = [];
private _men = [];
private _cars = [];
private _group = createGroup independent;

{
	if (_x isKindOf "Man") then {_manClasses pushBack _x};
	if (_x isKindOf "LandVehicle") then {_carClasses pushBack _x};

} forEach _classes;


//Spawn them safely
{_unit = _group createUnit [_x, _pos, [], 50, "NONE"]; _men pushBack _unit} forEach _manClasses;
{_car = [_pos, random 360, _x, _group] call BIS_fnc_spawnVehicle; _cars pushBack _car} forEach _carClasses;


private _size = count units _group;
_group setBehaviour "AWARE";
_wp = _group addWaypoint [getMarkerPos _marker, 50];
_wp setWaypointType "LOITER";
_wp setWaypointBehaviour "AWARE";
systemChat str format ["LOG: Spawned %1 Enemy ground units at %2", _size, _pos];
_group;

/*
private _handle = [_group, _size] spawn {
	params ["_group", "_size"];
	private ["_group", "_size"];

	waitUntil {sleep 5; (count units _group) > round (0.25 * _size);};
	systemChat "LOG: CAS Mission was a success";
};
*/