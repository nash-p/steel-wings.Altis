params ["_marker"];


private _marker = _this param [0];
private _pos = _marker call BIS_fnc_randomPosTrigger;
_pos = _pos getPos [random [600, 750, 1000], random 360];
private _classes = NSH_genericGroundFriends;
private _manClasses = [];
private _carClasses = [];
private _men = [];
private _cars = [];
private _group = createGroup blufor;

{
	if (_x isKindOf "Man") then {_manClasses pushBack _x};
	if (_x isKindOf "LandVehicle") then {_carClasses pushBack _x};

} forEach _classes;

//Spawn them safely
{_unit = _group createUnit [_x, _pos, [], 50, "NONE"]; _men pushBack _unit} forEach _manClasses;
{_car = [_pos, random 360, _x, _group] call BIS_fnc_spawnVehicle; _cars pushBack _car} forEach _carClasses;


private _size = count units _group;
_group setBehaviour "COMBAT";
_wp = _group addWaypoint [getMarkerPos _marker, 100];
_wp setWaypointType "SAD";
_wp setWaypointBehaviour "COMBAT";
_group setCombatMode "RED";
systemChat str format ["LOG: Spawned %1 Friendly ground units at %2", _size, _pos];
_group;


/*
private _handle = [_group, _size] spawn {
	params ["_group", "_size"];
	private ["_group", "_size"];

	waitUntil {sleep 5; (count units _group) < round (0.1 * _size);};
	systemChat "LOG: CAS Mission was a failure, friendlies dead";
};
*/