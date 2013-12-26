#define PLUGIN_VERSION "2.1"
/*====================================================================================================================
======================================================================================================================

                                                                        ______818�811118���81_8111111__11��1�8____111
                                                                        8111_181�1____8�������������811_____1888_____
                                                                        1��18181____1����������������1111_____8�_____
                                                                        1��1181___1������������8818���88111____188�88
                                                                        111111___18���������������1__18881111____1�8�
                                                                        18�8111_118118������8���8888___1111111____1�8
 .d8888b.                                       8888888888 d8b          888111__8811881118811_11811181__11_11___1____
d88P  Y88b                                      888        Y8P          ___81__��1181111_11188___81__88___1111___11__
Y88b.                                           888                     ___81_1�1181______111881__11__181____11____11
 "Y888b.    8888b.  88888b.  88888b.  888  888  8888888    888 888  888 __88__��1111_________1181__11___81__1_11____1
    "Y88b.     "88b 888 "88b 888 "88b 888  888  888        888 `Y8bd8P' _181_1��811___1_________881_1____11____11_1__
      "888 .d888888 888  888 888  888 888  888  888        888   X88K   _�11_���81_1______________11_1____1_____11_1_
Y88b  d88P 888  888 888 d88P 888 d88P Y88b 888  888        888 .d8""8b. 1�811����1__1_________________1_________1_111
 "Y8888P"  "Y888888 88888P"  88888P"   "Y88888  888        888 888  888 88�18���8111_1_________________1____1___1__11
                    888      888           888                          ���_����11______________________11___8__11_11
                    888      888      Y8b d88P                          8�8_���1_________________________8�8__1__8_1_
                    888      888       "Y88P"                           ��11�����������811______1118���81_1�1_1__11_1
                                                                        ��1�����������������81__1888���111_1�__1_1811
                                                                        ��1������������1�����_____18_1��81����__1_881
                                                                        ��1��������1881__18�1______1__11___1��__111�8
                                                                        �88���118�8111____111_______________1�1_11188
                                                                        �18���1__111_____11�1________________11118118
                                                                        8_����81_________18�1_________________8118818
                                                                        81�����811_______8�1__________________11_8811
                                                                        81������11111___18��1_________________811_�_1
                                                                        818������11111__1����8118�____________811_81_
888                                             d8b 8888888888 d8b 888  �18������8811___1������__1____________818_81_
888                                             Y8P 888        Y8P 888  �88��������81_1118��1181______________188181_
888                                                 888            888  �88���������8111118___1_______________88118__
88888b.  888  888     888d888  8888b.  88888888 888 8888888    888 888  ��8���������8��������11111_1181_______8�1881_
888 "88b 888  888     888P"       "88b    d88P  888 888        888 888  ���8��������8118���1111___1___1_______��1881_
888  888 888  888     888     .d888888   d88P   888 888        888 888  88����������81_118888�8811_____1_____8�81�11_
888 d88P Y88b 888     888     888  888  d88P    888 888        888 888  ��8�����������81111118811_____1111111��888111
88888P"   "Y88888     888     "Y888888 88888888 888 8888888888 8888888888888�����������11111_________1118�11181881__1
              888                                                       ���1�88��������88111_181__11118��8111_181___1
         Y8b d88P                                                       ���1��8����������811_11111_118�81__1___811__8
          "Y88P"                                                        11818�8_8������������8��8���811____11__11_111
                                                                        _____811_����������������811_______1__8__11__
                                                                        11___181__8�����������811_____________�8111__
                    +-+-+-+-+-+-+-+-+ +-+-+-+-+                         _____111___1��8���88881111____________��818__
                    |R|e|m|e|m|b|e|r| |K|u|r|t|                         _____1�_1____181111111111_____________��118__
                    +-+-+-+-+-+-+-+-+ +-+-+-+-+                         __1__1�1_1_____11111_________________1��_1118

=====================================================================================================================
====================================================================================================================*/
#include <sourcemod>
#include <sdktools>
#pragma semicolon 1

//=================
#define debug2 0

#define LOG2		"logs\\crash_log.log"

#if debug2
static	String:DEBUG2[256];
#endif
//===============

/*=====< debug >=====*/
#define debug 0 // on,off

#define KillBill 0 // skip Bill

/*=====================
  * Tag & Log & Sound *
=======================*/
#define FS		"[Sappy Fix]"
#define FD		"[Defib Fix]"
#define FM		"[Model Fix]"

#define DEFIB_FIX	2
#define CLEAR_ALL	3

