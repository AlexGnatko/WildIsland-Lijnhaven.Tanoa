call compile preprocessFile "server\server_utils.sqf";
call compile preprocessFile "server\spawn_vehicles.sqf";
call compile preprocessFile "server\garbage_collector.sqf";

Server_RegisteredUnits = [];

[] spawn {
	sleep 1;
	"Public_Server_New" addPublicVariableEventHandler { _this call Server_Register_Vehicle };	
};

[] spawn compile preprocessFile "server\spawn_bots.sqf";