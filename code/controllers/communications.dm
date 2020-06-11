/*
  HOW IT WORKS

  The radio_controller is a global object maintaining all radio transmissions, think about it as about "ether".
  Note that walkie-talkie, intercoms and headsets handle transmission using nonstandard way.
  procs:

    add_object(obj/device as obj, var/new_frequency as num, var/filter as text|null = null)
      Adds listening object.
      parameters:
        device - device receiving signals, must have proc receive_signal (see description below).
          one device may listen several frequencies, but not same frequency twice.
        new_frequency - see possibly frequencies below;
        filter - thing for optimization. Optional, but recommended.
                 All filters should be consolidated in this file, see defines later.
                 Device without listening filter will receive all signals (on specified frequency).
                 Device with filter will receive any signals sent without filter.
                 Device with filter will not receive any signals sent with different filter.
      returns:
       Reference to frequency object.

    remove_object (obj/device, old_frequency)
      Obliviously, after calling this proc, device will not receive any signals on old_frequency.
      Other frequencies will left unaffected.

   return_frequency(var/frequency as num)
      returns:
       Reference to frequency object. Use it if you need to send and do not need to listen.

  radio_frequency is a global object maintaining list of devices that listening specific frequency.
  procs:

    post_signal(obj/source as obj|null, datum/signal/signal, var/filter as text|null = null, var/range as num|null = null)
      Sends signal to all devices that wants such signal.
      parameters:
        source - object, emitted signal. Usually, devices will not receive their own signals.
        signal - see description below.
        filter - described above.
        range - radius of regular byond's square circle on that z-level. null means everywhere, on all z-levels.

  obj/proc/receive_signal(datum/signal/signal, var/receive_method as num, var/receive_param, receive_interference)
    Handler from received signals. By default does nothing. Define your own for your object.
    Avoid of sending signals directly from this proc, use spawn(-1). DO NOT use sleep() here or call procs that sleep please. If you must, use spawn()
      parameters:
        signal - see description below. Extract all needed data from the signal before doing sleep(), spawn() or return!
        receive_method - may be TRANSMISSION_WIRE or TRANSMISSION_RADIO.
          TRANSMISSION_WIRE is currently unused.
        receive_param - for TRANSMISSION_RADIO here comes frequency.
        receive_interference - a % value on how much interference the signal has when recieved

  datum/signal
    vars:
    source
      an object that emitted signal. Used for debug and bearing.
    data
      list with transmitting data. Usual use pattern:
        data["msg"] = "hello world"
    encryption
      Some number symbolizing "encryption key".
      Note that game actually do not use any cryptography here.
      If receiving object don't know right key, it must ignore encrypted signal in its receive_signal.

See code/modules/overmap/comms.dm for documentation on the HS13 overmap integration. Most of the changes are in send_to_filter()

*/

/*
Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)

Radio:
1459 - standard radio chat
1351 - Science
1353 - Command
1355 - Medical
1357 - Engineering
1359 - Security
1341 - deathsquad
1443 - Confession Intercom
1347 - Cargo techs
1349 - Service people

Devices:
1451 - tracking implant
1457 - RSD default

On the map:
1311 for prison shuttle console (in fact, it is not used)
1435 for status displays
1437 for atmospherics/fire alerts
1438 for engine components
1439 for air pumps, air scrubbers, atmo control
1441 for atmospherics - supply tanks
1443 for atmospherics - distribution loop/mixed air tank
1445 for bot nav beacons
1447 for mulebot, secbot and ed209 control
1449 for airlock controls, electropack, magnets
1451 for toxin lab access
1453 for engineering access
1455 for AI access
*/

var/const/RADIO_LOW_FREQ	= 1200
var/const/PUBLIC_LOW_FREQ	= 1441
var/const/PUBLIC_HIGH_FREQ	= 1489
var/const/RADIO_HIGH_FREQ	= 1600

var/const/AIRLOCK_FREQ = 1379

var/const/BOT_FREQ	= 1447
var/const/COMM_FREQ = 1353
var/const/ERT_FREQ	= 1345
var/const/AI_FREQ	= 1343
var/const/DTH_FREQ	= 1341
var/const/SYND_FREQ = 1213
var/const/RAID_FREQ	= 1277
var/const/ENT_FREQ	= 1461 //entertainment frequency. This is not a diona exclusive frequency.

// department channels
var/const/PUB_FREQ = 1459
var/const/SEC_FREQ = 1359
var/const/ENG_FREQ = 1357
var/const/MED_FREQ = 1355
var/const/SCI_FREQ = 1351
var/const/SRV_FREQ = 1349
var/const/SUP_FREQ = 1347

