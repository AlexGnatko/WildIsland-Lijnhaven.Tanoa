
Config_Debug = false;


_vehicles =
[

['C_Offroad_01_F',		1,	2],
['O_G_Offroad_01_F',	1,	2],
['B_G_Offroad_01_F', 	1,  2],
['I_MRAP_03_F', 1, 1],
['O_Truck_02_box_F',	1,	4],
['O_G_Van_01_transport_F',	1,	3],
['I_G_Offroad_01_F', 1, 2],
['C_SUV_01_F',	1,	2],
['C_Quadbike_01_F',			6,	1],
['O_Quadbike_01_F',			6,	1]

];

_vehicle_weapons =
[
['srifle_GM6_LRPS_F',	'5Rnd_127x108_Mag',		1,		16],
['srifle_LRR_LRPS_F',	'7Rnd_408_Mag',		1,		16],
['srifle_EBR_DMS_pointer_snds_F',		'20Rnd_762x51_Mag',	1,		10],
['srifle_EBR_Hamr_pointer_F',			'20Rnd_762x51_Mag',	1,		10],
['arifle_MXM_RCO_pointer_snds_F',	'30Rnd_65x39_caseless_mag_Tracer',	1,		10],
['srifle_EBR_ARCO_pointer_snds_F',		'20Rnd_762x51_Mag',		2,		10],
['LMG_Zafir_pointer_F',		'150Rnd_762x51_Box_Tracer',		2,		6],
['srifle_LRR_SOS_F',				'7Rnd_408_Mag',		1,		16]
];

_vehicle_items =
[
['Rangefinder', 2],
['optic_SOS', 4],
['optic_MRCO', 4],
['optic_DMS', 1],
['optic_LRPS', 2],
['optic_tws', 3],
['HandGrenade', 4],
['MiniGrenade', 5]
];

_vehicle_backpacks =
[
['B_AssaultPack_khk', 5],
['B_BergenG', 4],
['B_Carryall_ocamo', 1]
];

_west_bot_classes =
[
['B_G_Soldier_M_F', 1],
['B_T_soldier_M_F', 3],
['B_T_Soldier_F', 6],
['B_T_Recon_JTAC_F', 2]
];

_east_bot_classes =
[
['O_T_Soldier_F', 2],
['O_T_Soldier_M_F', 2],
['O_T_Soldier_universal_F', 4],
['I_C_Soldier_Bandit_5_F', 2],
['I_C_Soldier_Bandit_4_F', 2]
];


Config_Vehicles = [];
Config_Vehicles_WeaponsCnt = [];
Config_SpawningVehicles = [];
Config_VehicleItems = [];
Config_VehicleBackpacks = [];
Config_VehicleWeapons = [];
Config_VehicleWeapons_Idx = [];
Config_VehicleWeapons_Ammo = [];
Config_VehicleWeapons_Ammo_Count = [];
Config_BackpackChance = 0.6;
Config_BotClassesEast = [];
Config_BotClassesWest = [];

{
	_vt = _x select 0;
	_n = _x select 1;
	
	Config_Vehicles = Config_Vehicles + [_vt];
	Config_Vehicles_WeaponsCnt = Config_Vehicles_WeaponsCnt + [_x select 2];
	
	for [{_x = 1; },{_x <= _n; },{_x = _x + 1; }] do {
		Config_SpawningVehicles = Config_SpawningVehicles + [_vt];
	};
} forEach _vehicles;

{
	_vt = _x select 0;
	_n = _x select 2;
	_ammo = _x select 1;
	_ammocount = _x select 3;

	Config_VehicleWeapons_Idx = Config_VehicleWeapons_Idx + [_vt];
	Config_VehicleWeapons_Ammo = Config_VehicleWeapons_Ammo + [_ammo];		
	Config_VehicleWeapons_Ammo_Count = Config_VehicleWeapons_Ammo_Count + [_ammocount];
	
	for [{_x = 1; },{_x <= _n; },{ _x = _x + 1; }] do {
		Config_VehicleWeapons = Config_VehicleWeapons + [_vt];	
	};
} forEach _vehicle_weapons;

{
	_vt = _x select 0;
	_n = _x select 1;

	for [{_x = 1; },{_x <= _n; },{ _x = _x + 1; }] do {
		Config_VehicleItems = Config_VehicleItems + [_vt];	
	};
	
} forEach _vehicle_items;

{
	_vt = _x select 0;
	_n = _x select 1;

	for [{_x = 1; },{_x <= _n; },{ _x = _x + 1; }] do {
		Config_VehicleBackpacks = Config_VehicleBackpacks + [_vt];	
	};
} forEach _vehicle_backpacks;

{
	_vt = _x select 0;
	_n = _x select 1;

	for [{_x = 1; },{_x <= _n; },{ _x = _x + 1; }] do {
		Config_BotClassesEast = Config_BotClassesEast + [_vt];	
	};
} forEach _east_bot_classes;

{
	_vt = _x select 0;
	_n = _x select 1;

	for [{_x = 1; },{_x <= _n; },{ _x = _x + 1; }] do {
		Config_BotClassesWest = Config_BotClassesWest + [_vt];	
	};
} forEach _west_bot_classes;

Config_FreeVehiclesCount = 10;
Config_SideBots = 8;

Config_VehicleSpawnLocations = 
[
"vehicle_spawn_1","vehicle_spawn_2","vehicle_spawn_3","vehicle_spawn_4","vehicle_spawn_5",
"vehicle_spawn_6","vehicle_spawn_7","vehicle_spawn_8","vehicle_spawn_9",
"vehicle_spawn_10","vehicle_spawn_11"
];

// Dead vehicles / bodies removal timeout
Config_RemoveDeadVehicles = 600;
Config_RemoveDeadBodies = 600;

Config_GroupsRemovePeriod = 600;

Config_PlayerSpawnLocations = [];

for [{ _x = 1; }, { _x <= 36; }, { _x = _x + 1; }] do {
	Config_PlayerSpawnLocations = Config_PlayerSpawnLocations + [format["spawn_%1", _x]];
};

Public_Client_New = nil;
Public_Server_New = nil;

