/obj/item/device/auditory_locator
	name = "auditory locator"
	desc = "It looks like it's been assembled from various spare parts."
	icon_state = "auditory_locator"
	item_state = "device"
	w_class = 1.0
	flags = FPRINT | TABLEPASS | CONDUCT

	var/spamcheck = 0

/obj/item/device/auditory_locator/attack_self(mob/living/carbon/user as mob)
	if (spamcheck)
		return

	spamcheck = 1

	user.show_message("The device appears to be powering up...")

	spawn (50)
		var/turf/turf = get_turf(src)

		playsound(turf, 'sound/items/auditory_locator.ogg', 25, 1, vary = 0, extrarange = 19, falloff = 2)

		if (src in user.contents) user.show_message("The device has finished powering up.")

		spawn (10)
			if (src in user.contents) user.show_message("The device begins playing a loud noise.", 2)

			for (var/mob/mob in orange(turf, 19))
				mob.show_message("You hear a noise coming from the [dir2text(get_dir(mob, turf))].", 2)

			spawn(240)
				spamcheck = 0