// internal department channels
var/const/MED_I_FREQ = 1485
var/const/SEC_I_FREQ = 1475

var/list/radiochannels = list(
	"Common"		= PUB_FREQ,
	"Science"		= SCI_FREQ,
	"Command"		= COMM_FREQ,
	"Medical"		= MED_FREQ,
	"Engineering"	= ENG_FREQ,
	"Security" 		= SEC_FREQ,
	"Response Team" = ERT_FREQ,
	"Special Ops" 	= DTH_FREQ,
	"Mercenary" 	= SYND_FREQ,
	"Raider"		= RAID_FREQ,
	"Supply" 		= SUP_FREQ,
	"Service" 		= SRV_FREQ,
	"AI Private"	= AI_FREQ,
	"Entertainment" = ENT_FREQ,
	"Medical(I)"	= MED_I_FREQ,
	"Security(I)"	= SEC_I_FREQ
)

// central command channels, i.e deathsquid & response teams
var/list/CENT_FREQS = list(ERT_FREQ, DTH_FREQ)

// Antag channels, i.e. Syndicate
var/list/ANTAG_FREQS = list(SYND_FREQ, RAID_FREQ)

//Department channels, arranged lexically
var/list/DEPT_FREQS = list(AI_FREQ, COMM_FREQ, ENG_FREQ, MED_FREQ, SEC_FREQ, SCI_FREQ, SRV_FREQ, SUP_FREQ, ENT_FREQ)

#define TRANSMISSION_WIRE	0
#define TRANSMISSION_RADIO	1

/proc/frequency_span_class(var/frequency)
	// Antags!
	if (frequency in ANTAG_FREQS)
		return "syndradio"
	// centcomm channels (deathsquid and ert)
	if(frequency in CENT_FREQS)
		return "centradio"
	// command channel
	if(frequency == COMM_FREQ)
		return "comradio"
	// AI private channel
	if(frequency == AI_FREQ)
		return "airadio"
	// department radio formatting (poorly optimized, ugh)
	if(frequency == SEC_FREQ)
		return "secradio"
	if (frequency == ENG_FREQ)
		return "engradio"
	if(frequency == SCI_FREQ)
		return "sciradio"
	if(frequency == MED_FREQ)
		return "medradio"
	if(frequency == SUP_FREQ) // cargo
		return "supradio"
	if(frequency == SRV_FREQ) // service
		return "srvradio"
	if(frequency == ENT_FREQ) //entertainment
		return "entradio"
	if(frequency in DEPT_FREQS)
		return "deptradio"

	return "radio"

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also recieve signals sent to any other filter.
var/const/RADIO_DEFAULT = "radio_default"

var/const/RADIO_TO_AIRALARM = "radio_airalarm" //air alarms
var/const/RADIO_FROM_AIRALARM = "radio_airalarm_rcvr" //devices interested in recieving signals from air alarms
var/const/RADIO_CHAT = "radio_telecoms"
var/const/RADIO_ATMOSIA = "radio_atmos"
var/const/RADIO_NAVBEACONS = "radio_navbeacon"
var/const/RADIO_AIRLOCK = "radio_airlock"
var/const/RADIO_SECBOT = "radio_secbot"
var/const/RADIO_MULEBOT = "radio_mulebot"
var/const/RADIO_MAGNETS = "radio_magnet"

//in overmap tiles
#define OVERMAP_RADIO_CLOSE 7
#define OVERMAP_RADIO_FAR 20

var/global/datum/controller/radio/radio_controller

/hook/startup/proc/createRadioController()
	radio_controller = new /datum/controller/radio()
	return 1

//callback used by objects to react to incoming radio signals
/obj/proc/receive_signal(datum/signal/signal, receive_method, receive_param, receive_interference = 0)
	return null

//The global radio controller
/datum/controller/radio
	var/list/datum/radio_frequency/frequencies = list()

/datum/controller/radio/proc/add_object(obj/device as obj, var/new_frequency as num, var/filter = null as text|null)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	frequency.add_listener(device, filter)
	return frequency

