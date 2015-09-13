/*
    My-DayZ.fr
	Auteur: Djoe45
	File: intro.sqf
*/
sleep 25;
private ["_camera", "_preload","_camera_pos_debut","_random","_role1","_role4","_memberFunction","_memberNames","_finalText",
"_role1names","_role2names","_role3names","_role4names","_onScreenTime","_selecteur"];
waitUntil{!isNull (findDisplay 46)};
_selecteur = _this select 0;

_role1 = "Bienvenue !";
_role1names = ["Serveur Exile Mode De GamesLife.fr"];
_role2 = "Interdit:";
_role2names = ["Glitch, Duplication, Hack, Camp Zone Save"];
_role3 = "Notre site web:";
_role3names = ["enconstruction"];
_role4 = "TeamSpeak 3:";
_role4names = ["ts3.altislifefr.com"];

_onScreenTime = 4;

if (_selecteur == "text") then
{
	{
		sleep 6;
		_memberFunction = _x select 0;
		_memberNames = _x select 1;
		_finalText = format ["<t size='0.55' color='#EC0118' align='right'>%1<br /></t>", _memberFunction];
		_finalText = _finalText + "<t size='0.75' color='#FFFFFF' align='right'>";
		{_finalText = _finalText + format ["%1<br />", _x]} forEach _memberNames;
		_finalText = _finalText + "</t>";
		_onScreenTime + (((count _memberNames) - 1) * 0.5);
	[
		_finalText,
		[safezoneX + safezoneW - 0.8,0.50], //DEFAULT: 0.5,0.35
		[safezoneY + safezoneH - 0.8,0.7], //DEFAULT: 0.8,0.7
		_onScreenTime,
		0.5
	] spawn BIS_fnc_dynamicText;
	sleep (_onScreenTime);
	} forEach [
		[_role1, _role1names],
		[_role2, _role2names],
		[_role3, _role3names],
		[_role4, _role4names]

	];

};

if (_selecteur == "camera") then
{
	private ["_camera", "_preload","_camera_pos_debut"];
	_camera_pos_debut = [getpos player select 0,getpos player select 1,(getpos player select 2)+600 ];
	_camera = "camera" CamCreate _camera_pos_debut;
	_camera cameraEffect ["internal","back"];

	_camera camPreparePos _camera_pos_debut;
	_camera camPrepareFOV 0.700;
	_camera camPrepareTarget [2129.76,2431.93,-99914.01];
	_camera camCommitPrepared 0;

	WaitUntil {camCommitted _camera};

	_camera camPreparePos [getpos player select 0,getpos player select 1,(getpos player select 2)+1 ];
	_camera camPrepareFOV 0.700;
	_camera camCommitPrepared 10;
	WaitUntil {camCommitted _camera};

	player cameraEffect ["terminate","back"];
	camDestroy _camera;
};