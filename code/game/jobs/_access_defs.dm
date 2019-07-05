// FOR THE PURPOSES OF THE DEAD SPACE 13 ACCESS STUFF, THESE ARE CURRENTLY USED ACCESS VARIABLES AND WHERE THEY SHOULD BE USED:
// (access_heads) allows access to the bridge.
// (access_armory) allows access to the armory and the chief security officer's private quarters.
// (access_security) allows access to the security offices. when combined with access_mining_station, allows access to PSEC HQ on the colony.
// (access_maint_tunnels) allows access to all maintenance vents both on the ishimura and the colony.
// (access_bar) allows access to the bar.
// (access_kitchen) allows access to the kitchen.
// (access_cargo) allows access to the supply offices.
// (access_mining) allows access to the shuttle used to transport between ship and colony.
// (access_mining_station) allows access to doors around the colony. when combined with access_security, allows access to PSEC HQ on the colony.
// (access_engine) allows access to the engine room and basic tools, such as rock saws, rivet guns and general maintenance tools.
// (access_emergency_storage) allows access to advanced tools such as plasma cutters, plasma torches (blowtorch), that sort of thing.
// (access_external_airlocks) allows access to EVA storage rooms and the external airlocks.
// (access_medical) allows access to the medical wing.
// (access_morgue) allows access to the most dangerous room on the ship.
// (access_surgery) allows access to the surgery room.
// (access_research) allows access to the research wing.
				///////////////////ERT ACCESS BELOW///////////////////
// (access_ai_upload) allows access to the USM valor and its various rooms, components, computers, etc. a universal EDF access rank.
// (access_tcomsat) allows access to the Deliverance and the various unitologist cult related access requiring areas.
// (access_teleporter) allows access to the Kellion and the various components within.


#define ACCESS_REGION_NONE -1
#define ACCESS_REGION_ALL 0
#define ACCESS_REGION_SECURITY 1
#define ACCESS_REGION_MEDBAY 2
#define ACCESS_REGION_RESEARCH 3
#define ACCESS_REGION_ENGINEERING 4
#define ACCESS_REGION_COMMAND 5
#define ACCESS_REGION_GENERAL 6
#define ACCESS_REGION_SUPPLY 7

#define ACCESS_TYPE_NONE 1
#define ACCESS_TYPE_CENTCOM 2
#define ACCESS_TYPE_STATION 4
#define ACCESS_TYPE_SYNDICATE 8
#define ACCESS_TYPE_ALL (ACCESS_TYPE_NONE|ACCESS_TYPE_CENTCOM|ACCESS_TYPE_STATION|ACCESS_TYPE_SYNDICATE)
