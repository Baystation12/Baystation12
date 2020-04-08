
GLOBAL_LIST_EMPTY(ids_ciphers)
GLOBAL_LIST_EMPTY(channels_ciphers)
GLOBAL_LIST_EMPTY(freqs_ciphers)

/datum/channel_cipher
	var/id
	var/chat_span_class
	var/hotkey
	var/channel_name
	var/frequency
	//var/freq_text
	var/encrypted = 1

/datum/channel_cipher/New(var/new_freq = 0)
	. = ..()

	//a unique 7 character key
	do
		id = generateRandomString(7)
	while(GLOB.ids_ciphers.Find(id))
	GLOB.ids_ciphers[id] = src

	//assign our frequency
	if(!frequency)
		if(!new_freq)
			do
				if(prob(50))
					new_freq = rand(RADIO_LOW_FREQ, PUBLIC_LOW_FREQ)
				else
					new_freq = rand(PUBLIC_HIGH_FREQ, RADIO_HIGH_FREQ)
			while(GLOB.freqs_ciphers.Find("[new_freq]"))
		frequency = new_freq
	GLOB.freqs_ciphers["[frequency]"] = src

	GLOB.channels_ciphers[channel_name] = src

//generate the preset channel ciphers at server startup
/hook/startup/proc/setup_preset_channels()
	for(var/cipher_type in typesof(/datum/channel_cipher) - /datum/channel_cipher)
		new cipher_type()
	return 1
