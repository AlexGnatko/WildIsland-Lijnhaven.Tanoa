Recruit_Actions = 
{
	private ['_name'];
	
	_name = _this call VehicleType;
	
	_this addAction [
	"<t color='#FFFF2C'>"+(format["Recruit %1",_name])+"</t>",
	"client\actions.sqf",
	[71],
	80,
	true,
	true,
	"", 
	"(vehicle _this == _this)
	&& (alive _target) 
	&& (alive _this)
	&& ((side _this) == (side player))
	&& (_this == player)
	&& !(_target getVariable ['hired', true])
	"];		
	
	_this addAction [
	"<t color='#2CFF2C'>"+(format["Dismiss %1",_name])+"</t>",
	"client\actions.sqf",
	[72],
	80,
	true,
	true,
	"", 
	"(alive _target) 
	&& ((_target == _this) || (_this == leader _target))
	&& (_target getVariable ['hired', true])
	"];		
	
	_this setVariable ['hired', false, true];
};

Create_Bot = 
{
	private ['_side', '_pos', '_man', '_group', '_class', '_marker', '_index', '_pmarker', '_w0'];	
	
	_side = _this select 0;
	
	if(_side == west) then
	{
		_class = Config_BotClassesWest call Pick_Item;
	}else{
		_class = Config_BotClassesEast call Pick_Item;
	};
	
	_group = createGroup _side;
	
	_marker = [_side] call Pick_Player_Spawn_Pos;
	_pos = getMarkerPos _marker;
	_pos = [_pos, 10, 3] call Free_Spawn_Pos;
	
	sleep 0.5;

	_man = [_class, _pos, 15, "", _group] call Server_CreateUnit;
	
	Server_RegisteredUnits = [_man, Server_RegisteredUnits] call Ensure_In_Array;
	
	_man call Recruit_Actions;
	
	_pmarker = "";
	
	for [{_index = 0; }, {_index < 5; }, {_index = _index + 1; }] do
	{
		_marker = Config_PlayerSpawnLocations call Pick_Item;
		if(_marker == _pmarker) then
		{
			_index = _index - 1;
		}else{
			_pmarker = _marker;
			_pos = getMarkerPos _marker;
			_w0 = _group addWaypoint [_pos, 20];
			_w0 setWaypointCompletionRadius 20;
		};
	};
	
	_w0 setWaypointType "cycle";
	_group setCombatMode "Red";
	
	diag_log "Created a new group!";
};

Ensure_Bot =
{
	private ['_side', '_count'];
	
	_side = _this select 0;
	
	_count = {
		side _x == _side
	} count allUnits;
	
	if(_count < Config_SideBots) then
	{
		[_side] call Create_Bot;
	};
};

while{!Game_Ended} do
{
	[west] call Ensure_Bot;
	[east] call Ensure_Bot;
	sleep 5;
};
