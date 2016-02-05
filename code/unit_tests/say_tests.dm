/datum/unit_test/say_test
	name = "SAY - template"

/datum/unit_test/say_test/proc/run_test()
	return

/datum/unit_test/say_test/dead_mobs
	name = "SAY - Dead Mobs template"
	var/mob/living/carbon/human/dead_speaker
	var/mob/say_test/dead_listener

/datum/unit_test/say_test/dead_mobs/start_test()
	var/atom/landmark1 = get_landmark(/obj/effect/landmark/test/say_mark, "1")
	var/atom/landmark2 = get_landmark(/obj/effect/landmark/test/say_mark, "2")
	dead_speaker = new(landmark1.loc)
	dead_speaker.death()
	dead_listener = new(landmark2.loc)

	run_test()
	qdel(dead_speaker)
	qdel(dead_listener)
	return 1

/datum/unit_test/say_test/dead_mobs/shall_speak_in_dsay
	name = "SAY - Dead Mobs Shall Speak in DSAY"

/datum/unit_test/say_test/dead_mobs/shall_speak_in_dsay/run_test()
	var/input = "I am dead!"
	dead_speaker.say(input)
	if(dead_listener.last_heard == input)
		pass("The expected message was received.")
	else
		fail("Unexpected message: [dead_listener.last_heard]")

/mob/say_test
	var/last_heard

/mob/say_test/New()
	..()
	player_list += src

/mob/say_test/Destroy()
	player_list -= src
	. = ..()

/mob/say_test/hear(var/datum/communication/c)
	last_heard = c.sound
