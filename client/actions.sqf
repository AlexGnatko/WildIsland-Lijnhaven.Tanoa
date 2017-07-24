private["_veh", "_caller"];

_caller = _this select 1;

switch((_this select 3) select 0) do
{
	case 1://field repairs
	{
		[_this select 0, _caller] call FieldRepairs;
	};

//
//
//	RECRUIT ACTIONS
//
//

	case 71: // Recruit unit
	{
		[_this select 0, _caller] call Recruit_Unit;
	};	

	case 72: // Dismiss unit
	{
		[_this select 0, _caller] call Dismiss_Unit;
	};		


};