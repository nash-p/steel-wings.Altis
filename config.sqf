/*
	A set of config values mission makers can use to tweak this scenario
	for mod compatibility and what not.
	Should be relatively safe to mess around with and not break anything

*/


//Basically spawn points for air units 
//There should be one in each 10Km² except for near the player base
NSH_SPAWN_AIR_LIST = [
	spawn_AIR_CEN, 
	spawn_AIR_N, 
	spawn_AIR_NE, 
	spawn_AIR_NW, 
	spawn_AIR_S, 
	spawn_AIR_SW,
	spawn_AIR_E,
	spawn_AIR_W
	];
publicVariable "NSH_SPAWN_AIR_LIST";





//Classnames
//Filler aircraft, should be fixed wing with AGM and AAM weapons
NSH_genericAirEnemy = "I_Plane_Fighter_04_F";			
publicVariable "NSH_genericAirEnemy";

//Filler ground targets, mostly used for CAS/Strike missions
NSH_genericGroundEnemies = ["I_soldier_F"];

//If composition file is empty then use the above defaults
private _comp = preprocessFile "comps\genericGroundEnemies.sqf";
if (_comp == "") then {
	systemChat str format ["INFO: genericGroundEnemies.sqf is empty falling back to defaults"]
} else {
	NSH_genericGroundEnemies append ( call compile _comp)};
publicVariable "NSH_genericGroundEnemies";
