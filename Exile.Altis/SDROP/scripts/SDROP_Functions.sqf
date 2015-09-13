// PLAYER DEFINED LOOT TABLES - EDIT ITEMS BELOW FOR CRATES
//Defines LOOT types and gets added to the drop crate
SDROPLoadLootFood = {
	private["_crate"];
	_crate = _this select 0;
	
	//empty crate first
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	clearBackpackCargoGlobal _crate;
	clearItemCargoGlobal _crate;
	
	//fill the crate with FOOD & CLOTHING
	_crate addMagazineCargoGlobal ["Exile_Item_BBQSandwich",2];
	_crate addMagazineCargoGlobal ["Exile_Item_SausageGravy",2];
	_crate addMagazineCargoGlobal ["Exile_Item_Matches",2];
	_crate addMagazineCargoGlobal ["Exile_Item_Catfood",2];
	_crate addMagazineCargoGlobal ["Exile_Item_GloriousKnakworst",2];
	_crate addMagazineCargoGlobal ["Chemlight_green",2];
	_crate addMagazineCargoGlobal ["11Rnd_45ACP_Mag",2];
	_crate addMagazineCargoGlobal ["Exile_Item_PlasticBottleFreshWater",2];
	_crate addMagazineCargoGlobal ["B_Bergen_mcamo",4];
	_crate addMagazineCargoGlobal ["Exile_Item_InstaDoc",1];		
};

SDROPLoadLootSupplies = {
	private["_crate"];
	_crate = _this select 0;
	
	//empty crate first
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	clearBackpackCargoGlobal _crate;
	clearItemCargoGlobal _crate;
	
	//fill the crate with SUPPLIES
	_crate addMagazineCargoGlobal ["Exile_Item_JunkMetal",8];
	_crate addMagazineCargoGlobal ["Exile_Melee_Axe",3];
	_crate addMagazineCargoGlobal ["Exile_Item_PortableGeneratorKit",1];
	_crate addMagazineCargoGlobal ["Exile_Item_FuelCanisterEmpty",1];
	_crate addMagazineCargoGlobal ["Exile_Item_DuctTape",2];
	_crate addMagazineCargoGlobal ["Exile_Item_CamoTentKit",1];
	_crate addMagazineCargoGlobal ["Exile_Item_InstaDoc",1];	
};

SDROPLoadLootWeapons = {
	private["_crate"];
	_crate = _this select 0;
	
	//empty crate first
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	clearBackpackCargoGlobal _crate;
	clearItemCargoGlobal _crate;
	
	//fill the crate with WEAPONS and AMMO
	_crate addWeaponCargoGlobal ["150Rnd_93x64_Mag",1];
	_crate addMagazineCargoGlobal ["arifle_Katiba_GL_F",2];
	_crate addWeaponCargoGlobal ["arifle_MX_F",1];
	_crate addMagazineCargoGlobal ["30Rnd_556x45_Stanag",4];
	_crate addWeaponCargoGlobal ["arifle_MX_Black_F",2];
	_crate addMagazineCargoGlobal ["Exile_Item_InstaDoc",2];
};

SDROPLoadLootRandom = {
	[_crate] call SDROPRandomLoot;
};

// Crate Blacklist - These are items that should NOT be in random crate - should eliminate most BE filter issues (may need more testing)
SDROPCrateBlacklist = [
	"DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag", "ATMine_Range_Mag",
	"ClaymoreDirectionalMine_Remote_Mag", "APERSMine_Range_Mag",
	"APERSBoundingMine_Range_Mag", "SLAMDirectionalMine_Wire_Mag",
	"APERSTripMine_Wire_Mag", "NVGoggles_OPFOR", "NVGoggles_INDEP",
	"FirstAidKit", "Medikit", "ToolKit", "optic_DMS"
];

