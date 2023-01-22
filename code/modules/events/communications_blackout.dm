/datum/event/communications_blackout/announce()
	var/alert = pick(	"Обнаружены ионосферные аномалии. Временный сбой связи неизбежен. Пожалуйста, свяжитесь с вашим*%fj00)`5vc-BZZT", \
						"Обнаружены ионосферные аномалии. Временный сбой связи не*3жmеgнa;b4;'1v�-BZZZT", \
						"Обнаружены ионосферные аномалии. Временный телек#MCi46:5.;@63-BZZZZT", \
						"Обнаружены ионосферные аном'иfZ\\kg5_0-BZZZZZT", \
						"Обнаруже:%' MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>'%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in GLOB.player_list)	//AIs are always aware of communication blackouts.
		if(A.z in affecting_z)
			to_chat(A, "<br>")
			to_chat(A, "<span class='warning'><b>[alert]</b></span>")
			to_chat(A, "<br>")

	if(prob(80))	//Announce most of the time, just not always to give some wiggle room for possible sabotages.
		command_announcement.Announce(alert, new_sound = sound('sound/misc/interference.ogg', volume=25), zlevels = affecting_z)


/datum/event/communications_blackout/start()
	for(var/obj/machinery/telecomms/T in telecomms_list)
		if(T.z in affecting_z)
			if(prob(T.outage_probability))
				T.overloaded_for = max(severity * rand(90, 120), T.overloaded_for)
