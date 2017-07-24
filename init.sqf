#include "defines.sqf"

enableSaving[false,false];

call compile preprocessFile "config.sqf";
call compile preprocessFile "utils.sqf";
call compile preprocessFile "vehicle_actions.sqf";

diag_log "SERVER-INFO: SCRIPT-STARTED ";

waitUntil {!isNil "bis_fnc_init";};

call compile preprocessFile "common\precompile.sqf";

if(isServer) then
{
	call compile preprocessFile "server\precompile.sqf";
};

Game_Ended = false;

if(!isServer || local player) then
{	
	call compile preprocessFile "client\precompile.sqf";
	
	sleep 0.1;
	
	waitUntil{player==player};
	waitUntil{alive player};
	waitUntil{local player};

};

