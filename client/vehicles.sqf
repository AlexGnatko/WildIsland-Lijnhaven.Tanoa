private ['_found', '_i', '_ae', '_veh'];

while{true} do
{
	{
		_veh = _x;
		if([_veh, "server_vehicle", false] call Get_Var) then
		{
			_found = (Client_SeenVehicles find _veh);
			if(_found == -1) then
			{
				_veh call AddVehicleActions;			
//				diag_log format["Added actions to %1 (%2)", _veh, _veh call VehicleType];
				
				Client_SeenVehicles = Client_SeenVehicles + [_veh];
			};
		};
	} forEach vehicles;
	
	_i = 0;
	{
		if(!(alive _x)) then
		{
			Client_SeenVehicles set [_i, objNull];
		};
		_i = _i + 1;
	} forEach Client_SeenVehicles;
	
	Client_SeenVehicles = Client_SeenVehicles - [objNull];

	//	diag_log Client_SeenVehicles;
	
	sleep 5;
	
}