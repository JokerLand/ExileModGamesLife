//Message d'intro
["text"] execVM "scripts\intro.sqf";
//Mission AI
execVM "blckClient.sqf";

if (isServer) then {
	[] execVM "\q\addons\custom_server\init.sqf";
};