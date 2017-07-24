
private ['_yes', '_diff'];

while{true} do
{
	
	_diff = (rating player);
	if(_diff < 0) then
	{
		(player) addRating -_diff;
	};
	
	sleep 0.5;
	
}
