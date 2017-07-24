Server_DeadBodies = [];
Server_DeadGroups = [];

Add_Dead_Unit = 
{
    private ['_add_veh'];

	_add_veh = _this;
	_exists = false;
	{
		_veh = _x select 0;
		_time = _x select 1;
		if(_veh == _add_veh) exitWith {
			_exists = true;
		};
	} forEach Server_DeadBodies;
	
	if(!_exists) then
	{
		Server_DeadBodies = Server_DeadBodies + [[_add_veh, diag_tickTime]];
	};
};

Remove_Dead_Bodies = 
{
	private ['_i', '_ratio'];
	_ratio = 1;

	_i = 0;
	{
		if((count Server_DeadBodies) > 30) then
		{
			_ratio = 0.3;
		}else{
			_ratio = 1;
		};
		_veh = _x select 0;
		_time = _x select 1;
//		diag_log format["Dead: %1, %2, now: %3, secs: %4", _veh, _time, diag_tickTime, Config_RemoveDeadBodies];
		
		_last = diag_tickTime - (Config_RemoveDeadBodies * _ratio);
		if(_time < _last) then
		{
			deleteVehicle _veh;
			diag_log format["Deleting dead body %1", _veh];
			Server_DeadBodies set [_i, 0];	
		};
		_i = _i + 1;
	} forEach Server_DeadBodies;
	
	Server_DeadBodies = Server_DeadBodies - [0];
};

Delete_Dead_Bodies =
{
	{
		if(!(alive _x)) then
		{
			_x call Add_Dead_Unit;
			Server_RegisteredUnits set [Server_RegisteredUnits find _x, objNull];			
			diag_log format["Unregistered unit %1", _x];			
		};
	} forEach Server_RegisteredUnits;

	Server_RegisteredUnits = Server_RegisteredUnits - [objNull];		
};

Delete_Dead_Groups =
{
	{
		_group = _x;
		if ((count units _group) < 1) then
		{			
			if (!(isNull _group)) then
			{
				_e = false;
				_idx = 0;
				{		
					if((_x select 0) == _group) then
					{
						_e = true;
						if((_x select 1) < (diag_tickTime - Config_GroupsRemovePeriod)) then
						{
//							diag_log format["Deleting group: %1",_group];						
							deleteGroup _group;	
							Server_DeadGroups set [_idx, []];
						};
					};
					_idx = _idx + 1;					
				} forEach Server_DeadGroups;
				
				if(!_e) then
				{
					_v = [_group, diag_tickTime];
					Server_DeadGroups = Server_DeadGroups + [_v];
				};				
			};					
		}else{
			// don't remove groups that now have units in them
			_idx = 0;
			{		
				if((_x select 0) == _group) then
				{
					Server_DeadGroups set [_idx,[]];
				};
				_idx = _idx + 1;
			} forEach Server_DeadGroups;			
		};				
	} forEach allGroups;		
	
	Server_DeadGroups = Server_DeadGroups - [[]];	

};

[] spawn 
{

	while {true} do
	{
		[] spawn Delete_Dead_Bodies;
		sleep 5;
		[] spawn Remove_Dead_Bodies;
		sleep 5;
		[] spawn Delete_Dead_Groups;
		sleep 5;
	};

	
};