#define LOG		"logs\\fix_sappy.log"

#if debug
static	String:DEBUG[256];
#endif

/*=====================
      * ConVar *
=======================*/

static	Handle:g_hSf, Handle:g_hBebop, Handle:g_hSurvivor, Handle:g_hTimer, Handle:g_hItems, Handle:g_hGameMode,
		Handle:hFreeze, Handle:g_hDef, Handle:g_hModel, Handle:g_hxTimer,

		bool:bBlock[6], bool:bMapChange,

		bool:g_bCvarSf, g_iCvarMin, g_iCvarMax, g_iCvarItems, bool:g_bCvarDef, Float:g_fCvarTimer, Float:g_fCvarXTimer,

		afk[MAXPLAYERS+1], loading[MAXPLAYERS+1], Ghost[MAXPLAYERS+1], Handle:hzTimer[MAXPLAYERS+1],
		String:sModel[MAXPLAYERS+1][64], iData[MAXPLAYERS+1];


public Plugin:myinfo =
{
	name = "[L4D & L4D2] Sappy Fix",
	author = "raziEiL [disawar1]",
	description = "Smells Like Bug Spirit ^^",
	version = PLUGIN_VERSION,
	url = "http://steamcommunity.com/id/raziEiL"
}

/*=====================
	* PLUGIN START! *
=======================*/
public OnPluginStart()
{
	#if debug
		BuildPath(Path_SM, DEBUG, sizeof(DEBUG), LOG);
	#endif

	#if debug2
		BuildPath(Path_SM, DEBUG2, sizeof(DEBUG2), LOG2);
	#endif
	CreateConVar("sappy_fix_version", PLUGIN_VERSION, "Sappy Bug Fix plugin version", FCVAR_REPLICATED|FCVAR_NOTIFY);

	g_hSf			=	CreateConVar("sappy_fix_sacrifice", "1", "1: Enable Sacrifice Bug Fix for survival mode, 0: Disable fix", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	g_hBebop		=	CreateConVar("sappy_fix_bebop", "4", "Min amount of Survivors when round starts, 0: Disable fix if u not use bebop, MultiSlots, bot_l4d plugins. Note: sometimes bebop cant kick bot when player leave.", FCVAR_PLUGIN);
	g_hSurvivor	=	CreateConVar("sappy_fix_extrabots", "0", "Max amount of Survivors on your server, 0: Disable fix if u not use SuperVersus, L4D Players. Note: sometimes you can see more bots than in the your cfg", FCVAR_PLUGIN);
	g_hTimer		=	CreateConVar("sappy_fix_timer", "10", "Check Survivors limit after x.x sec when round started, 0: Disable checking", FCVAR_PLUGIN);
	g_hItems		=	CreateConVar("sappy_fix_dropitems", "1", "1: Delete all player or bot items when they disconnected, 0: Disable fix. Note: This options blocks item spam for bebop, multislot.. plugin", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	g_hDef		=	CreateConVar("sappy_fix_defibrillator", "1", "1: Ghost revive bug fix (Bebop), 0: Disable for left 4 dead.", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	g_hModel		=	CreateConVar("sappy_fix_models", "1", "Save survivors model every x.x sec and keep character when going idle/map change, 0: Disable fix.", FCVAR_PLUGIN, true, 0.0, true, 5.0);
	AutoExecConfig(true, "fix_Sappy");

	g_hGameMode	=	FindConVar("mp_gamemode");
	hFreeze		=	FindConVar("sb_stop");

	HookConVarChange(g_hSf, OnCVarChange);
	HookConVarChange(g_hBebop, OnCVarChange);
	HookConVarChange(g_hSurvivor, OnCVarChange);
	HookConVarChange(g_hTimer, OnCVarChange);
	HookConVarChange(g_hItems, OnCVarChange);
	HookConVarChange(g_hDef, OnCVarChange);
	HookConVarChange(g_hModel, OnCVarChange);
	GetCVars();

	//#if debug
	RegAdminCmd("fx", CmdFix, ADMFLAG_ROOT);
	//#endif
}

//#if debug
/* * * Test Command * * */
public Action:CmdFix(client, args)
{
	/*
	new entity = -1;

	for (new i = 1; i <= MaxClients; i++){
		if (IsClientInGame(i) && GetClientTeam(i) == 2)
			PrintToChat(client, "%N (%d), char %d, ghost <%d>", i, i, GetEntProp(i, Prop_Send, "m_survivorCharacter"), Ghost[i]);
		if (hzTimer[i] != INVALID_HANDLE)
			PrintToChatAll("CLIENT (%d) have dead cheking timer", i);
	}
	while ((entity = FindEntityByClassname(entity , "survivor_death_model")) != INVALID_ENT_REFERENCE)
		PrintToChatAll("ghost ent <%d>", entity);

	//GetClientOfUserId(GetEntProp(i, Prop_Send, "m_humanSpectatorUserID"))
	*/
	CreateTimer(0.0, SappyFix, -3);
	return Plugin_Handled;
}
//#endif

public OnMapStart()
{
	#if debug
		LogToFile(DEBUG, "%s ON MAP START", FS);
	#endif

	bBlock[5] = false;

	if (g_bCvarSf && IsSurvivalMode())
		ValidMap();

	if (g_fCvarXTimer > 0)
		bMapChange = false;

	ClearByLoop(CLEAR_ALL);
}
/*										+==========================================+
										| AFK Models 'BUG' - this is not a bug real|
										|					(Saving Client Models) |
										+==========================================+
*/
public MapTranslition(Handle:event, String:event_name[], bool:dontBroadcast)
{
	bMapChange = true;

	#if debug
		LogToFile(DEBUG, "%s MAP TRANSLITION", FM);
	#endif
}

public Action:SaveEntityModel(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++){

		if (IsClientInGame(i) && GetClientTeam(i) == 2 && !IsFakeClient(i)){

			iData[i] = GetEntProp(i, Prop_Send, "m_survivorCharacter");
			GetClientModel(i, sModel[i], 64);

			#if KillBill
				if (StrEqual(sModel[i], "models/survivors/survivor_namvet.mdl"))
					sModel[i] = "\0";
			#endif
		}
	}
}

public Action:Triger(Handle:timer, any:client)
{
	ChangeEntityModel(client, client);
	if (IsClientInGame(client) && !StrEqual(sModel[client], ""))
		LogMessage("%s Model Bug is Fixed!", FM);
}

ChangeEntityModel(client, fake)
{
	if (IsClientInGame(client) && IsClientInGame(fake) && !StrEqual(sModel[client], "")){

		SetEntProp(fake, Prop_Send, "m_survivorCharacter", iData[client]);
		SetEntityModel(fake, sModel[client]);

		#if debug
			LogToFile(DEBUG, "%s Change %N to %N model <%s>", FM, fake, client, sModel[client]);
		#endif
	}
	#if debug
	if (StrEqual(sModel[client], ""))
		LogToFile(DEBUG, "%s uhm INDEX (%d) model <%s> [MISSING!]", FM, client, sModel[client]);
	#endif
}
/*										+==========================================+
										|	 	 Sacrifice BUG FIX  'dead bots'	   |
										|								 (survival)|
										+==========================================+
*/
bool:IsSurvivalMode()
{
	decl String:mode[24];
	GetConVarString(g_hGameMode, mode, sizeof(mode));

	return strcmp(mode, "survival") == 0;
}

ValidMap()
{
	decl String:map[5];
	GetCurrentMap(map, sizeof(map));

	if (strcmp(map, "c7m1") == 0 ||
		strcmp(map, "c7m3") == 0){

		new Handle:g_Rest = FindConVar("mp_restartgame");
		SetConVarInt(g_Rest, 1);

		#if debug
			LogToFile(DEBUG, "%s Valid map \"%s\"", FS, map);
			LogToFile(DEBUG, "%s Sacrifice Bug is fixed!", FS);
		#endif

		LogMessage("%s Sacrifice Bug is Fixed!", FS);
	}
}
/*										+==========================================+
										|	 	 	Bebop BUG FIX  				   |
										|							 (all gamemode)|
										+==========================================+
*/
public PlayerIdle(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "player"));
	new fake = GetClientOfUserId(GetEventInt(event, "bot"));

	if (client){

		if (g_iCvarMin > 0){

			afk[client]=client;
			afk[fake]=afk[client];

			#if debug
				LogToFile(DEBUG, "%s CLIENT (%d), BOT (%d) [IDLE]", FS, client, fake);
			#endif
		}

/*										+------------------------------------------+
										|			 Model Fix PART I 	 		   |
										+------------------------------------------+
*/
		if (g_fCvarXTimer > 0 && GetClientTeam(client) != 3)
			ChangeEntityModel(client, fake);
/*										+------------------------------------------+
										|	 				END 				   |
										+------------------------------------------+
*/

	}
}

