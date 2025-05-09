
#define HUMAN_CIV_FREQ 1459

#define RADIO_HUMAN "Public"
#define RADIO_EBAND "EBAND"
#define RADIO_INNIE "INNIE"
#define RADIO_URFC "URFC"
#define RADIO_SEC "GCPD"
#define RADIO_MARSHAL "Marshals"
#define RADIO_SQUAD "UNSC"
#define RADIO_MARINE "REQUISITION"
#define RADIO_ODST "ODST"
#define RADIO_ONI "ONI"
#define RADIO_SPARTAN "SPARTAN"
#define RADIO_FLEET "FLEETCOM"
#define RADIO_SHIP "SHIP"
#define RADIO_COV "Battlenet"
#define RADIO_COVLEAD "Superior"
#define RADIO_COVSPEC "Spec Ops"
#define RADIO_COVREQ "Sequestrations"
#define RADIO_BOULDER "BoulderNet"
#define RADIO_RAM "RamNet"

GLOBAL_VAR_INIT(innie_channel, "INNIE")
GLOBAL_LIST_INIT(random_channels, list(\
	"ZULUCOM","OMEGACOM","RANGERCOM","BADGERCOM",\
	"DELCOM","KILLCOM","PANTHERCOM","HOGCOM",\
	"LIBRACOM","LIBERTYCOM","FREECOM","MILCOM",\
	"COBRACOM","MONSTERCOM","HARDCOM","GOCOM",\
	"AGGCOM","MIDCOM","PITCOM","TOPCOM","VAULTCOM",\
	"WOLFCOM","OTTERCOM","BRONZECOM","GOLDCOM",\
	"RATCOM","TUNNELCOM","READYCOM","GROKCOM",\
	"DRACOCOM","RAPTORCOM","PREDCOM","REDCOM",\
	"OPCOM","OWLCOM","RAWCOM","BLUECOM","DOPECOM",\
	"BULLCOM","SILVERCOM","DOGCOM","SNAKECOM",\
	"EXCOM","RAMCOM","RANCHCOM","BASEDCOM","CRINGECOM",\
	"DRIPCOM"\
	))



//*** Encrypted Radio Channels ***//

/obj/item/device/channel_dongle/urfc
	channel_preset = RADIO_URFC
//
/datum/channel_cipher/urfc
	channel_name = RADIO_URFC
	chat_span_class = "syndradio"
	hotkey = "v"

/obj/item/device/channel_dongle/gcpd
	channel_preset = RADIO_SEC
//
/datum/channel_cipher/gcpd
	channel_name = RADIO_SEC
	chat_span_class = "secradio"
	hotkey = "g"

//

/obj/item/device/channel_dongle/marshals
	channel_preset = RADIO_MARSHAL

/datum/channel_cipher/marshals
	channel_name = RADIO_MARSHAL
	chat_span_class = "secradio"
	hotkey = "m"
//

/obj/item/device/channel_dongle/squadcom
	channel_preset = RADIO_SQUAD
//
/datum/channel_cipher/squadcom
	channel_name = RADIO_SQUAD
	chat_span_class = "comradio"
	hotkey = "q"

/obj/item/device/channel_dongle/marines
	channel_preset = RADIO_MARINE
//
/datum/channel_cipher/marines
	channel_name = RADIO_MARINE
	chat_span_class = "supradio"
	hotkey = "m"

/obj/item/device/channel_dongle/odst
	channel_preset = RADIO_ODST
//
/datum/channel_cipher/odst
	channel_name = RADIO_ODST
	chat_span_class = "secradio"
	hotkey = "t"

/obj/item/device/channel_dongle/oni
	channel_preset = RADIO_ONI
//
/datum/channel_cipher/oni
	channel_name = RADIO_ONI
	chat_span_class = "srvradio"
	hotkey = "o"

/obj/item/device/channel_dongle/spartan
	channel_preset = RADIO_SPARTAN
//
/datum/channel_cipher/spartan
	channel_name = RADIO_SPARTAN
	chat_span_class = "engradio"
	hotkey = "z"

/obj/item/device/channel_dongle/fleetcom
	channel_preset = RADIO_FLEET
//
/datum/channel_cipher/fleetcom
	channel_name = RADIO_FLEET
	chat_span_class = "medradio"
	hotkey = "f"

/obj/item/device/channel_dongle/shipcom
	channel_preset = RADIO_SHIP
//
/datum/channel_cipher/shipcom
	channel_name = RADIO_SHIP
	chat_span_class = "engradio"
	hotkey = "s"

/obj/item/device/channel_dongle/battlenet
	channel_preset = RADIO_COV
//
/datum/channel_cipher/battlenet
	channel_name = RADIO_COV
	chat_span_class = "sciradio"
	hotkey = "c"

/obj/item/device/channel_dongle/superior
	channel_preset = RADIO_COVLEAD
//
/daumtum/channel_cipher/superior
	channel_name = RADIO_COVLEAD
	chat_span_class = "secradio"
	hotkey = "n"

/obj/item/device/channel_dongle/specops
	channel_preset = RADIO_COVSPEC
//
/datum/channel_cipher/specops
	channel_name = RADIO_COVSPEC
	chat_span_class = "srvradio"
	hotkey = "k"

/obj/item/device/channel_dongle/sequestrations
	channel_preset = RADIO_COVREQ
//
/datum/channel_cipher/sequestrations
	channel_name = RADIO_COVREQ
	chat_span_class = "airadio"
	hotkey = "x"

/obj/item/device/channel_dongle/bouldernet
	channel_preset = RADIO_BOULDER
//
/datum/channel_cipher/bouldernet
	channel_name = RADIO_BOULDER
	chat_span_class = "secradio"
	hotkey = "d"

/obj/item/device/channel_dongle/ramnet
	channel_preset = RADIO_RAM
//
/datum/channel_cipher/ramnet
	channel_name = RADIO_RAM
	chat_span_class = "comradio"
	hotkey = "u"



//*** Special Encrypted Radio Channels ***//

/obj/item/device/channel_dongle/human_civ
	channel_preset = RADIO_HUMAN

/datum/channel_cipher/human_civ
	channel_name = RADIO_HUMAN
	frequency = HUMAN_CIV_FREQ
	hotkey = HOTKEY_RADIO
	chat_span_class = "radio"
	encrypted = 0

/obj/item/device/channel_dongle/eband
	channel_preset = RADIO_EBAND

/datum/channel_cipher/eband
	channel_name = RADIO_EBAND
	hotkey = "e"
	encrypted = 0

/obj/item/device/channel_dongle/innie
	channel_preset = RADIO_INNIE

/obj/item/device/channel_dongle/innie/New()

	//this channel has a random channel name
	channel_preset = GLOB.INSURRECTION.get_innie_channel_name()

	. = ..()

/datum/channel_cipher/innie
	channel_name = RADIO_INNIE
	chat_span_class = "syndradio"
	hotkey = "b"

/datum/channel_cipher/innie/New()

	//this channel has a random channel name
	channel_name = GLOB.INSURRECTION.get_innie_channel_name()

	. = ..()