SDROPRandomLoot = {
	private ["_crate","_var","_tmp","_kindOf","_report","_cAmmo"];
	
	_crate = _this select 0;
	
	// Empty Crate
	clearWeaponCargoGlobal _crate;
	clearMagazineCargoGlobal _crate;
	clearBackpackCargoGlobal  _crate;
	clearItemCargoGlobal _crate;
	
	SDROPLootList = [];
	// Generate Loot
	{
	 _tmp = (getArray(_x >> 'items'));
	 {SDROPLootList = SDROPLootList + [ ( _x select 0 ) select 0 ];} forEach (_tmp);
	} forEach ("configName _x != 'Uniforms' && configName _x != 'Headgear'" configClasses (configFile >> "CfgLootTable"));
	
	_report = [];
	// Load Random Loot Amount
	for "_i" from 1 to ((floor(random 10)) + 10) do {
		_var = (SDROPLootList call BIS_fnc_selectRandom);
		
		if (!(_var in SDROPCrateBlacklist)) then {
			switch (true) do
			{
				case (isClass (configFile >> "CfgWeapons" >> _var)): {
					_kindOf = [(configFile >> "CfgWeapons" >> _var),true] call BIS_fnc_returnParents;
					if ("ItemCore" in _kindOf) then {
						_crate addItemCargoGlobal [_var,1];
					} else {
						_crate addWeaponCargoGlobal [_var,1];
						
						_cAmmo = [] + getArray (configFile >> "cfgWeapons" >> _var >> "magazines");
						{
							if (isClass(configFile >> "CfgPricing" >> _x)) exitWith {
								_crate addMagazineCargoGlobal [_x,2];
							};
						} forEach _cAmmo;
					};
				};
				case (isClass (configFile >> "cfgMagazines" >> _var)): {
					_crate addMagazineCargoGlobal [_var,1];
				};
				case ((getText(configFile >> "cfgVehicles" >> _var >>  "vehicleClass")) == "Backpacks"): {
					_crate addBackpackCargoGlobal [_var,1];
				};
				default {
					_report = _report + [_var];
				};
			};
		};
	};
	
	if ((count _report) > 0) then {
		diag_log text format ["[SDROP]: LoadLoot: <Unknown> %1", str _report];
	};
};

SDROPBroadcast = {
	private ["_title","_subTitle"];
	
	_title = _this select 0;
	_subTitle = _this select 1;
	
	_alertMsg = "<t color='#FFCC00' size='1.0' font='PuristaSemibold' shadow='1' shadowColor='#000000' align='center'>" + _title + "</t>";
	_alertMsg = _alertMsg + "<br /><t color='#FFFFFF' size='0.9' font='PuristaLight' shadow='0' align='center'>" + _subTitle + "</t>";
	
	[_alertMsg] execVM "\SDROP\scripts\SDROP_Alert.sqf";
};

SDROPSetAIWaypoints = {
	private ["_grp","_crate"];
	
	_grp = _this select 0;
	_crate = _this select 1;
	_cratePos = getPos _crate;
	
	_wpPatrolGrid = [
		[(_cratePos select 0)+20, (_cratePos select 1), 0],
		[(_cratePos select 0), (_cratePos select 1)+20, 0],
		[(_cratePos select 0)-20, (_cratePos select 1), 0],
		[(_cratePos select 0), (_cratePos select 1)-20, 0]
	];
	
	for "_i" from 0 to ((count _wpPatrolGrid)-1) do {
		_wp = _grp addWaypoint [(_wpPatrolGrid select _i), 0];
		_wp setWaypointType "SAD";
		_wp setWaypointBehaviour "COMBAT";
		_wp setWaypointCompletionRadius 10;
	};
	
	_cycle = _grp addWaypoint [_cratePos, 20];
	_cycle setWaypointType "CYCLE";
	_cycle setWaypointBehaviour "COMBAT";
	_cycle setWaypointCompletionRadius 10;
};

SDROPLoadAIGear = {
	private ["_unit","_isSniper","_prim","_seco","_pAmmo","_hAmmo"];
	
	_unit = _this select 0;
	_isSniper = _this select 1;
	
	if (!isNull _unit) then {
		removeAllWeapons _unit;
		{_unit removeMagazine _x;} forEach (magazines _unit);
		removeAllItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeGoggles _unit;
		removeHeadGear _unit;
		
		if (_isSniper) then {
			// Add Sniper Clothing
			_unit forceAddUniform ("U_O_GhillieSuit");
			_unit addHeadGear (SDROPHeadgearList call BIS_fnc_selectRandom);
			_unit addVest (SDROPVestList call BIS_fnc_selectRandom);
			
			// Add Sniper Weapons & Ammo (default M104 with LR scope and ammo)
			_prim = "srifle_LRR_SOS_F";
			_seco = SDROPPistolsList call BIS_fnc_selectRandom;
		} else {
			//clothing
			_unit forceAddUniform (SDROPUniformList call BIS_fnc_selectRandom);
			_unit addHeadGear (SDROPHeadgearList call BIS_fnc_selectRandom);
			_unit addVest (SDROPVestList call BIS_fnc_selectRandom);
			
			//weapons & Ammo
			_prim = SDROPRiflesList call BIS_fnc_selectRandom;
			_seco = SDROPPistolsList call BIS_fnc_selectRandom;
		};
		
		// Give unit parachute
		_unit addBackpack "B_Parachute";
		
		//NV Goggles for night drops
		if (SunOrMoon < 1) then {
			//_unit addItem "NVG_EPOCH";
			//_unit assignItem "NVG_EPOCH";
		};
		
		//Gotta get paid yo!
		//_kryptoAmount = floor (random 300) +1;
		//_unit setVariable ["krypto", _kryptoAmount];
		
		_pAmmo = [] + getArray (configFile >> "cfgWeapons" >> _prim >> "magazines");
		{
			if (isClass(configFile >> "CfgPricing" >> _x)) exitWith {
				_unit addMagazine _x;
				_unit addMagazine _x;
			};
		} forEach _pAmmo;
		
		_hAmmo = [] + getArray (configFile >> "cfgWeapons" >> _seco >> "magazines");
		{
			if (isClass(configFile >> "CfgPricing" >> _x)) exitWith {
				_unit addMagazine _x;
				_unit addMagazine _x;
			};
		} forEach _hAmmo;
		
		_unit addWeapon _prim;
		_unit selectWeapon _prim;
		_unit addWeapon _seco;

	};
};

