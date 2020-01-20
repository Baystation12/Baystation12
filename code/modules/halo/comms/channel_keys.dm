
var/global/datum/halo_frequencies/halo_frequencies = new()

//These defines are undef'd in telecomms_jammers.
#define SHIPCOM_NAME "SHIPCOM"
#define TEAMCOM_NAME "TEAMCOM"
#define SQUADCOM_NAME "SQUADCOM"
#define FLEETCOM_NAME "FLEETCOM"
#define EBAND_NAME "EBAND"
#define COV_COMMON_NAME "Battlenet"
#define CIV_NAME "System"
#define SEC_NAME "GCPD"
#define ODST_NAME "TACCOM"
#define BERTELS_NAME "UNSC Bertels Intercom"
#define ONI_NAME "ONICOM"
#define URFC_NAME "CMDOCOM"
#define MED_NAME "MEDCOM"
#define INNIE_DEFAULT "INNIECOM"
#define SPARTAN_NAME "SIERRACOM"

/datum/halo_frequencies
	var/innie_channel_name = "INNIECOM"
	var/const/civ_freq = 1459
	var/list/frequencies_by_number = list()
	var/list/all_frequencies = list()
	var/list/frequencies_human = list(INNIE_DEFAULT,SHIPCOM_NAME,BERTELS_NAME,TEAMCOM_NAME,SQUADCOM_NAME,FLEETCOM_NAME,EBAND_NAME,CIV_NAME,SEC_NAME,ODST_NAME,ONI_NAME,URFC_NAME,MED_NAME,SPARTAN_NAME)
	var/list/frequencies_cov = list("RamNet","BoulderNet","BattleNet")

/datum/halo_frequencies/New()
	. = ..()
	//this should be set in the map
	/*if(GLOB.using_map.use_global_covenant_comms)
		new /obj/item/device/mobilecomms/commsbackpack/covenant (locate(1,1,1))*/
	setup_com_channels()

/hook/startup/proc/reset_innie_dept_key()
	//this can't be in datum/New() as there it is apparently called before global vars are instantianted
	for(var/key in department_radio_keys) //Department keys would bork if this isn't done.
		if(department_radio_keys[key] == "INNIECOM")
			department_radio_keys[key] = halo_frequencies.innie_channel_name
	return 1

/datum/halo_frequencies/proc/setup_com_channels()
	//randomised innie comm channel name
	innie_channel_name = pick(\
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
	"EXCOM","RAMCOM","RANCHCOM"\
	)

	var/innie_index = frequencies_human.Find(INNIE_DEFAULT)
	frequencies_human[innie_index] = innie_channel_name

	//randomised the freqs but avoid collisions
	frequencies_by_number["[civ_freq]"] = CIV_NAME

	//human frequencies
	for(var/cur_freq_name in frequencies_human)
		var/cur_freq
		do
			cur_freq = rand(RADIO_LOW_FREQ, PUBLIC_LOW_FREQ)
		while(frequencies_by_number["[cur_freq]"])
		frequencies_human[cur_freq_name] = cur_freq
		all_frequencies[cur_freq_name] = cur_freq
		frequencies_by_number["[cur_freq]"] = cur_freq_name

	//shared human and covenant civilian frequency
	frequencies_human[CIV_NAME] = civ_freq

	//covenant frequencies
	for(var/cur_freq_name in frequencies_cov)
		var/cur_freq
		do
			cur_freq = rand(PUBLIC_HIGH_FREQ, RADIO_HIGH_FREQ)
		while(frequencies_by_number["[cur_freq]"])
		frequencies_cov[cur_freq_name] = cur_freq
		all_frequencies[cur_freq_name] = cur_freq
		frequencies_by_number["[cur_freq]"] = cur_freq_name

	radiochannels = frequencies_human|frequencies_cov

	return 1

//reset the channel name due to a randomised innie comm channel name
/obj/item/device/encryptionkey/inniecom/New()
	channels = list(halo_frequencies.innie_channel_name = 1, EBAND_NAME = 1)
	. = ..()

//also this one
/obj/item/device/encryptionkey/urfccom/New()
	channels = list(URFC_NAME = 1, halo_frequencies.innie_channel_name = 1, EBAND_NAME = 1)
	. = ..()

/obj/item/device/encryptionkey/onicom
	channels = list(ONI_NAME = 1,SHIPCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1,FLEETCOM = 1)

/obj/item/device/encryptionkey/shipcom
	channels = list(SHIPCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/police
	channels = list(SEC_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/fleetcom
	channels = list(SHIPCOM_NAME = 1,TEAMCOM_NAME = 1,SQUADCOM_NAME = 1,FLEETCOM_NAME = 1,EBAND_NAME = 1, TACCOM = 1)

/obj/item/device/encryptionkey/officercom
	channels = list(SHIPCOM_NAME = 1,FLEETCOM_NAME = 1, EBAND_NAME = 1)

/obj/item/device/encryptionkey/squadcom
	channels = list(SHIPCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/taccomo
	channels = list(SHIPCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1, ODST_NAME = 1, FLEETCOM = 1)

/obj/item/device/encryptionkey/taccom
	channels = list(SHIPCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1, ODST_NAME = 1)

/obj/item/device/encryptionkey/teamcom
	channels = list(SHIPCOM_NAME = 1,TEAMCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1)

/obj/item/device/encryptionkey/spartancom
	channels = list(ONI_NAME = 1,SHIPCOM_NAME = 1,SQUADCOM_NAME = 1,EBAND_NAME = 1,FLEETCOM = 1, ODST_NAME = 1, SPARTAN_NAME = 1)

/obj/item/device/encryptionkey/spartan_oprf
	channels = list(SQUADCOM_NAME = 1)

/obj/item/device/encryptionkey/eband
	channels = list(EBAND_NAME = 1)

/obj/item/device/encryptionkey/public
	channels = list(CIV_NAME = 1)

/obj/item/device/encryptionkey/medship
	channels = list(MED_NAME = 1, EBAND_NAME = 1)

/proc/halo_frequency_span_class(var/frequency)

	//var/list/frequencies_by_number = halo_frequencies.frequencies_by_number
	var/freq_name = halo_frequencies.frequencies_by_number["[frequency]"]

	if(freq_name == halo_frequencies.innie_channel_name)
		//Innie channel
		return "syndradio"

	switch(freq_name)
		// GCPD channel
		if(SEC_NAME)
			return "secradio"

		// ODST channel
		if(ODST_NAME)
			return "supradio"

		if(SQUADCOM_NAME)
			return "supradio"

		if(TEAMCOM_NAME)
			return "supradio"

		// ODST channel
		if(ODST_NAME)
			return "supradio"

		//Covenant Battlenet channels
		if("BattleNet")
			return "sciradio"

		//brute clan
		if("BoulderNet")
			return "secradio"

		//brute clan
		if("RamNet")
			return "comradio"

		//ONI private comms
		if(ONI_NAME)
			return "comradio"

		//Spartan comms
		if(SPARTAN_NAME)
			return "Sierracom"

		//unsc officers chat
		if(FLEETCOM_NAME)
			return "medradio"

		//general unsc ship comms
		if(SHIPCOM_NAME)
			return "engradio"

		//innie commando comms
		if(URFC_NAME)
			return "supradio"

	//system radio
	return "radio"
