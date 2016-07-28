/datum/radio_channel
	var/name = "Unknown" // Name of the channel
	var/color = "body"   // CSS style to use for strings in this channel.
	var/key              // Character used to speak in channel,  eg. :s for security.
	var/frequency		 // The frequency of this channel
	var/flags = 0        // Various channel flags.

/datum/radio_channel/main
	name = "Main Channel"

/datum/radio_channel/left_ear
	name = "Left Ear"

/datum/radio_channel/right_ear
	name = "Right Ear"

/datum/radio_channel/intercom
	name = "Right Ear"

/datum/radio_channel/command
	name = "Command"
	color  = "comradio"
	frequency = COMM_FREQ
	key = "c"

/datum/radio_channel/common
	name = "Common"
	color  = "radio"
	frequency = PUB_FREQ
	key = "o"

/datum/radio_channel/engineering
	name = "Engineering"
	color  = "engradio"
	frequency = ENG_FREQ
	key = "e"

/datum/radio_channel/medical
	name = "Medical"
	color  = "medradio"
	frequency = MED_FREQ
	key = "m"

/datum/radio_channel/science
	name = "Science"
	color  = "sciradio"
	frequency = SCI_FREQ
	key = "n"

/datum/radio_channel/security
	name = "Security"
	color  = "secradio"
	frequency = PUB_FREQ
	key = "s"

/datum/radio_channel/service
	name = "Service"
	color  = "srvradio"
	frequency = SRV_FREQ
	key = "v"

/datum/radio_channel/supply
	name = "Supply"
	color  = "supradio"
	frequency = SUP_FREQ
	key = "u"

/datum/radio_channel/ai_private
	name = "AI Private"
	color  = "airadio"
	frequency = AI_FREQ
	key = "p"

/datum/radio_channel/entertainment
	name = "Entertainment"
	color  = "entradio"
	frequency = ENT_FREQ
	key = "z"

/datum/radio_channel/response_team
	name = "Response Team"
	color  = "centradio"
	frequency = ERT_FREQ
	key = "r"

/datum/radio_channel/mercenary
	name = "Mercenary"
	color  = "syndradio"
	frequency = SYND_FREQ
	key = "t"

/atom/proc/is_main_radio_channel_prefix(var/prefix)
	return prefix == ";"

/atom/proc/is_radio_channel_prefix(var/prefix)
	return prefix == ":"
