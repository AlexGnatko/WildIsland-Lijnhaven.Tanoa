call compile preprocessFile "client\client_utils.sqf";
CustomMessage = compile preprocessFile "client\custom_message.sqf";
FieldRepairs = compile preprocessFile "client\field_repairs.sqf";

Local_RegisteredUnits = [];

Client_SeenVehicles = [];

Local_NeedRespawn = true;
Local_DoingRespawn = false;

setViewDistance 5000;


[] spawn {
	player addEventHandler ["Killed", {_this spawn Player_Respawn;}];
	
	sleep 0.5;
//	player addMPEventHandler ["MPRespawn", {_this spawn Player_Respawn;}];
	

	"Public_Client_New" addPublicVariableEventHandler { _this call Client_Register_Vehicle };	
	
	sleep 2;

	cutText ["Al Hadid presents Wild Island PvP 1.0","PLAIN DOWN",1];	
	sleep 7;	
	cutText ["Kill enemies and avoid being killed!","PLAIN DOWN",1];
	sleep 10;
	cutText ["Check cars and trucks for some exciting weapons!","PLAIN DOWN",1];
	sleep 10;
	
	cutText ["","PLAIN DOWN",3];	
};

//[] spawn compile preprocessfile "client\display.sqf";
[] spawn compile preprocessFile "client\fixrating.sqf";
[] spawn compile preprocessFile "client\vehicles.sqf";
[] spawn compile preprocessFile "client\spawn.sqf";

