/*
	A set of config values mission makers can use to tweak this scenario
	for mod compatibility and what not.
	Should be relatively safe to mess around with and not break anything

*/

NSH_PLANE = fighter0;
publicVariable "NSH_PLANE";

NSH_ENEMYSIDE = [independent];
publicVariable "NSH_ENEMYSIDE";

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
//Filler aircraft, should be fixed wing with some AAM weapons
NSH_genericAirFighter = "I_Plane_Fighter_04_F";			
publicVariable "NSH_genericAirFighter";

//Filler aircraft, should be fixed wing with mostly AG weapons
NSH_genericAirAttacker = "I_Plane_Fighter_03_dynamicLoadout_F";
publicVariable "NSH_genericAirAttacker";

//Filler ground targets, mostly used for CAS/Strike missions
NSH_genericGroundEnemies = ["I_soldier_F"];

//Filler ground friendlies, mostly used for CAS/Strike missions
NSH_genericGroundFriends = ["B_Soldier_F"];

//If composition file is empty then use the above defaults
private _comp = preprocessFile "comps\genericGroundEnemies.sqf";
if (_comp == "") then {
	systemChat str format ["INFO: genericGroundEnemies.sqf is empty falling back to defaults"]
} else {
	NSH_genericGroundEnemies append ( call compile _comp)};
publicVariable "NSH_genericGroundEnemies";

private _comp = preprocessFile "comps\genericGroundFriends.sqf";
if (_comp == "") then {
	systemChat str format ["INFO: genericGroundFriends.sqf is empty falling back to defaults"]
} else {
	NSH_genericGroundFriends append ( call compile _comp)};
publicVariable "genericGroundFriends";
