Server_CreateUnit =
{
	private["_group","_position","_range","_special","_unit","_unittype","_cost"];
	
	_unittype = _this select 0;
	_position = _this select 1;
	_range = _this select 2;
	_special = _this select 3;
	_group = _this select 4;
	
	_unit = objNull;
	
	_unit = _group createUnit [_unittype,_position,[],_range,_special];
	_unit setDir (random 360);
	
	_unit setSkill 1;
	
//	_cost = [_unittype] call GetAward;
	
//	_unit setVariable ["side", side _group];		
//	_unit setVariable ["kill_award", _cost, true];
	
//	_unit call Add_Enemy_Handlers;
	
	diag_log format["Created unit: %1", _unit];
	
	_unit
};
