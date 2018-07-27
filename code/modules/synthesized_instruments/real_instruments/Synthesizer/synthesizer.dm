/datum/sound_player/synthesizer
	forced_sound_in = 0

/obj/structure/synthesized_instrument/synthesizer
	name = "The Synthesizer 3.0"
	desc = "This thing emits shockwaves as it plays. This is not good for your hearing."
	icon = 'synthesizer.dmi'
	icon_state = "synthesizer"
	anchored = 1
	density = 1
	var/datum/instrument/instruments = list()


/obj/structure/synthesized_instrument/synthesizer/Initialize()
	..()
	for (var/type in typesof(/datum/instrument))
		var/datum/instrument/new_instrument = new type
		if (!new_instrument.id) continue
		new_instrument.create_full_sample_deviation_map()
		src.instruments[new_instrument.name] = new_instrument
	src.real_instrument = new /datum/real_instrument(src, new /datum/sound_player/synthesizer(src, instruments[pick(instruments)]), instruments)

/obj/structure/synthesized_instrument/synthesizer/Destroy()
	QDEL_NULL(real_instrument)
	return ..()

/obj/structure/synthesized_instrument/synthesizer/attackby(obj/item/O, mob/user, params)
	if (istype(O, /obj/item/weapon/wrench))
		if (!anchored && !isinspace())
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to tighten \the [src] to the floor...</span>")
			if (do_after(user, 20))
				if(!anchored && !isinspace())
					user.visible_message( \
						"[user] tightens \the [src]'s casters.", \
						"<span class='notice'> You tighten \the [src]'s casters. Now it can be played again.</span>", \
						"<span class='italics'>You hear ratchet.</span>")
					src.anchored = 1
		else if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			to_chat(usr, "<span class='notice'> You begin to loosen \the [src]'s casters...</span>")
			if (do_after(user, 40))
				if(anchored)
					user.visible_message( \
						"[user] loosens \the [src]'s casters.", \
						"<span class='notice'> You loosen \the [src]. Now it can be pulled somewhere else.</span>", \
						"<span class='italics'>You hear ratchet.</span>")
					src.anchored = 0
	else
		..()

/obj/structure/synthesized_instrument/synthesizer/shouldStopPlaying(mob/user)
	return !((src && in_range(src, user) && src.anchored) || src.real_instrument.player.song.autorepeat)
