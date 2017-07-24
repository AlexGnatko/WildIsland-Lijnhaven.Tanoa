
class RscYesNo {
	movingEnable = 1;
	idd = 4000;
	onLoad = "";
	onUnLoad = "";
	
	class controlsBackground {
		class Mainback : RscText {
			colorBackground[] = {0, 0, 0, 0.700000};
			idc = -1;
			x = 0.15;
			y = 0.3;
			w = 0.6;
			h = 0.3;
		};
	};
	
	class controls {
		class Label: RscText_ext {
			idc = 4800;
			text = "Label";
			default = 0;
			x = 0.225;
			y = 0.325;
		};		
		class CA_Apply : RscShortcutButton {
			idc = -1;
			default = 0;
			x = 0.5;
			y = 0.5;
			text = "Yes!";
			action = "closedialog 0; Last_Yes = true";
		};	
		class CA_Deny : RscShortcutButton {
			idc = -1;
			default = 0;
			x = 0.2;
			y = 0.5;
			text = "No!";
			action = "closedialog 0; Last_Yes = false";
		};			
		class CA_Text: RscText_ext
		{
			idc = 4900;
			style = 16;
			lineSpacing=1.0;
			default = 0;
			x = 0.225;
			y = 0.385;
			w = 0.8;
			h = 0.07;
			SizeEx = 0.03;
			text = "This is text";
		};		
	};
};
