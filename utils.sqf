#include "defines.sqf"

Pick_Item = {
	private ['_size', '_rv'];
	_size = count _this;
	_rv = [];
	if(_size > 0) then
	{
		_rv = _this select (round(random(_size - 1)));

	};
	_rv	
};

Ensure_In_Array =
{
	private['_a', '_item', '_exists'];
	
	_item = _this select 0;
	_a = _this select 1;
	
	_exists = false;
	
	{
		if(_x == _item) exitWith {
			_exists = true;
		};
	} forEach _a;
	
	if(!_exists) then
	{
		_a = _a + [_item];
	};
	
	_a
};

Create_Empty_Vehicle = {
	private ['_pos', '_ang', '_type', '_veh', '_dpos'];
	
	_dpos = getMarkerPos 'vehicle_creation';
	
	_pos = _this select 0;
	_ang = _this select 1;
	_type = _this select 2;
	
	_veh = createVehicle [_type, [_dpos select 0, _dpos select 1, 500 + (random 500)], [], 50, "FLY"];
	_veh setDir _ang;
	_veh setPos _pos;
	
	_veh
};

Free_Spawn_Pos =
{
	private ['_x', '_y', '_pos', '_cpos', '_obj', '_r', '_sr', '_place', '_attemps'];
	
	_cpos = _this select 0;
	_r = _this select 1;
	_sr = _this select 2;
	
	_attempts = 20;
	_place = 0;
	
	_pos = _cpos;
	
	_obj = nearestObjects [_pos, ["ALLVEHICLES","STATIC","THING"], _sr];
	if(!(surfaceIsWater _pos) && (count _obj) < 1)then
	{	
		_place = _attempts;
	};
	
	while{_place < _attempts}do
	{
		_x = random(_r) - (_r/2);
		_y = random(_r) - (_r/2);

		_pos = [(_cpos select 0) + _x,(_cpos select 1) + _y,0];
		_obj = nearestObjects [_pos, ["ALLVEHICLES","STATIC","THING"], _sr];
		if(!(surfaceIsWater _pos) && (count _obj) < 1)then
		{
			_place = _attempts;
		}else{
			sleep 0.1;
		};
		_place = _place + 1;
	};
	_pos
	
};

Get_Var =
{
	private["_vle","_varname","_varobj","_default"];
	
	_varobj = _this select 0;
	_varname = _this select 1;
	_default = _this select 2;
	
	_vle = _varobj getVariable [_varname, _default];
	
	_vle
};

Pick_Player_Spawn_Pos =
{
	private['_rv', '_min_distance', '_max_distance', '_side', '_marker_name', '_enemies', '_friends', '_anchor', '_enemy_distance', '_friend_distance', '_anchor_distance'];
	
	_side = _this select 0;
	
	_enemies = [];
	_friends = [];
	
	{
		if(side _x != _side) then 
		{
			_enemies = _enemies + [_x];			
		}else{
			_friends = _friends + [_x];
		};
	} forEach allUnits;
	
	if(_side == east) then
	{
		_anchor = getMarkerPos 'opfor_anchor';
	}else{
		_anchor = getMarkerPos 'blufor_anchor';	
	};
	
//	diag_log format['ENEMIES: %1', _enemies];
	
	_max_distance = 0;
	_rv = Config_PlayerSpawnLocations call Pick_Item;
	
	_anchor_distance = 100000;
	
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
//			diag_log format['Min distance e: %1', _min_distance];			
		} forEach _enemies;
		
		_enemy_distance = _min_distance;
		
		{
			_cdist = _mpos distance (getPos _x);
			if(_cdist < _min_distance) then
			{
				_min_distance = _cdist;
			};
//			diag_log format['Min distance f: %1', _min_distance];			
		} forEach _friends;		
		
		_friend_distance = _min_distance;		
		
		if(_enemy_distance > 1000) then
		{
			if((_mpos distance _anchor) < _anchor_distance) then
			{
				_max_distance = _min_distance;
				_rv = _marker_name;
				_anchor_distance = (_mpos distance _anchor);
			}
		};
		
//		diag_log format['Max distance: %1', _max_distance];
	} forEach Config_PlayerSpawnLocations;
	
	diag_log format["Player spawn location: %1, side: %2", _rv, _side];
	
	_rv;
};

Unit_Respawn =
{
	private['_unit', '_varname', '_cv', '_do', '_started', '_cnt', '_sleep', '_now', '_diff', '_new_unit'];
	_unit = _this;
	
	_varname = vehicleVarName _unit;
	
	_cnt = count playableUnits;
	_sleep = 2 / _cnt;
	
	diag_log format["Waiting for alive %1... ", _varname];
	
	_do = false;
	_started = diag_tickTime;
	_diff = 0;
	_new_unit = _unit;

	while{true} do {
		{
			_cv = vehicleVarName _x;
			if(_cv == _varname) then
			{
				if(alive _x) exitWith { 
					_new_unit = _x;
					_do = true; 
				};
			};
			sleep _sleep;
			_now = diag_tickTime;
			_diff = _now - _started;
//			diag_log format["started: %1, now: %2, diff: %3", _started, _now, _diff];
			if(_diff > 20) exitWith {};
		} forEach playableUnits;	
		if(_diff > 20) exitWith {};
		if(_do) exitWith {};
	};
	
	if(_do) then
	{
		sleep 1;
		diag_log format["Unit respawn: %1", _new_unit];
		
		_marker = [side _new_unit] call Pick_Player_Spawn_Pos;
		_cpos = getMarkerPos _marker;
		
		_pos = [_cpos, 10, 3] call Free_Spawn_Pos;
		
		_new_unit setPos _pos;
	}else{
/*		diag_log "Existing units:";
		{
			diag_log vehicleVarName _x;
		} forEach playableUnits;*/
	};
};