public PlayerBack(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client && !IsFakeClient(client)){
/*										+------------------------------------------+
										|	 		Checking PART I   			   |
										+------------------------------------------+
*/
		if (g_fCvarTimer > 0 && g_iCvarMax > 0 && !bBlock[5]){

			#if debug
				LogToFile(DEBUG, "%s Client activated Cheking!", FS);
			#endif

			bBlock[5] = true;
			ValidTime();
		}
/*										+------------------------------------------+
										|	 				END 				   |
										+------------------------------------------+
*/
/*										+------------------------------------------+
										|			 Model Fix PART II 	 		   |
										+------------------------------------------+
*/
		if (g_fCvarXTimer > 0 && GetClientTeam(client) != 2)
			CreateTimer(0.01, Triger, client);
/*										+------------------------------------------+
										|	 				END 				   |
										+------------------------------------------+
*/
		if (g_iCvarMin > 0){

			if (loading[client] != 0 && GetClientTeam(client) != 1)
				CreateTimer(1.0, TakeOverBot, client); // client connected and takeover the control of alive survivor bot

			if (GetClientTeam(client) != 2)
				IdleStatus(client);
		}
	}
}

public Action:TakeOverBot(Handle:timer, any:client)
{
	loading[client] = 0;
	CreateTimer(0.1, SappyFix, -1);

	#if debug
		LogToFile(DEBUG, "%s INDEX (%d) %d [CONNECTED!]", FS, client, loading[client]);
	#endif
}

