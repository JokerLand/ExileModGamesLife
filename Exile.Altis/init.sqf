//Message d'intro
["text"] execVM "scripts\intro.sqf";
//Mission AI Wasteland
execVM "blckClient.sqf";

if (isServer) then {
	[] execVM "\q\addons\custom_server\init.sqf";
};
//Mission IA Helico
if (isServer) then {
[] execVM "SDROP\init.sqf";
};