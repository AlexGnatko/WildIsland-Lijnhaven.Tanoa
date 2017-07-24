while{true} do
{
	private['_marker'];
	
	if(!Local_DoingRespawn) then
	{
		if((side player) == east) then
		{
			_marker = "respawn_east";
		}else{
			_marker = "respawn_west";	
		};	

		if(((getPos player) distance (getMarkerPos _marker)) < 50) then
		{
			Local_NeedRespawn = true;
		};
	};
	
	if(Local_NeedRespawn) then
	{
		Local_NeedRespawn = false;
		player spawn Player_Do_Respawn;
	};
	
	sleep 1;
};