SDROPHeadgearList = [
	"H_Beret_blk", "H_Beret_red", "H_Beret_grn"
];

SDROPUniformList = [
	"U_O_CombatUniform_ocamo", "U_O_PilotCoveralls", "U_OG_Guerilla1_1", "U_OG_Guerilla2_1", "U_OG_Guerilla2_3", "U_IG_leader",
	"U_OG_Guerilla3_1", "U_OG_Guerilla3_2", "U_OG_leader", "U_C_WorkerCoveralls", "U_I_CombatUniform_tshirt", "U_I_OfficerUniform",
	"U_CamoRed_uniform", "U_CamoBrn_uniform", "U_CamoBlue_uniform", "U_Camo_uniform", "U_O_CombatUniform_oucamo", "U_I_CombatUniform_shortsleeve"
];

SDROPVestList = [

];

SDROPRiflesList = [
	"srifle_EBR_F","srifle_DMR_01_F","arifle_Katiba_F","arifle_Katiba_C_F","arifle_Katiba_GL_F","arifle_MXC_F","arifle_MX_F",
	"arifle_MX_GL_F","arifle_MXM_F","arifle_SDAR_F","arifle_TRG21_F","arifle_TRG20_F","arifle_TRG21_GL_F","arifle_Mk20_F",
	"arifle_Mk20C_F","arifle_Mk20_GL_F","arifle_Mk20_plain_F","arifle_Mk20C_plain_F","arifle_Mk20_GL_plain_F","SMG_01_F",
	"SMG_02_F","hgun_PDW2000_F","arifle_MXM_Black_F","arifle_MX_GL_Black_F","arifle_MX_Black_F","arifle_MXC_Black_F","Rollins_F",
	"LMG_Mk200_F","arifle_MX_SW_F","LMG_Zafir_F","arifle_MX_SW_Black_F"
];

SDROPPistolsList = [
	"hgun_ACPC2_F","hgun_Rook40_F","hgun_P07_F","hgun_Pistol_heavy_01_F"
];

// Set AI Skills
SDROPSetUnitSkills = {
	private ["_unit","_skillSetArray"];
	
	_unit = _this select 0;
	_skillSetArray = _this select 1;
	
	{
		_unit setSkill [(_x select 0),(_x select 1)];
		//diag_log text format ["[SDROP]: Skill: %1:%2", (_x select 0),(_x select 1)];
	} forEach _skillSetArray;
};

//SkillSets - endurance removed from Arma 3
skillsRookie = [
["aimingAccuracy",0.4],
["aimingShake",0.3],
["aimingSpeed",0.3],
["spotDistance",0.3],
["spotTime",0.3],
["courage",0.4],
["reloadSpeed",0.6],
["commanding",0.6],
["general",1.0]
];

skillsVeteran = [
["aimingAccuracy",0.6],
["aimingShake",0.6],
["aimingSpeed",0.6],
["spotDistance",0.6],
["spotTime",0.6],
["courage",0.6],
["reloadSpeed",0.7],
["commanding",0.8],
["general",1.0]
];

skillsElite = [
["aimingAccuracy",0.8],
["aimingShake",0.75],
["aimingSpeed",0.7],
["spotDistance",0.8],
["spotTime",0.8],
["courage",1.0],
["reloadSpeed",0.8],
["commanding",1.0],
["general",1.0]
];

if (SDROP_Debug) then {
	diag_log text format ["[SDROP]: Functions loaded. Starting supply drop timer."];
};
