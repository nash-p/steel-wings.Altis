params ["_trigger"];

private _trigger = _this param [0];
private _comp = "";

_comp = [getPos _trigger, 100, true] call BIS_fnc_ObjectsGrabber;
copyToClipboard _comp;
