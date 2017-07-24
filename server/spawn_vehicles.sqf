Server_FreeVehicles = [];
Server_DeadVehicles = [];

Anti_Hack =
{
	_Player_by_ID=
	{
		private["_id"];
		
		_id = _this;
		_rv = objNull;
		
		{
			if((owner _x) == _id) exitWith
			{
				_rv = _x;
			};
		} forEach playableUnits;
		
		_rv
	};

	{

		_k = [_x, "server_vehicle", false] call Get_Var;
		if(!_k) then
		{
			_i = owner _x;	
			if(_i > 1) then
			{
				_e = _i call _Player_by_ID;
				_t = getText(configFile >> 'CfgVehicles' >> (typeOf _x) >> 'DisplayName');
				diag_log format["ANTI-HACK: Strange vehicle: %1 / %5 at %4, owner: %2 / %3", _t, name _e, _i, getPos _x, _x];
				if(!(alive _x)) then
				{
					deleteVehicle _x;
				};
			};
		};
	} forEach vehicles;

};

Pick_Spawn_Pos =
{
	private['_rv'];
	
	_max_distance = 0;
	_rv = Config_VehicleSpawnLocations select 0;
	
	{
		_marker_name = _x;
		_min_distance = 100000;
		
		_mpos = getMarkerPos _marker_name;
		{
			_cdist = _mpos distance (getPos _x);
			if(_cdist < _min_distance) then
			{
				_min_distance = _cdist;
			};
//			diag_log format['Min distance: %1', _min_distance];			
		} forEach Server_FreeVehicles;
		
		if(_min_distance > _max_distance) then
		{
			_max_distance = _min_distance;
			_rv = _marker_name;
		};
		
//		diag_log format['Max distance: %1', _max_distance];
	} forEach Config_VehicleSpawnLocations;
	
//	diag_log format["Spawn location: %1", _rv];
	
	_rv;
};

Spawn_Free_Vehicles =
{
	while{count Server_FreeVehicles < Config_FreeVehiclesCount} do
	{
		_type = "";
		{
			_veh_type = _x;
			_exists = false;
			{
				_cur_type = typeOf _x;
				if(_cur_type == _veh_type) then
				{
					_exists = true;
				};
			} forEach Server_FreeVehicles;
			if(!_exists) exitWith {
				_type = _veh_type;
			};
		} forEach Config_SpawningVehicles;
		
		if(_type == "") then
		{
			_type = Config_SpawningVehicles call Pick_Item;
		};
		
		_sloc = call Pick_Spawn_Pos;
		_cpos = getMarkerPos _sloc;
		
		_vp = [_cpos, 20] call Vehicle_Spawn_Params;
		
		_vpos = _vp select 0;
		_dir = _vp select 1;
		
		_pos = [_vpos, 20, 5] call Free_Spawn_Pos;
		
		_veh = [_pos, _dir, _type] call Create_Empty_Vehicle;
		
		_veh setVariable ['server_vehicle', true, true];
		
		_veh call InitVehicle;
		
		_veh setFuel (0.2 + (random 1)*0.2);
		
		[_veh, _type] call Equip_Vehicle;
		
		diag_log format["Created free vehicle: %1, %2, dir: %3", _type, _sloc, _dir];

		Server_FreeVehicles = Server_FreeVehicles + [_veh];
		sleep 0.5;
	};
};

Equip_Vehicle = 
{
	private['_veh', '_type', '_count', '_weapon', '_ammo', '_ammocnt', '_ae', '_i'];
	_veh = _this select 0;
	_type = _this select 1;
	
	_count = [Config_Vehicles, Config_Vehicles_WeaponsCnt, _type] call Value_By_Name;
	
	for [{_i=1},{_i<=_count},{_i=_i+1}] do {
		_weapon = Config_VehicleWeapons call Pick_Item;
		_ammo = [Config_VehicleWeapons_Idx, Config_VehicleWeapons_Ammo, _weapon] call Value_By_Name;
		_ammocnt = [Config_VehicleWeapons_Idx, Config_VehicleWeapons_Ammo_Count, _weapon] call Value_By_Name;
		
		_veh addWeaponCargoGlobal [_weapon, 1];
		_veh addMagazineCargoGlobal [_ammo, _ammocnt];			
	
	};
	
	for [{_i=1},{_i<=_count*1.5},{_i=_i+1}] do {
		_weapon = Config_VehicleItems call Pick_Item;
		_veh addItemCargoGlobal [_weapon, 1];			
	};
	
	if((random 1) <= Config_BackpackChance) then
	{
		_count = 1 + (random 2);
		for [{_i=1},{_i<=_count},{_i=_i+1}] do {
			_weapon = Config_VehicleBackpacks call Pick_Item;
			_veh addBackpackCargoGlobal [_weapon, 1];			
		};
	};
};

Add_Dead_Vehicle = 
{
	_add_veh = _this;
	_exists = false;
	{
		_veh = _x select 0;
		_time = _x select 1;
		if(_veh == _add_veh) exitWith {
			_exists = true;
		};
	} forEach Server_DeadVehicles;
	
	if(!_exists) then
	{
		Server_DeadVehicles = Server_DeadVehicles + [[_add_veh, diag_tickTime]];
	};
};

Check_Dead_Vehicles =
{
	{
		if(!(alive _x)) then
		{
			_x call Add_Dead_Vehicle;
			Server_FreeVehicles set [Server_FreeVehicles find _x, objNull];			
		};
	} forEach Server_FreeVehicles;

	Server_FreeVehicles = Server_FreeVehicles - [objNull];	
};

Remove_Dead_Vehicles = 
{
	_i = 0;
	{
		_veh = _x select 0;
		_time = _x select 1;
		_last = diag_tickTime - Config_RemoveDeadVehicles;
		if(_time < _last) then
		{
			deleteVehicle _veh;
			Server_DeadVehicles set [_i, 0];	
		};
		_i = _i + 1;
	} forEach Server_DeadVehicles;
	
	Server_DeadVehicles = Server_DeadVehicles - [0];
};

[] spawn 
{

	while {true} do
	{
		[] spawn Spawn_Free_Vehicles;
		sleep 3;
		[] spawn Check_Dead_Vehicles;
		sleep 3;				
		[] spawn Remove_Dead_Vehicles;
		sleep 3;		
//		[] spawn Anti_Hack;
	};

	
};

[] spawn
{
	while {true} do
	{
		diag_log format["SERVER-INFO: FPS: %1 ", diag_fps];		
		sleep 20;
	};
};