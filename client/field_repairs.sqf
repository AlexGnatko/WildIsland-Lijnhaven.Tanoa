//user action: Field Repairs

private["_veh", "_caller", "_name"];

_veh = _this select 0;
_caller = _this select 1;

//get number of repair kits remaining
_pack = _veh getVariable "repair_kits";

//duration of one field-repair operation
_fieldrepairtime = 20;

//if vehicle is not handled by any script before, consider it is new
//and set a full amount of repair packs inside
if (isNil "_pack") then
{
	_pack = 3;
	_veh setVariable ["repair_kits", _pack, true];
};

//check if vehicle is not being
//field repaired at the moment

_time = [_veh, "field_repairs", 0] call Get_Var;
_name = _veh call VehicleType;

//if vehicle has repair packs
//perform repair process
if (_pack>0) then
{
	if (({alive _x} count crew _veh) > 0) exitWith {
		[_name,
		"Remove all crew from the vehicle first!",
		"pic\i_repair_f.paa",
		1.0,
		"error_sound"] call CustomMessage;
		
		_veh setVariable ["field_repairs",0,true];
	};
	if ((time-_time)<_fieldrepairtime) exitWith {
		[_name,
		"The vehicle is being repaired already!",
		"pic\i_repair_f.paa",
		1.0,
		"error_sound"] call CustomMessage;
	};

	if (!(isNull _veh)) then
	{
		//show start hint
		[_name, "Field repairs started...", "pic\i_repair_s.paa", 1.0] call CustomMessage;
		
		//mark the vehicle is under field repair
		_veh setVariable ["field_repairs",time,true];
		
		_caller setVariable ["doing_field_repairs", true, true];
		
		_i = 0;
		while {(alive _caller) && (alive _veh) && (({alive _x} count crew _veh)==0) && (_i < _fieldrepairtime)} do
		{
			//make player play animation
			_caller playMove "AinvPknlMstpSlayWrflDnon_medic";
			sleep 1;
			if ((alive _caller) && (alive _veh) && (({alive _x} count crew _veh)==0)) then
			{
				_i=_i+1;
			};
		};

		if (_i < _fieldrepairtime) exitWith
		{
			//if i<_fieldrepairtime that means player is dead / _veh is dead / some crew got into veh
			[_name, "Field repairs failed!", "pic\i_repair_f.paa", 1.0, "error_sound"] call CustomMessage;

			_caller setVariable ["doing_field_repairs", false, true];
			_veh setVariable ["field_repairs", 0, true];
		};
		
		//reduce number of repair packs remaining
		_pack = [_veh, "repair_kits", 3] call Get_Var;
		_pack = _pack-1;
		
		//show finish message
		[_name,format["Field repairs complete!<br/>%1 repair kits left",_pack],"pic\i_repair_s.paa",1.0] call CustomMessage;
		_veh setVariable ["repair_kits", _pack, true];

		//repair the vehicle
		
		_dam = (getDammage _veh) - 0.15;

		_veh setDammage _dam;

		//helicopters often loose fuel
		//restore it
		if ((_veh isKindOf "Air") && (_dam>0.20)) then
		{
			_dam = 0.20;
			_veh setFuel (fuel _veh) + 0.4;
		};
		_veh setDammage _dam;

		//mark player is not engaged in technical service
		_caller setVariable ["doing_field_repairs", false, true];
		_veh setVariable ["field_repairs",time,true];		
	};
}
else
{
	//show cancel hint
	[_name,"No repair kits left in the vehicle!","pic\i_repair_f.paa",1.0,"error_sound"] call CustomMessage;
};
