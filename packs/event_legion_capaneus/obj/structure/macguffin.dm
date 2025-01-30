/obj/structure/drive
	name = "defiled Alden-Saraspova drive foundation"
	desc = "The legendary Alden-Saraspova drive, fitted through the floor and usually settled on bigger warships. This seems out of place."
	icon = 'packs/event_legion_capaneus/icons/macguffin.dmi'
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | PIXEL_SCALE
	opacity = FALSE
	density = TRUE
	anchored = TRUE
	health_max = 99999

	/// Disabling steps.
	var/step = 0
	/// Drive ambient loop.
	var/drive_sound

/obj/structure/drive/attack_hand(mob/living/user)
	. = ..()

	if (!istype (src, /obj/structure/drive/console))
		return

	if (step == 2)
		to_chat(user, SPAN_WARNING("The drive is already disabled! \The [src] is inoperable, now."))
		return

	if (!step)
		if (!user.skill_check(SKILL_SCIENCE, SKILL_EXPERIENCED))
			to_chat(user, SPAN_WARNING("You can't make heads nor tails of \the [src]!"))
			return

		user.visible_message(
			SPAN_NOTICE("\The [user] begins to examine and fiddle with \the [src]."),
			SPAN_NOTICE("You begin to look over \the [src], disabling odd clamps along the way. They feel cool and wet to the touch.")
		)

		if (!do_after(user, 7 SECONDS, src, DO_PUBLIC_UNIQUE))
			return

		playsound(src, 'sound/effects/attackblob.ogg', 70)
		to_chat(user, SPAN_NOTICE("The drive itself can now be disabled by someone experienced in engine operation by engaging the manual shutdown procedures from this console."))
		step++
		return

	if (!user.skill_check(SKILL_ENGINES, SKILL_EXPERIENCED))
		to_chat(user, SPAN_WARNING("You don't know how to operate \the [src] further!"))
		return

	user.visible_message(
		SPAN_NOTICE("\The [user] begins to carefully disable \the [src]."),
		SPAN_NOTICE("You begin to cautiously disengage the drive's operation procedures, shutting down the under-floor positron chamber.")
	)
	playsound(src, 'sound/machines/keyboard/keystroke4.ogg', 70)

	if (!do_after(user, 12 SECONDS, src, DO_PUBLIC_UNIQUE))
		return

	to_chat(user, SPAN_NOTICE("You manage to disable the drive."))
	playsound(src, 'sound/machines/ventcrawl.ogg', 100)
	playsound(src, 'sound/machines/apc_nopower.ogg', 40)
	step++

	update_icon()
	return


/obj/structure/drive/cap
	icon_state = "drive_cap"


/obj/structure/drive/cylinder
	icon_state = "drive_cylinder"


/obj/structure/drive/cylinder/Initialize()
	. = ..()
	drive_sound = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/ambience/ambiservers.ogg', 20, 7)


/obj/structure/drive/box
	icon_state = "drive_box"


/obj/structure/drive/console
	name = "defiled Alden-Saraspova drive console"
	icon_state = "drive_console"
	desc = "<span class='notice'>It looks tampered with, and has odd electronics running through it. You will need someone experienced in the sciences to resolve the locks, and discover further steps to disable it manually.</span>"


/obj/structure/drive/on_update_icon(atom/a)

	if (step == 2)
		icon_state += "_off"

		if (istype(a, /obj/structure/drive/box))
			for (a in range(src, 5))
				a.icon_state += "_off"

		if (istype(a, /obj/structure/drive/cap))
			for (a in range(src, 5))
				a.icon_state += "_off"

		if (istype(a, /obj/structure/drive/cylinder))
			for (a in range(src, 5))
				a.icon_state += "_off"

	return