Vehicle_Spawn_Params =
{
	private['_pos', '_radius', '_roads', '_dir', '_dir_side', '_car_pos', '_dist', '_rv', '_rpos', '_road', '_next_roads', '_next_road'];
	_pos = _this select 0;
	_radius = _this select 1;
	
	_roads = _pos nearRoads _radius;

	_road = _roads call Pick_Item;
	
	diag_log _road;

	_next_roads = (getPos _road) nearRoads 10;	
	if(count _next_roads > 0) then
	{
		_next_road = _next_roads select 0;
		_roads = roadsConnectedTo _next_road;
		_next_road = _roads select 0;
		_dir = [_road, _next_road] call BIS_fnc_DirTo;
	}; 	
	
	_rpos = getPos _road;
	_dir = _dir + 180*(round (random 1));
	
	_dir_side = _dir + 90;
	_dist = 4;
	
	_car_pos = [(_rpos select 0) + (sin _dir_side) * _dist, (_rpos select 1) + (cos _dir_side) * _dist, 0];
	
//	_dir = _dir + round(random 10) - 5;
	
	_rv = [_car_pos, _dir];
	
	_rv
};

Client_Register_Vehicle = 
{
	private['_name', '_vle'];
	
	_name = _this select 0;
	_vle = _this select 1;
	
	diag_log format["Register on client: %1", _vle];
		
	if(_name == "Public_Client_New") then
	{
		Local_RegisteredUnits = [_vle, Local_RegisteredUnits] call Ensure_In_Array;
	};
	
};

Server_Register_Vehicle = 
{
	private['_name', '_vle'];
	
	_name = _this select 0;
	_vle = _this select 1;
	
	diag_log format["Register on server: %1", _vle];
	
	if(_name == "Public_Server_New") then
	{
		Server_RegisteredUnits = [_vle, Server_RegisteredUnits] call Ensure_In_Array;
	};
	
};

Broadcast_New_Unit = 
{
	_unit = _this;
	Public_Server_New = _unit;
	Public_Client_New = _unit;				

	if(isServer) then
		diag_log format["Direct register on server: %1", _unit];	
		Server_RegisteredUnits = [_vle, Server_RegisteredUnits] call Ensure_In_Array;
	{
	}else{
		publicVariable "Public_Server_New";	
	};
	
	publicVariable "Public_Client_New";
	if(local _unit) then
	{
		diag_log format["Direct register on client: %1", _unit];
		Local_RegisteredUnits = [_vle, Local_RegisteredUnits] call Ensure_In_Array;		
	};
};

Convert_To_Time =
{
	private["_full","_h","_h1","_m","_m1","_s","_s1","_v"];

	_v=_this select 0;	
	_full=_this select 1;
	
	if (_v >= 0) then
	{		
		//_v=_v max 0;	
		
		_h=floor(_v/3600);
		_v=_v-(_h*3600);
		_m=floor(_v/60);
		_s=floor(_v-(_m*60));
		_h=_h mod 24;
		
		_h1="";
		_m1="";
		_s1="";
		
		if (_full) then
		{
			_h1=format["%1",_h];
		};
		
		if(_m<10)then
		{
			_m1=format["0%1",_m];
		}
		else
		{
			_m1=format["%1",_m];
		};
		if(_s<10)then
		{
			_s1=format["0%1",_s];
		}
		else
		{
			_s1=format["%1",_s];
		};
		
		if (_full) then
		{
			_v=format ["%1:%2:%3",_h1,_m1,_s1];
		}
		else
		{
			_v=format ["%1:%2",_m1,_s1];
		};
	}
	else
	{
		_v="-/--";
	};
	
	_v

};

NoWheelDamage =
{
	private ['_result', '_part', '_veh', '_val'];
	
	_veh = _this select 0;
	_part = _this select 1;
	_result = _this select 2;
	
//	diag_log format["DMG: %1: %2 = %3", _veh, _part, _result];
	
	if(
	_part == 'wheel_1_1_steering' || 
	_part == 'wheel_1_2_steering' ||
	_part == 'wheel_2_1_steering' ||
	_part == 'wheel_2_2_steering'
	) then
	{
		_result = 0;
	};
	
	if(
	_part == 'palivo'
	) then
	{
		_result = 0;
	};
	
	_result
};

EnduringWheels =
{
	{
		_x addEventHandler ["HandleDamage", {_this call NoWheelDamage}];
	} forEach _this;
};

InitVehicleVariables =
{
	_this setVariable ["repair_kits", 3, true];
};

InitVehicle =
{
	if(alive _this) then
	{
//		[_this] call EnduringWheels;
		_this call InitVehicleVariables;
	};
};

VehicleType =
{
	getText (configFile >> "CfgVehicles" >> (typeOf _this) >> "DisplayName")
};

Value_By_Name =
{
	private['_idx', '_vals', '_val', '_i', '_rv'];
	
	_idx = _this select 0;
	_vals = _this select 1;	
	_val = _this select 2;
	
	_i = _idx find _val;
	_rv = _vals select _i;
	
	_rv
};