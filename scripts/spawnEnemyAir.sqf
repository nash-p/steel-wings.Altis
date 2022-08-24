params ["_spawn", "_dest"];


private _spawn = _this param [0];
private _dest = _this param [1];
private _class = NSH_genericAirEnemy;
private _amount = 2;
private _side = independent;

_group = createGroup _side;

_i = 0;
for "_i" from 1 to _amount do {
	_spawn = _spawn getPos [random 100, random 180];
	private _spawnArr = [_spawn, 0, _class, _side] call BIS_fnc_spawnVehicle;
	private _newGroup = _spawnArr select 2;
	units _newGroup join _group;

};

_wp = _group addWaypoint [_dest, 500];
_wp setWaypointType "MOVE";
systemChat str format ["LOG: Spawned enemy %1 at %2 headed to %3", _class, _spawn, _dest];
_group;




