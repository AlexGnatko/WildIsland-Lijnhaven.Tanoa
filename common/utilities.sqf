Recruit_Unit =
{
	private ["_veh", "_buyer", "_funds", "_name", "_price", "_funds", "_yes"];
	
	_veh = _this select 0;
	_buyer = _this select 1;
	
	_name = _veh call VehicleType;
	
	_yes = [_name, format["Recruit %1?", _name]] call YesNo;
	if(_yes) then
	{
		[_veh] join (group _buyer);
		
		_veh setVariable ['hired', true, true];		
		_veh setVariable ['owner_uid', getPlayerUID _buyer];
		
		[_name, format["You hired %1", _name], "", 1.0] call CustomMessage;
	};
};

Dismiss_Unit =
{
	private ["_veh", "_buyer", "_funds", "_name", "_price", "_funds", "_yes", "_group"];
	
	_veh = _this select 0;
	_buyer = _this select 1;
	
	_name = _veh call VehicleType;
	
	_yes = [_name, format["Dismiss %1?", _name]] call YesNo;
	if(_yes) then
	{
		_group = createGroup civilian;
		[_veh] joinSilent _group;
		
		_veh setVariable ['hired', false, true];		
			
		[_name, format["You dimissed %1!",_name], "", 1.0] call CustomMessage;
	};
};

YesNo =
{
	private ["_label", "_text"];
	
	_label = _this select 0;
	_text = _this select 1;	
	
	Last_Yes = false;
	createDialog "RscYesNo";	
	ctrlSetText [4800, _label];
	ctrlSetText [4900, _text];	
	
    waitUntil {sleep 0.1; not dialog};
	
	Last_Yes
};
