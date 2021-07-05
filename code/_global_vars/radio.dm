// These globals are the worst

GLOBAL_LIST_INIT(default_medbay_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ) = list(access_medical_equip)
))

// Away Site Channels
GLOBAL_LIST_INIT(AWAY_FREQS_UNASSIGNED, list(1491, 1493, 1495, 1497, 1499, 1501, 1503, 1505, 1507, 1509))
GLOBAL_LIST_INIT(AWAY_FREQS_ASSIGNED, list("Hailing" = HAIL_FREQ))

GLOBAL_LIST_INIT(radiochannels, list(
	"Common"		= PUB_FREQ,
	"Hailing"		= HAIL_FREQ,
	"Science"		= SCI_FREQ,
	"Command"		= COMM_FREQ,
	"Medical"		= MED_FREQ,
	"Engineering"	= ENG_FREQ,
	"Security" 		= SEC_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Raider"		= RAID_FREQ,
	"Exploration"	= EXP_FREQ,
	"Supply" 		= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Medical (I)"	= MED_I_FREQ,
	"Security (I)"	= SEC_I_FREQ
))

GLOBAL_LIST_INIT(channel_color_presets, list(
	"Bemoaning Brown" = COMMS_COLOR_SUPPLY,
	"Bitchin' Blue" = COMMS_COLOR_COMMAND,
	"Bold Brass" = COMMS_COLOR_EXPLORER,
	"Gastric Green" = COMMS_COLOR_SERVICE,
	"Global Green" = COMMS_COLOR_COMMON,
	"Grand Gold" = COMMS_COLOR_COLONY,
	"Hippin' Hot Pink" = COMMS_COLOR_HAILING,
	"Menacing Maroon" = COMMS_COLOR_SYNDICATE,
	"Operational Orange" = COMMS_COLOR_ENGINEER,
	"Painful Pink" = COMMS_COLOR_AI,
	"Phenomenal Purple" = COMMS_COLOR_SCIENCE,
	"Powerful Plum" = COMMS_COLOR_BEARCAT,
	"Pretty Periwinkle" = COMMS_COLOR_CENTCOMM,
	"Radical Ruby" = COMMS_COLOR_VOX,
	"Raging Red" = COMMS_COLOR_SECURITY,
	"Spectacular Silver" = COMMS_COLOR_ENTERTAIN,
	"Tantalizing Turquoise" = COMMS_COLOR_MEDICAL,
	"Viewable Violet" = COMMS_COLOR_SKRELL
))

// central command channels, i.e deathsquid & response teams
GLOBAL_LIST_INIT(CENT_FREQS, list(ERT_FREQ, DTH_FREQ))

// Antag channels, i.e. Syndicate
GLOBAL_LIST_INIT(ANTAG_FREQS, list(SYND_FREQ, RAID_FREQ))

//Department channels, arranged lexically
GLOBAL_LIST_INIT(DEPT_FREQS, list(AI_FREQ, COMM_FREQ, ENG_FREQ, MED_FREQ, SEC_FREQ, SCI_FREQ, SRV_FREQ, SUP_FREQ, EXP_FREQ, ENT_FREQ, MED_I_FREQ, SEC_I_FREQ))

// These are exposed to players, by name.
GLOBAL_LIST_INIT(all_selectable_radio_filters, list(
	RADIO_DEFAULT,
	RADIO_TO_AIRALARM,
	RADIO_FROM_AIRALARM,
	RADIO_CHAT,
	RADIO_ATMOSIA,
	RADIO_NAVBEACONS,
	RADIO_AIRLOCK,
	RADIO_SECBOT,
	RADIO_MULEBOT,
	RADIO_MAGNETS
))

GLOBAL_DATUM(radio_controller, /datum/controller/radio)
