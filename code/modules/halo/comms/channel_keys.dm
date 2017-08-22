
var/global/datum/halo_frequencies/halo_frequencies = new()

/datum/halo_frequencies
	var/innie_channel = "INNIECOM"
	var/innie_freq = -1
	var/shipcom_freq = -1
	var/teamcom_freq = -1
	var/squadcom_freq = -1
	var/fleetcom_freq = -1
	var/const/eband_freq = 1160
	var/const/civ_freq = 1459
	var/list/used_freqs = list()

/datum/halo_frequencies/New()
	setup_com_channels()

/datum/halo_frequencies/proc/setup_com_channels()
	innie_channel = pick(\
	"ZULUCOM","OMEGACOM","RANGERCOM","BAGDERCOM",\
	"DELCOM","KILLCOM","PANTHERCOM","HOGCOM",\
	"LIBRACOM","LIBERTYCOM","FREECOM","MILCOM",\
	"COBRACOM","MONSTERCOM","HARDCOM","GOCOM",\
	"AGGCOM","MIDCOM","PITCOM","TOPCOM","VAULTCOM",\
	"WOLFCOM","OTTERCOM","BRONZECOM","GOLDCOM",\
	"RATCOM","TUNNELCOM","READYCOM","GROKCOM",\
	"DRACOCOM","RAPTORCOM","PREDCOM","REDCOM",\
	"OPCOM","OWLCOM","RAWCOM","BLUECOM","DOPECOM",\
	"BULLCOM","SILVERCOM","DOGCOM","SNAKECOM",\
	"EXCOM"\
	)

	//randomised the freqs but avoid collisions
	used_freqs += "[eband_freq]"
	used_freqs += "[civ_freq]"
	//
	innie_freq = rand(1001, 9998)
	while(used_freqs.Find("[innie_freq]"))
		innie_freq = rand(1001, 9998)
	used_freqs += "[innie_freq]"
	//
	shipcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[shipcom_freq]"))
		shipcom_freq = rand(1001, 9998)
	used_freqs += "[shipcom_freq]"
	//
	teamcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[teamcom_freq]"))
		teamcom_freq = rand(1001, 9998)
	used_freqs += "[teamcom_freq]"
	//
	squadcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[squadcom_freq]"))
		squadcom_freq = rand(1001, 9998)
	used_freqs += "[squadcom_freq]"
	//
	fleetcom_freq = rand(1001, 9998)
	while(used_freqs.Find("[fleetcom_freq]"))
		fleetcom_freq = rand(1001, 9998)
	used_freqs += "[fleetcom_freq]"

	return 1

/obj/item/device/encryptionkey/inniecom
	channel_name = "INNIECOM"
	encryption_key = "INNIECOM"
	message_css = "syndradio"

/obj/item/device/encryptionkey/inniecom/initialize()
	channel_name = halo_frequencies.innie_channel
	frequency_num = halo_frequencies.innie_freq
	..()

/obj/item/device/encryptionkey/shipcom
	channel_name = "SHIPCOM"
	encryption_key = "SHIPCOM"
	message_css = "comradio"

/obj/item/device/encryptionkey/shipcom/initialize()
	frequency_num = halo_frequencies.shipcom_freq
	..()

/obj/item/device/encryptionkey/fleetcom
	channel_name = "FLEETCOM"
	encryption_key = "FLEETCOM"
	message_css = "centradio"

/obj/item/device/encryptionkey/fleetcom/initialize()
	frequency_num = halo_frequencies.fleetcom_freq
	..()

/obj/item/device/encryptionkey/squadcom
	channel_name = "SQDCOM"
	encryption_key = "SQDCOM"
	message_css = "supradio"

/obj/item/device/encryptionkey/squadcom/initialize()
	frequency_num = halo_frequencies.squadcom_freq
	..()

/obj/item/device/encryptionkey/teamcom
	channel_name = "TEAMCOM"
	encryption_key = "TEAMCOM"
	message_css = "medradio"

/obj/item/device/encryptionkey/teamcom/initialize()
	frequency_num = halo_frequencies.teamcom_freq
	..()

/obj/item/device/encryptionkey/eband
	channel_name = "E-BAND"
	message_css = "airadio"
	frequency_num = halo_frequencies.eband_freq

/obj/item/device/encryptionkey/public
	channel_name = "Public COM"
	message_css = "radio"
	frequency_num = halo_frequencies.civ_freq
