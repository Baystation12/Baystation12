
#define ENLISTED_MIN 1
#define RANK_RECRUIT 1
#define RANK_APPRENTICE 2
#define RANK_CREWMAN 3
#define RANK_PETTY3 4
#define RANK_PETTY2 5
#define RANK_PETTY1 6
#define RANK_PETTYC 7
#define RANK_PETTYS 8
#define RANK_PETTYM 9
#define ENLISTED_MAX 9

#define RANK_CWO 10

#define OFFICER_MIN 11
#define RANK_ENSIGN 12
#define RANK_LTJG 13
#define RANK_LT 14
#define RANK_LCDR 15
#define RANK_CDR 16
#define RANK_CPT 17
#define OFFICER_MAX 17

#define FLEET_MIN 18
#define RANK_RDML 19
#define RANK_RADM 20
#define RANK_VADM 21
#define RANK_ADM 22
#define RANK_FADM 23
#define FLEET_MAX 23

#define MARINE_MIN 24
#define RANK_PVT 24
#define RANK_PFC 25
#define RANK_LCPL 26
#define RANK_CPL 27
#define MARINE_MAX 27

#define MARINE_SL_MIN 28
#define RANK_SGT 28
#define RANK_SSGT 29
#define RANK_GYSGT 30
#define RANK_MSGT 31
#define RANK_1SGT 32
#define RANK_MGYSGT 33
#define RANK_SGTMAJ 34
#define MARINE_SL_MAX 34

#define MARINE_CO_MIN 35
#define RANK_2LT 35
#define RANK_1LT 36
#define RANK_CAPT 37
#define RANK_MAJ 38
#define RANK_LTCOL 39
#define RANK_COL 40
#define MARINE_CO_MAX 40

/proc/get_jobtypestring_from_rank(var/rank)
	if(rank <= MARINE_CO_MAX)
		if(rank >= MARINE_CO_MIN)
			return "marine billet"
		else if(rank >= MARINE_MIN)
			return "marine MOS"
		else if(rank >= FLEET_MIN)
			return "command billet"
		else if(rank >= OFFICER_MIN)
			return "officer billet"
		else if(rank >= ENLISTED_MIN)
			return "rating"

var/list/UNSC_ranks = list(\
	"Crewman Recruit",
	"Crewman Apprentice",
	"Crewman",
	"Petty Officer 3rd Class",
	"Petty Officer 2nd Class",
	"Petty Officer 1st Class",
	"Chief Petty Officer",
	"Senior Chief Petty Officer",
	"Master Chief Petty Officer",
	//
	"Chief Warrant Officer",
	//
	"Ensign",
	"Junior Lieutenant",
	"Lieutenant",
	"Lieutenant Commander",
	"Commander",
	"Captain",
	//
	"Rear Admiral (Lower Half)",
	"Rear Admiral (Upper Half)",
	"Vice Admiral",
	"Admiral",
	"Fleet Admiral",
	//
	"Private",
	"Private First Class",
	"Lance Corporal",
	"Corporal",
	//
	"Sergeant",
	"Staff Sergeant",
	"Gunnery Sergeant",
	"Master Sergeant",
	"1st Sergeant",
	"Master Gunnery Sergeant",
	"Sergeant Major",
	//
	"2nd Lieutenant",
	"1st Lieutenant",
	"Captain",
	"Major",
	"Lieutenant Colonel",
	"Colonel")

/datum/job/UNSC_ship
	title = "unknown" //For travis
	faction = "UNSC_ship"

