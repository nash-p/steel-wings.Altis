params ["_trigger"];

private _trigger = _this param [0];
private _units = [];

{_units pushBack (typeOf _x)} forEach (allUnits inAreaArray _trigger);
{_units pushBack (typeOf _x)} forEach (vehicles inAreaArray _trigger);

copyToClipboard str _units;





