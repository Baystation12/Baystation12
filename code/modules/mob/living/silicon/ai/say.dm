/mob/living/silicon/ai/say(var/message)
	if(parent && istype(parent) && parent.stat != 2)
		parent.say(message)
		return
		//If there is a defined "parent" AI, it is actually an AI, and it is alive, anything the AI tries to say is said by the parent instead.
	..(message)

/mob/living/silicon/say_understands(var/other)
	if (istype(other, /mob/living/carbon/human))
		return 1
	if (istype(other, /mob/living/silicon))
		return 1
	if (istype(other, /mob/living/carbon/brain))
		return 1
	return ..()

var/announcing_vox = 0 // Stores the time of the last announcement
var/const/VOX_CHANNEL = 200
var/const/VOX_DELAY = 100 // 10 seconds
var/const/VOX_PATH = "sound/vox/"

/mob/living/silicon/ai/verb/announcement_help()

	set name = "Announcement Help"
	set desc = "Display a list of vocal words to announce to the crew."
	set category = "AI Commands"


	var/dat = "Here is a list of words you can type into the 'Announcement' button to create sentences to vocally announce to everyone on the same level at you.<BR> \
	<UL><LI>You can also click on the word to preview it.</LI>\
	<LI>You can only say 30 words for every announcement.</LI>\
	<LI>Do not use punctuation as you would normally, if you want a pause you can use the full stop and comma characters by separating them with spaces, like so: 'Alpha . Test , Bravo'.</LI></UL>\
	<font class='bad'>WARNING:</font><BR>Misuse of the announcement system will get you job banned.<HR>"

	var/index = 0
	var/list/vox_words = flist(VOX_PATH) // flist will return a list of strings with all the files in the path
	for(var/word in vox_words)
		index++
		var/stripped_word = copytext(word, 1, length(word) - 3) // Remove the .wav
		dat += "<A href='?src=\ref[src];say_word=[stripped_word]'>[capitalize(stripped_word)]</A>"
		if(index != vox_words.len)
			dat += " / "

	src << browse(dat, "window=announce_help;size=500x400")


/mob/living/silicon/ai/verb/announcement()

	set name = "Announcement"
	set desc = "Create a vocal announcement by typing in the available words to create a sentence."
	set category = "AI Commands"

	if(announcing_vox > world.time)
		src << "<span class='notice'>Please wait [round((announcing_vox - world.time) / 10)] seconds.</span>"
		return

	var/message = input(src, "WARNING: Misuse of this verb can result in you being job banned. More help is available in 'Announcement Help'", "Announcement", src.last_announcement) as text

	last_announcement = message

	if(!message || announcing_vox > world.time)
		return

	var/list/words = text2list(trim(message), " ")
	var/list/incorrect_words = list()

	if(words.len > 30)
		words.len = 30

	// Detect incorrect words which aren't .wav files.
	for(var/word in words)
		word = trim(word)
		if(!word)
			words -= word
			continue
		if(!vox_word_exists(word))
			incorrect_words += word

	if(incorrect_words.len)
		src << "<span class='notice'>These words are not available on the announcement system: [english_list(incorrect_words)].</span>"
		return

	announcing_vox = world.time + VOX_DELAY

	log_game("[key_name_admin(src)] made a vocal announcement with the following message: [message].")

	for(var/word in words)
		play_vox_word(word, src.z, null)


/proc/play_vox_word(var/word, var/z_level, var/mob/only_listener)

	word = lowertext(word)

	if(vox_word_exists(word))

		var/sound_file = get_vox_file(word)
		var/sound/voice = sound(sound_file, wait = 1, channel = VOX_CHANNEL)
		voice.status = SOUND_STREAM

 		// If there is no single listener, broadcast to everyone in the same z level
		if(!only_listener)
			// Play voice for all mobs in the z level
			for(var/mob/M in player_list)
				if(M.client)
					var/turf/T = get_turf(M)
					if(T.z == z_level)
						M << voice
		else
			only_listener << voice
		return 1
	return 0


/proc/vox_word_exists(var/word)
	return fexists("[VOX_PATH][word].wav")

/proc/get_vox_file(var/word)
	if(vox_word_exists(word))
		return file("[VOX_PATH][word].wav")

// Dynamically loading it has bad results with sounds overtaking each other, even with the wait variable.
// We send the file to the user when they login.

/client/proc/preload_vox()
	var/list/vox_files = flist(VOX_PATH)
	for(var/file in vox_files)
	//	src << "Downloading [file]"
		var/sound/S = sound("[VOX_PATH][file]")
		src << browse_rsc(S)