/datum/controller/radio/proc/remove_object(obj/device, old_frequency)
	var/f_text = num2text(old_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(frequency)
		frequency.remove_listener(device)

		if(frequency.devices.len == 0)
			qdel(frequency)
			frequencies -= f_text

	return 1

/datum/controller/radio/proc/return_frequency(var/new_frequency as num)
	var/f_text = num2text(new_frequency)
	var/datum/radio_frequency/frequency = frequencies[f_text]

	if(!frequency)
		frequency = new
		frequency.frequency = new_frequency
		frequencies[f_text] = frequency

	return frequency

/datum/radio_frequency
	var/frequency as num
	var/list/list/obj/devices = list()

/datum/radio_frequency/proc/post_signal(obj/source as obj|null, datum/signal/signal, var/filter = null as text|null, var/range = 0)
	//send the signal to everything by default
	if(!filter)
		filter = RADIO_DEFAULT
	send_to_filter(signal, filter, source, range)

//Sends a signal to all machines belonging to a given filter. Should be called by post_signal()
/datum/radio_frequency/proc/send_to_filter(datum/signal/signal, var/filter, obj/source as obj|null, var/transmit_global = 0)


	//grab some useful info
	var/turf/source_turf = get_turf(source)
	var/obj/effect/overmap/source_sector = map_sectors["[source_turf.z]"]
	var/list/broadcasting_sectors = list()

	//let's check for nearby telecomms machinery which will interact with the signal
	for(var/obj/effect/overmap/nearby_sector in range(7, source_sector))

		//check for jammers
		for(var/obj/machinery/overmap_comms/jammer/tj in nearby_sector.telecomms_jammers)
			if(!tj.active)
				continue
			if(frequency in tj.ignore_freqs)
				continue

			//if the signal is being jammed at the source, we wont bother sending any outgoing signals at all
			signal.data["jammed"] = 1

			var/image/speech_bubble = image('icons/mob/talk.dmi',source,"radio2")
			spawn(30) qdel(speech_bubble)

			//var/list/jammed_mobs = get_mobs_in_radio_ranges(list(source))
			for(var/mob/M in hear(7,get_turf(source)))
				show_image(M, speech_bubble)
				to_chat(M, "\icon[source] <span class='danger'>[source] emits a loud screeching wail!</span>")
			return

		//check for receivers
		var/sector_finished = 0
		for(var/obj/machinery/overmap_comms/receiver/receiver in nearby_sector.telecomms_receivers)

			//will this receiever broadcast the signal globally?
			if(receiver.get_range_extension(signal) >= 1)

				//we are
				transmit_global = 1
				broadcasting_sectors |= nearby_sector

				//dont need to scan this sector any further
				sector_finished = 1
				break

		if(sector_finished)
			break

		//backwards compatibility: the old code used relays, so check if those exist and are active
		for(var/obj/machinery/telecomms/relay/relay in nearby_sector.telecomms_receivers)
			if(relay.on)
				transmit_global = 1
				broadcasting_sectors |= nearby_sector

				//dont need to scan this sector any further
				sector_finished = 1
				break

	//see which devices are in range
	var/list/listening_sectors = list()
	var/list/radios = list()
	var/list/radios_garbled = list()
	var/list/radios_out_of_range = list()
	var/list/radios_encrypted = list()

	for(var/obj/check_obj in devices[filter])
		var/finished = 0

		//if the signal is being broadcast, then everyone will hear it globally with perfect clarity
		var/turf/obj_turf = get_turf(check_obj)

		if(!check_obj)
			continue

		if(!obj_turf)
			if(istype(check_obj.loc, /mob/living/carbon/human/dummy/mannequin))
				//stop this one from listening
				radio_controller.remove_object(check_obj, frequency)
				continue
			to_debug_listeners("Warning, radio listener [check_obj]|[check_obj.type] on freq \'[src.frequency]\' and filter \'[filter]\' ([check_obj.x],[check_obj.y],[check_obj.z]) in devices\[[filter]\] has null location")
			continue

		//first do a special encryption check for radios... other devices can do their own encryption checks
		if(istype(check_obj, /obj/item/device/radio))
			var/obj/item/device/radio/R = check_obj
			var/datum/channel_cipher/cipher = signal.data["cipher"]

			//does this signal have an encryption cipher we dont know?
			if(cipher && cipher.encrypted && !R.has_cipher(cipher))
				if(transmit_global)
					radios_encrypted.Add(check_obj)
				else
					var/obj/effect/overmap/radio_sector = map_sectors["[obj_turf.z]"]
					var/hear_dist = get_dist(radio_sector, source_sector)
					if(hear_dist <= OVERMAP_RADIO_FAR)
						radios_encrypted.Add(check_obj)
				finished = 1

		//we can do a shortcut here to skip further processing if it's an encrypted radio signal
		if(!finished)
			if(transmit_global)
				//no interference
				finished = 1
				radios.Add(check_obj)
			else
				//if it's in short range
				var/obj/effect/overmap/radio_sector = map_sectors["[obj_turf.z]"]
				var/hear_dist = get_dist(radio_sector, source_sector)
				if(radio_sector == source_sector || hear_dist <= OVERMAP_RADIO_CLOSE)
					//no interference
					finished = 1
					radios.Add(check_obj)

				else if(hear_dist <= OVERMAP_RADIO_FAR)
					finished = 1
					radios.Add(check_obj)

					//interference depending on distance
					var/dist_ratio = (hear_dist - OVERMAP_RADIO_CLOSE) / (OVERMAP_RADIO_FAR - OVERMAP_RADIO_CLOSE)
					radios_out_of_range[check_obj] = 1 + dist_ratio * 75

		if(finished)
			//remember all the listening radios in a sector just in case (to help with jamming later)
			var/obj/effect/overmap/radio_sector = map_sectors["[obj_turf.z]"]
			if(!listening_sectors[radio_sector])
				listening_sectors[radio_sector] = list()
			listening_sectors[radio_sector].Add(check_obj)

	//now check to find jammers that are blocking incoming radio signals
	//the assumption here for optimisation purposes is that there are less jammers than radios
	if(transmit_global)
		for(var/obj/machinery/overmap_comms/jammer/tj in GLOB.telecoms_jammers)
			if(!tj.active)
				continue
			if(frequency in tj.ignore_freqs)
				continue

			//get nearby sectors to jam incoming signals (including the sector the jammer is located in)
			var/obj/effect/overmap/jammed_sector = map_sectors["[tj.z]"]
			for(var/obj/effect/overmap/nearby_sector in range(tj.jam_range, jammed_sector))

				//are there any radios in this sector that would hear the signal?
				if(listening_sectors.Find(nearby_sector))
					//whoops this sector is getting jammed,  no radios will be getting incoming signals
					radios -= listening_sectors[nearby_sector]
					radios_out_of_range -= listening_sectors[nearby_sector]
					radios_garbled -= listening_sectors[nearby_sector]
					radios_encrypted -= listening_sectors[nearby_sector]

	//send the signal for the devices to do their own processing
	//note that receive_signal() for radios above specifically does not output any chat messages to players
	for(var/obj/check_obj in radios)
		check_obj.receive_signal(signal, TRANSMISSION_RADIO, frequency, 0)
	//
	for(var/obj/check_obj in radios_out_of_range)
		check_obj.receive_signal(signal, TRANSMISSION_RADIO, frequency, radios_out_of_range[check_obj])
	//
	for(var/obj/check_obj in radios_garbled)
		check_obj.receive_signal(signal, TRANSMISSION_RADIO, frequency, radios_garbled[check_obj])

	//we process radio chat here so that players wont get multiple chat messages if they are in range of multiple radios
	if(signal.data["message"])
		broadcast_radio_chat(signal, radios, radios_out_of_range, radios_garbled)

/datum/radio_frequency/proc/add_listener(obj/device as obj, var/filter as text|null)
	if (!filter)
		filter = RADIO_DEFAULT
	//log_admin("add_listener(device=[device],filter=[filter]) frequency=[frequency]")
	var/list/obj/devices_line = devices[filter]
	if (!devices_line)
		devices_line = new
		devices[filter] = devices_line
	devices_line+=device
//			var/list/obj/devices_line___ = devices[filter_str]
//			var/l = devices_line___.len
	//log_admin("DEBUG: devices_line.len=[devices_line.len]")
	//log_admin("DEBUG: devices(filter_str).len=[l]")

/datum/radio_frequency/proc/remove_listener(obj/device)
	for (var/devices_filter in devices)
		var/list/devices_line = devices[devices_filter]
		devices_line-=device
		while (null in devices_line)
			devices_line -= null
		if (devices_line.len==0)
			devices -= devices_filter

/datum/signal
	var/obj/source

	var/transmission_method = 0 //unused at the moment
	//0 = wire
	//1 = radio transmission
	//2 = subspace transmission

	var/list/data = list()
	var/encryption

	var/frequency = 0

/datum/signal/proc/copy_from(datum/signal/model)
	source = model.source
	transmission_method = model.transmission_method
	data = model.data
	encryption = model.encryption
	frequency = model.frequency

/datum/signal/proc/debug_print()
	if (source)
		. = "signal = {source = '[source]' ([source:x],[source:y],[source:z])\n"
	else
		. = "signal = {source = '[source]' ()\n"
	for (var/i in data)
		. += "data\[\"[i]\"\] = \"[data[i]]\"\n"
		if(islist(data[i]))
			var/list/L = data[i]
			for(var/t in L)
				. += "data\[\"[i]\"\] list has: [t]"
