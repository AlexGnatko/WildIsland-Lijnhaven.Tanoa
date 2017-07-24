
Player_Do_Respawn =
{
	Local_DoingRespawn = true;
//	cutRsc ["OSD_BackBlack","plain"];
	titleCut ["", "BLACK FADED", 999];
	waitUntil{(alive player)};
//	cutRsc ["OSD_BackBlack","plain"];
	titleCut ["", "BLACK FADED", 999];
	sleep 1;

	_marker = [side player] call Pick_Player_Spawn_Pos;
	_cpos = getMarkerPos _marker;
	
	_pos = [_cpos, 10, 3] call Free_Spawn_Pos;
	
	sleep 0.5;
	
	player setPos _pos;

	Local_DoingRespawn = false;	
	Local_NeedRespawn = false;	

	cutText ["","PLAIN DOWN",0];
	titleCut["","black in",1];		
	
//	player addEventHandler ["Killed", "_this spawn Player_Respawn"];
	

/*	[] spawn {
		call Show_Markers;
	};	*/
	
};

Player_Respawn =
{
	[] spawn {
		titleCut["","black out",4];
		sleep 4;
//		cutRsc ["OSD_BackBlack","plain"];
		titleCut ["", "BLACK FADED", 999];
	};	
	
	waitUntil{(alive player)};
//	cutRsc ["OSD_BackBlack","plain"];	
	titleCut ["", "BLACK FADED", 999];

	Local_NeedRespawn = true;
	
	
//	diag_log format["Player respawn started: %1", player];
	
};



Convert_Direction =
{
	private ["_a","_d","_t","_r"];
	
	_a=_this;
	_d="";
	_r="";	
	if(_a>=337.5||_a<22.5)then
	{
		_r="N";
	};
	if(_a>=292.5&&_a<337.5)then
	{
		_r="NW";
	};
	if(_a>=247.5&&_a<292.5)then
	{
		_r="W";
	};
	if(_a>=202.5&&_a<247.5)then
	{
		_r="SW";
	};
	if(_a>=157.5&&_a<202.5)then
	{
		_r="S";
	};
	if(_a>=112.5&&_a<157.5)then
	{
		_r="SE";
	};
	if(_a>=67.5&&_a<112.5)then
	{
		_r="E";
	};
	if(_a>=22.5&&_a<67.5)then
	{
		_r="NE";
	};
	_r

};