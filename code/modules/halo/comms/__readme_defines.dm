
/*

11 February 2020

This will be the third time I've attempted to rewrite Bay12 telecomms system for Halostation. Maybe this time will be the last. God save us

- Cael



**** Radio signal

Mob speaks into radio
-> radio creates radio signal
-> signal goes to frequency via send_to_filter()
-> radio frequency broadcasts the signal to mobs which are listening (mostly just players) via broadcast_radio_chat()

To calculate which mobs can hear the signal, the radio frequency will send the signal to any telecommunications networks in short range (7 overmap tiles) to see if they want to broadcast it.

Unlike vanilla ss13 comms, the overmap comms network processes signals instantly and in a (hopefully) simpler, more transparent fashion.

Once the signal is received by the overmap comms network, it goes through a single loop with variations depending on the machines on the network and the nature of the radio signal (eg encryption, frequency etc). .



**** Overmap comms network loop

1. Receiver gets a signal from the radio frequency
2. Do we have a broadcaster? If not, exit now.
3. Is there a hub blocking broadcast on this frequency? If so, exit now.
4. Can we decrypt it? (do decrypt check). If not, exit now.
5. Tell the radio frequency we are going to broadcast it.



**** Decrypt check

1. Does a server have the radio cipher of the signal? If not, exit fail
2. Loop over all processors
3. If this processor has a cipher/frequency pair, exit success
4. Exit fail



**** Procs of interest

/datum/radio_frequency/proc/send_to_filter(datum/signal/signal, var/filter)
See code/controllers/communications.dm

This proc loops out around nearby sectors to locate telecomms machinery of interest before compiling a list of listening radios along with their quality levels.
By default a radio signal will only travel a short distance around the overmap object. It will have perfect clarity in that radius but clarity will decay rapidly outside that.
If a telecomms reciever is located on a sector nearby and is correctly connected to an active broadcaster for the signal's frequency, then the signal will instead have a "global" range.
A global range signal will have perfect clarity across the entire star system, excepting signal jamming or environmental interference.
If a signal jammer is active on the frequency and within short range of the signal source, then the signal will not transmit.
If a signal jammer is active on the frequency around a radio, then long range signals won't be heard.



/datum/radio_frequency/proc/broadcast_radio_chat(var/datum/signal/signal, var/list/radios = list(), var/list/radios_gibberish = list(), var/list/radios_garbled = list())
See code/controllers/communications_broadcast.dm

This proc is a butchered version of Broadcast_Message() from code/game/machinery/telecomms/broadcaster.dm
It is intentionally simplified, cutting out some vanilla SS13 features which we have replaced or aren't using and updates some old code eg for languages.
It also has added functionality for signal decay over range.

**** Assumptions

Once a dongle is created and given info, it can't be modified by players.

*/

GLOBAL_LIST_EMPTY(telecoms_jammers)

/obj/effect/overmap
	var/list/telecomms_receivers = list()
	var/list/telecomms_jammers = list()

/mob/living/simple_animal/npc/colonist/radio_test
	speak_chance = 100
	emote_hear = list()
	emote_see = list()
	var/obj/item/device/radio/headset/unsc/spartan/my_headset
	var/list/recent_messages = list()
	var/radio_hotkey = ";"

/mob/living/simple_animal/npc/colonist/radio_test/New()
	my_headset = new(src)
	. = ..()

/mob/living/simple_animal/npc/colonist/radio_test/say(var/message)
	//obj/item/device/radio/talk_into(mob/living/M as mob, message, channel, var/speaking_verb = "says", var/datum/language/speaking = null)
	. = ..()
	my_headset.talk_into(src, message, radio_hotkey, "says", speaking = species_language)

#define NETWORK_ERROR_HUB 1
#define NETWORK_ERROR_RECONNECT 2