public OnClientConnected(client)
{
	if (client && !IsFakeClient(client)){
		loading[client] = 1;

		#if debug
			LogToFile(DEBUG, "%s %N (%d) %d [CONNECT...]", FS, client, client, loading[client]);
		#endif
	}
}

public OnClientDisconnect(client)
{
	if (client && !bMapChange){

		if (!IsFakeClient(client)){

			#if debug
				LogToFile(DEBUG, "%s INDEX (%d) [DISCONNECT]", FS, client);
			#endif

			if (loading[client] != 0)
				loading[client] = 0;

			if (g_iCvarMin != 0){
				IdleStatus(client);
				CreateTimer(1.0, SappyFix, client); // we wait when a bot join in the game
			}
			if (g_fCvarXTimer > 0)
				sModel[client] = "\0"; // clear player model
		}
		else
			if (IsClientInGame(client) && !IsBehopClient(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
				Items(client);

		KillGhostByInput(client);
	}
}

/**
*	id = -1 (TAKE OVER)
*	id = -2 (Round Start Checking)
*	id = -3 (By !fx cmd)
*	any other value this is client index (OnClientDisconnect)
*/
public Action:SappyFix(Handle:timer, any:id)
{
	#if debug
		LogToFile(DEBUG, "%s ======= SAPPY FIX ===========", FS);
	#endif

	new fake, fafk, spectator, total, connected, log;

	for (new i = 1; i <= MaxClients; i++){

		if (loading[i] != 0)
			connected++;

		if (IsClientInGame(i) && GetClientTeam(i) != 3){

			if (GetClientTeam(i) == 2){

				if (IsFakeClient(i)){

					if (afk[i] == 0)
						fake++;
					else
						fafk++;

					#if debug
						LogToFile(DEBUG, "%s [STEP 1] Fake INDEX (%d), afk = %d", FS, i, afk[i]);
					#endif
				}
				total++;
			}
			if (afk[i] != 0 && !IsFakeClient(i))
				spectator++;
		}
	}

	#if debug
		new v = fake + fafk;
		new x = total - v;
		LogToFile(DEBUG, "%s [STEP 2] Client: %d, Fake: %d, Spec: %d, Connect: %d", FS, x, v, spectator, connected);
	#endif

	for (new i = 1; i <= MaxClients; i++){

		if (IsClientInGame(i) && GetClientTeam(i) == 2){

			if (total > g_iCvarMin && fake > connected && !IsBehopClient(i) && afk[i] == 0 && IsFakeClient(i)){

				total--;
				fake--;
				log++;
				KickClient(i);

				#if debug
					PrintToChatAll("%s kick %N", FS, i);
					LogToFile(DEBUG, "%s [STEP 3] Client %d leave, kick %N (%d)", FS, id, i, i);
				#endif
			}
		}
	}


		new f = fake + fafk;
		new t = total - f;
		PrintToChatAll("Client: %d, Fake: %d, Spec: %d, Connect: %d", t, f, spectator, connected);
	#if debug
		LogToFile(DEBUG, "%s [STEP 4] KICKED %d BOTS", FS, log);
		LogToFile(DEBUG, "%s [STEP 4] Client: %d, Fake: %d, Spec: %d, Connect: %d", FS, t, f, spectator, connected, log);
	#endif

	new z = GetConVarInt(hFreeze);

	if (z != 0){

		if (g_iCvarItems == 0){
			g_iCvarItems = 1;
			CreateTimer(2.0, DisableItems);
		}

		SetConVarInt(hFreeze, 0);

		if (log != 0){

			#if debug
				LogToFile(DEBUG, "%s Detected \"%d\" extra bot, they have been removed.", FS, log);
				LogToFile(DEBUG, "%s Extra Survivors Bug is fixed! [Bebop]", FS);
			#endif

			LogMessage("%s Extra Survivors Bug is Fixed! [Bebop]", FS);
		}
		#if debug
			else LogToFile(DEBUG, "%s All is okay.", FS);
		#endif
	}
}

IdleStatus(const client)
{
/*
 - Function:
 - When Idle player leave game find his bot and change afk status to 0.
 - When Idle player back change bot with client afk status to 0. (work with !spectate etc cmd.)
 - Defib fix when player was afk and his bot dies change bot ghost data to client data.
 */
	if (afk[client] != 0){

		for (new i = 1; i <= MaxClients; i++){

			if (i != client && afk[i] == client){

				#if debug
					LogToFile(DEBUG, "%s CLIENT (%d) [leave] or [BACK], BOT (%d) afk=0", FS, client, i);
				#endif

				if (g_bCvarDef && Ghost[i] != 0){

					#if debug
						LogToFile(DEBUG, "%s Change BOT (%d) Ghost <%d> to CLIENT (%d)", FD, i, Ghost[i], client);
					#endif

					Ghost[client] = Ghost[i];
					TimeToKill(i);
				}
				afk[i]=0;
				break;
			}
		}
		afk[client]=0;
	}
}

bool:IsBehopClient(client)
{
/*
 - Note: fake client created for player,
			different plugins use the same names.

	+==========================================+
		fake name   		|	plugin
	|==========================================|
	 "I am not real."		|	bot_l4d
	 "bebop_bot_fakeclient"	|	bebop
	 "FakeClient"			|	MultiSlots
	 "Not in Ghost."		|	L4D Players
	 "SurvivorBot"			|	SuperVersus

 - Function:
 - dont delete iteam when fake bot created for player.
 - dont kick fake bot when some player leave.
*/
	decl String:name[32];
	GetClientName(client, name, sizeof(name));
	if (StrContains(name, "bebop_bot_fakeclient", false) != -1 ||
		StrContains(name, "I am not real.", false) != -1 ||
		StrContains(name, "FakeClient", false) != -1 ||
		StrContains(name, "Not in Ghost.", false) != -1 ||
		StrContains(name, "SurvivorBot", false) != -1){
		#if debug
			LogToFile(DEBUG, "%s DETECTED FAKE BOT '%s'", FS, name);
		#endif
		return true;
	}
	return false;
}
/*										+==========================================+
										|	 	 	Item Spam FIX  				   |
										|							 (all gamemode)|
										+==========================================+
*/
public Action:DisableItems(Handle:timer)
{
	g_iCvarItems = 0;
}

Items(client)
{
	if (g_iCvarItems == 1){

		for (new x = 0; x <= 4; x++){

			new slot = GetPlayerWeaponSlot(client, x);

			if (slot > 0 && RemovePlayerItem(client, slot) && IsEquipWeapon(slot)){
				#if debug2
					LogToFile(DEBUG2, "Items(%N) -> AcceptEntityInput(%d, \"kill\")", client, slot);
				#endif
				AcceptEntityInput(slot, "Kill");
			}
		}
	}
}

bool:IsEquipWeapon(iEnt)
{
	if (!iEnt || !IsValidEntity(iEnt))
		return false;

	decl String:sWeapClass[32];
	GetEntityClassname(iEnt, sWeapClass, sizeof(sWeapClass));
	// ���������� ����� - �� ��������� "weapon_spawn" � ������ �������� ������� ������ ������

	#if debug2
		LogToFile(DEBUG2, "bool:IsEquipWeapon(%d) -> Classname \"%s\"", iEnt, sWeapClass);
	#endif

	return StrContains(sWeapClass, "weapon_") != -1 && !(StrContains(sWeapClass, "_weapon") != -1 || StrContains(sWeapClass, "_spawn") != -1);
}
/*										+------------------------------------------+
										|	 		Checking PART II   		(Timer)|
										+------------------------------------------+
*/
public RoundStart(Handle:event, String:event_name[], bool:dontBroadcast)
{
	#if debug
		LogToFile(DEBUG, "%s ROUND START", FS);
	#endif

	ClearByLoop(DEFIB_FIX);

	if (g_fCvarTimer > 0 && bBlock[5])
		ValidTime();
}

ValidTime()
{
	#if debug
		LogToFile(DEBUG, "%s Cheking please wait...", FS);
	#endif

	SetConVarInt(hFreeze, 1);

	if (g_iCvarMin > 0)
		CreateTimer(g_fCvarTimer, SappyFix, -2);
	else if (g_iCvarMax > 0)
		CreateTimer(g_fCvarTimer, DoIt);
}
/*										+==========================================+
										|	 	Extra SURVIVORS Bots BUG FIX       |
										|							 (all gamemode)|
										+==========================================+
*/
public Action:DoIt(Handle:timer)
{
	ValidLimit();
}

ValidLimit()
{
	new x, k;

	for (new i = 1; i <= MaxClients; i++)
		if (IsClientInGame(i) && GetClientTeam(i) == 2)
			x++;

	for (new i = 1; i <= MaxClients; i++){
		if (IsClientInGame(i) && GetClientTeam(i) == 2){
			if (x > g_iCvarMax && IsFakeClient(i)){
				k++;
				x--;
				KickClient(i);
			}
		}
	}

	if (k != 0){

		#if debug
			LogToFile(DEBUG, "%s Detected \"%d\" extra bot, they have been removed.", FS, k);
			LogToFile(DEBUG, "%s Extra Survivors Bug is fixed! [SUPER VERSUS]", FS);
		#endif

		LogMessage("%s Extra Survivors Bug is Fixed! [SUPER VERSUS]", FS);
	}
	#if debug
		else LogToFile(DEBUG, "%s All is okay.", FS);
	#endif

	SetConVarInt(hFreeze, 0);
}
/*										+==========================================+
										|	 Defibrillator (Ghost, alive) BUG FIX  |
										|							 (all gamemode)|
										+==========================================+
*/
public Event_PlayerDead(Handle:event, String:event_name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	if (client && GetClientTeam(client) == 2){

		if (Ghost[client] != 0){

			#if debug
				LogToFile(DEBUG, "%s WTF??? Player have 2 death model %N (%d) <%d> [GHOST DETECTED!]", FD, client, client, Ghost[client]);
			#endif

			KillGhostByInput(client);
		}
		else {

			decl Float:vOrigin_Player[3], Float:vOrigin_Entity[3];
			new entity = -1;

// TRYING TO FIND SURVIVOR DEAD BODY ENTITY BY COORDINATE.

			while ((entity = FindEntityByClassname(entity , "survivor_death_model")) != INVALID_ENT_REFERENCE){

				GetClientAbsOrigin(client, vOrigin_Player);
				GetEntPropVector(entity, Prop_Send, "m_vecOrigin", vOrigin_Entity);

				if (vOrigin_Player[0] == vOrigin_Entity[0] && vOrigin_Player[1] == vOrigin_Entity[1] && vOrigin_Player[2] == vOrigin_Entity[2]){

					Ghost[client] = entity;
					hzTimer[client] = CreateTimer(0.5, IsClientRevived, client, TIMER_REPEAT);

					#if debug
						LogToFile(DEBUG, "%s Save entity <%d> by origin %N (%d)", FD, entity, client, client);
					#endif

					break;
				}
			}

// HARD CHECKING IF WE DID NOT FIND ENTITY

			if (Ghost[client] == 0){

				entity = -1;

				while ((entity = FindEntityByClassname(entity , "survivor_death_model")) != INVALID_ENT_REFERENCE){

					if (NotSavedEntity(entity)){

						Ghost[client] = entity;
						hzTimer[client] = CreateTimer(0.5, IsClientRevived, client, TIMER_REPEAT);

						#if debug
							LogToFile(DEBUG, "%s Save entity <%d> by hardchecing %N (%d) ", FD, entity, client, client);
						#endif

						break;
					}
				}
			}
		}
	}
}

bool:NotSavedEntity(entity)
{
	for (new i = 1; i <= MaxClients; i++)
		if (Ghost[i] == entity)
			return false;
	return true;
}

public Action:IsClientRevived(Handle:timer, any:client)
{
	if (IsClientInGame(client) && IsPlayerAlive(client)){

		#if debug
			LogToFile(DEBUG, "%s Player %N (%d) <%d> [ALIVE]", FD, client, client, Ghost[client]);
		#endif

		KillGhostByInput(client, true);
	}
}

TimeToKill(client)
{
	if (hzTimer[client] != INVALID_HANDLE){
		KillTimer(hzTimer[client]);
		hzTimer[client] = INVALID_HANDLE;

		#if debug
			LogToFile(DEBUG, "%s Death checking CLIENT (%d) [KILL TIMER]", FD, client);
		#endif
	}
	Ghost[client] = 0;
}
/*										+------------------------------------------+
										| 	   Ghost ENDING  (Action fixing)	   |
										+------------------------------------------+
*/
KillGhostByInput(id, bMsg=false)
{
	if (!g_bCvarDef || Ghost[id] == 0) return;

	if (IsValidEntity(Ghost[id]) && IsValidEdict(Ghost[id])){

		decl String:sClass[24];
		GetEdictClassname(Ghost[id], sClass, sizeof(sClass));

		if (strcmp(sClass, "survivor_death_model") == 0){

			#if debug
				if (!bMsg)
					LogToFile(DEBUG, "%s Client disconnected INDEX (%d) <%d> [GHOST BUG DETECTED!]", FD, id, Ghost[id]);
				else
					LogToFile(DEBUG, "%s Player is alive but body still on the ground %N (%d) <%d> [GHOST BUG DETECTED!]", FD, id, id, Ghost[id]);
			#endif

			#if debug2
				LogToFile(DEBUG2, "KillGhostByInput(...) -> AcceptEntityInput(%d, \"kill\")", Ghost[id]);
			#endif
			AcceptEntityInput(Ghost[id], "Kill");
		}
	}

	TimeToKill(id);
}

ClearByLoop(action) // action 0 model fix, 1 sappy fix, 2 defib fix, 3 alll
{
	if (bMapChange) return;

	new bool:bIsModelFix, bool:bIsSappyFix, bool:bIsDefibFix;

	if ((action == 0 || action == 3) && g_fCvarXTimer > 0 && !IsSurvivalMode()){ // Survival gamemode? then skip it

		decl String:map[24];
		GetCurrentMap(map, sizeof(map));

		if (strcmp(map, "c1m1_hotel") == 0 ||
			strcmp(map, "c2m1_highway") == 0 ||
			strcmp(map, "c3m1_plankcountry") == 0 ||
			strcmp(map, "c4m1_milltown_a") == 0 ||
			strcmp(map, "c5m1_waterfront") == 0 ||
			strcmp(map, "c6m1_riverbank") == 0 ||
			strcmp(map, "c7m1_docks") == 0 ||
			strcmp(map, "c8m1_apartment") == 0 ||
			strcmp(map, "c9m1_alleys") == 0 ||
			strcmp(map, "c10m1_caves") == 0 ||
			strcmp(map, "c11m1_greenhouse") == 0 ||
			strcmp(map, "c12m1_hilltop") == 0 ||
			strcmp(map, "c13m1_alpinecreek") == 0 ||
			strcmp(map, "2ee_01", false) == 0 ||						// 2EvilEyas
			strcmp(map, "wth_5", false) == 0 ||						// Welcome to Hell
			strcmp(map, "l4d2_7hours_later_01", false) == 0 ||		// 7 Hours Later
			strcmp(map, "l4d2_darkblood01_tanker", false) == 0 || 	// Dark Blood 2
			strcmp(map, "l4d2_city17_01", false) == 0 || 				// City 17
			strcmp(map, "l4d2_motamap_m1", false) == 0 ||  			// A Dam Mission
			strcmp(map, "qe_1_cliche", false) == 0 ||					// Questionable Ethics
			strcmp(map, "l4d_5tolife01", false) == 0 ||				// 25 To Life
			strcmp(map, "uf1_boulevard", false) == 0){				// Urban Flight

			bIsModelFix = true;

			#if debug
				LogToFile(DEBUG, "%s --------- %s ---------", FM, map);
			#endif
		}
	}
	if (action == 0 && !bIsModelFix) return;

	if ((action == 1 || action == 3) && g_iCvarMin > 0)
		bIsSappyFix = true;

	if ((action == 2 || action == 3) && g_bCvarDef)
		bIsDefibFix = true;

	for (new i = 1; i < MaxClients; i++){

		if (bIsModelFix)
			sModel[i] = "\0";

		if (bIsSappyFix){
			loading[i] = 0;
			afk[i] = 0;
		}

		if (bIsDefibFix)
			TimeToKill(i);
	}

	#if debug
		LogToFile(DEBUG, "[CLEAR BY LOOP] %s - %s, %s - %s, %s - %s.", FM, bIsModelFix ? "YES" : "NO", FS, bIsSappyFix ? "YES" : "NO", FD, bIsDefibFix ? "YES" : "NO");
	#endif
}

/*=====================
	* GetConVar *
=======================*/
public OnCVarChange(Handle:convar_hndl, const String:oldValue[], const String:newValue[])
{
	GetCVars();
}

public OnConfigsExecuted()
{
	#if debug
		LogToFile(DEBUG, "%s ON CONFIG EXECUTED", FS);
	#endif

	GetCVars();
}

GetCVars()
{
	g_bCvarSf = GetConVarBool(g_hSf);
	g_iCvarMax = GetConVarInt(g_hSurvivor);
	g_iCvarItems = GetConVarInt(g_hItems);
	g_iCvarMin = GetConVarInt(g_hBebop);
	g_fCvarTimer = GetConVarFloat(g_hTimer);
	g_bCvarDef = GetConVarBool(g_hDef);
	g_fCvarXTimer = GetConVarFloat(g_hModel);

	if (g_hxTimer != INVALID_HANDLE){
		KillTimer(g_hxTimer);
		g_hxTimer = INVALID_HANDLE;
	}
	if (g_fCvarXTimer != 0)
		g_hxTimer = CreateTimer(g_fCvarXTimer, SaveEntityModel, _, TIMER_REPEAT);

	if ((g_fCvarTimer > 0 || g_bCvarDef) && !bBlock[1]){

		HookEvent("round_start", RoundStart, EventHookMode_PostNoCopy);
		bBlock[1] = true;

		#if debug
			LogToFile(DEBUG, "%s HookEvent", FS);
		#endif
	}
	else if (g_fCvarTimer == 0 && !g_bCvarDef && bBlock[1]){

		UnhookEvent("round_start", RoundStart, EventHookMode_PostNoCopy);
		bBlock[1] = false;

		#if debug
			LogToFile(DEBUG, "%s UnhookEvent", FS);
		#endif
	}
	if ((g_iCvarMin > 0 || g_fCvarXTimer > 0) && !bBlock[2]){

		HookEvent("player_bot_replace", PlayerIdle);
		HookEvent("map_transition", MapTranslition, EventHookMode_PostNoCopy);
		bBlock[2] = true;

		#if debug
			LogToFile(DEBUG, "%s HookEvent II", FS);
		#endif
	}
	else if (g_iCvarMin == 0 && g_fCvarXTimer == 0 && bBlock[2]){

		UnhookEvent("player_bot_replace", PlayerIdle);
		UnhookEvent("map_transition", MapTranslition, EventHookMode_PostNoCopy);
		bBlock[2] = false;

		#if debug
			LogToFile(DEBUG, "%s UnhookEvent  II", FS);
		#endif
	}
	if ((g_iCvarMin > 0 || g_fCvarTimer > 0 || g_fCvarXTimer > 0) && !bBlock[3]){

		HookEvent("player_team", PlayerBack);
		bBlock[3] = true;

		#if debug
			LogToFile(DEBUG, "%s HookEvent III", FS);
		#endif
	}
	else if (g_iCvarMin == 0 && g_fCvarTimer == 0 && g_fCvarXTimer == 0 && bBlock[3]){

		UnhookEvent("player_team", PlayerBack);
		bBlock[3] = false;

		#if debug
			LogToFile(DEBUG, "%s UnhookEvent  III", FS);
		#endif
	}
	if (g_bCvarDef && !bBlock[4]){

		HookEvent("player_death", Event_PlayerDead);
		bBlock[4] = true;

		#if debug
			LogToFile(DEBUG, "%s HookEvent Ghost I", FD);
		#endif
	}
	else if (!g_bCvarDef && bBlock[4]){

		UnhookEvent("player_death", Event_PlayerDead);
		bBlock[4] = false;

		#if debug
			LogToFile(DEBUG, "%s UnhookEvent Ghost I", FD);
		#endif

		ClearByLoop(DEFIB_FIX);
	}
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	if (!IsDedicatedServer())
		return APLRes_Failure;

	decl String:buffer[24];
	GetGameFolderName(buffer, sizeof(buffer));

	if (strcmp(buffer, "left4dead") == 0 ||
		strcmp(buffer, "left4dead2") == 0)
		return APLRes_Success;

	Format(buffer, sizeof(buffer), "Plugin not support \"%s\" game", buffer);
	strcopy(error, err_max, buffer);
	return APLRes_Failure;
}