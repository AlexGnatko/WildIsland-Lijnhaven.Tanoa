AddVehicleActions =
{
	_name = _this call VehicleType;
	
	// Field repairs
	_this addAction [
	"<t color='#4C4FFF'>"+(format["Field repairs: %1",_name])+"</t>",
	"client\actions.sqf",
	[1],
	100,
	false,
	true,
	"", 
	"(vehicle _this == _this) 
	&& (alive _target) 
	&& (
	!(canMove _target) || 
	((getDammage _target) > 0.1) || 
	((fuel _target) == 0)
	)
	&& 
	!( [_this, ""doing_field_repairs"", false] call Get_Var)"];
	
};
