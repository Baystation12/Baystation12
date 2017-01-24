/mob/observer/ghost/var/ghost_magic_cd = 0

/datum/antagonist/cultist/proc/add_ghost_magic(var/mob/observer/ghost/M)
	if(max_cult_rating >= CULT_GHOSTS_1)
		M.verbs += /mob/observer/ghost/proc/flick_lights
		M.verbs += /mob/observer/ghost/proc/bloody_doodle
		M.verbs += /mob/observer/ghost/proc/shatter_glass
		M.verbs += /mob/observer/ghost/proc/slice
		if(max_cult_rating >= CULT_GHOSTS_2)
			M.verbs += /mob/observer/ghost/proc/move_item
			M.verbs += /mob/observer/ghost/proc/whisper_to_cultist
			M.verbs += /mob/observer/ghost/proc/bite_someone
			M.verbs += /mob/observer/ghost/proc/chill_someone
			if(max_cult_rating >= CULT_GHOSTS_3)
				M.verbs += /mob/observer/ghost/proc/whisper_to_anyone
				M.verbs += /mob/observer/ghost/proc/bloodless_doodle
				M.verbs += /mob/observer/ghost/proc/toggle_visiblity

/mob/observer/ghost/proc/ghost_ability_check()
	var/turf/T = get_turf(src)
	if(T.holy)
		to_chat(src, "<span class='notice'>You may not use your abilities on the blessed ground.</span>")
		return 0
	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need [round((ghost_magic_cd - world.time) / 10)] more seconds before you can use your abilities.</span>")
		return 0
	return 1

/mob/observer/ghost/proc/flick_lights()
	set category = "Cult"
	set name = "Flick lights"
	set desc = "Flick some lights around you."

	if(!ghost_ability_check())
		return

	for(var/obj/machinery/light/L in range(3))
		L.flicker()

	ghost_magic_cd = world.time + 30 SECONDS

/mob/observer/ghost/proc/bloody_doodle()
	set category = "Cult"
	set name = "Write in blood"
	set desc = "Write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	bloody_doodle_proc(0)

/mob/observer/ghost/proc/bloody_doodle_proc(var/bloodless = 0)
	if(!ghost_ability_check())
		return

	var/doodle_color = "#A10808"

	var/turf/simulated/T = get_turf(src)
	if(!istype(T))
		to_chat(src, "<span class='warning'>You cannot doodle there.</span>")
		return

	var/num_doodles = 0
	for(var/obj/effect/decal/cleanable/blood/writing/W in T)
		num_doodles++
	if(num_doodles > 4)
		to_chat(src, "<span class='warning'>There is no space to write on!</span>")
		return

	var/obj/effect/decal/cleanable/blood/choice
	if(!bloodless)
		var/list/choices = list()
		for(var/obj/effect/decal/cleanable/blood/B in range(1))
			if(B.amount > 0)
				choices += B

		if(!choices.len)
			to_chat(src, "<span class = 'warning'>There is no blood to use nearby.</span>")
			return

		choice = input(src, "What blood would you like to use?") as null|anything in choices
		if(!choice)
			return

		if(choice.basecolor)
			doodle_color = choice.basecolor

	var/max_length = 50

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.", "Blood writing", ""))

	if(!ghost_ability_check())
		return

	if(message && (bloodless || (choice && (choice in range(1)))))
		if(length(message) > max_length)
			message += "-"
			to_chat(src, "<span class='warning'>You ran out of blood to write with!</span>")

		var/obj/effect/decal/cleanable/blood/writing/W = new(T)
		W.basecolor = doodle_color
		W.update_icon()
		W.message = message
		W.add_hiddenprint(src)
		if(!bloodless)
			W.visible_message("<span class='warning'>Invisible fingers crudely paint something in blood on \the [T].</span>")
		else
			W.visible_message("<span class='warning'>Blood appears out of nowhere as invisible fingers crudely paint something on \the [T].</span>")

		log_admin("[src] ([src.key]) used ghost magic to write '[message]' - [x]-[y]-[z]")

	ghost_magic_cd = world.time + 30 SECONDS

/mob/observer/ghost/proc/shatter_glass()
	set category = "Cult"
	set name = "Noise: glass shatter"
	set desc = "Make a sound of glass being shattered."

	if(!ghost_ability_check())
		return

	playsound(loc, "shatter", 50, 1)

	ghost_magic_cd = world.time + 5 SECONDS

/mob/observer/ghost/proc/slice()
	set category = "Cult"
	set name = "Noise: slice"
	set desc = "Make a sound of a sword hit."

	if(!ghost_ability_check())
		return

	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1)

	ghost_magic_cd = world.time + 5 SECONDS

/mob/observer/ghost/proc/move_item()
	set category = "Cult"
	set name = "Move item"
	set desc = "Move a small item to where you are."

	if(!ghost_ability_check())
		return

	var/turf/T = get_turf(src)

	var/list/obj/item/choices = list()
	for(var/obj/item/I in range(1))
		if(I.w_class <= 2)
			choices += I

	if(!choices.len)
		to_chat(src, "<span class='warning'>There are no suitable items nearby.</span>")
		return

	var/obj/item/choice = input(src, "What item would you like to pull?") as null|anything in choices
	if(!choice || !(choice in range(1)) || choice.w_class > 2)
		return

	if(!ghost_ability_check())
		return

	if(step_to(choice, T))
		choice.visible_message("<span class='warning'>\The [choice] suddenly moves!</span>")

	ghost_magic_cd = world.time + 60 SECONDS

/mob/observer/ghost/proc/whisper_to_cultist()
	set category = "Cult"
	set name = "Whisper to mind"
	set desc = "Whisper to a human of your choice. If they are adjusted enough, they'll hear you."

	whisper_proc()

/mob/observer/ghost/proc/whisper_proc(var/anyone = 0)
	if(!ghost_ability_check())
		return

	var/list/mob/living/choices = list()
	for(var/mob/living/M in range(1))
		choices += M

	var/mob/living/choice = input(src, "Whom do you want to whisper to?") as null|anything in choices
	if(!choice)
		return

	var/message = sanitize(input("Decide what you want to whisper.", "Whisper", ""))

	if(!ghost_ability_check())
		return

	if(message)
		if(iscultist(choice) || anyone)
			to_chat(choice, "<span class='notice'>You hear a faint whisper... It says... \"[message]\"</span>")
			log_and_message_admins("used ghost magic to say '[message]' to \the [choice] and was heard - [x]-[y]-[z]")
		else
			to_chat(choice, "<span class='notice'>You hear a faint whisper, but you can't make out the words.</span>")
			log_and_message_admins("used ghost magic to say '[message]' to \the [choice] but wasn't heard - [x]-[y]-[z]")
		to_chat(src, "You whisper to \the [choice]. Perhaps they heard you.")

	ghost_magic_cd = world.time + 100 SECONDS

/mob/observer/ghost/proc/bite_someone()
	set category = "Cult"
	set name = "Bite"
	set desc = "Bite or scratch someone."

	if(!ghost_ability_check())
		return

	var/list/mob/living/carbon/human/choices = list()
	for(var/mob/living/carbon/human/H in range(1))
		choices += H

	var/mob/living/carbon/human/choice = input(src, "Whom do you want to scratch?") as null|anything in choices
	if(!choice)
		return

	if(!ghost_ability_check())
		return

	var/method = pick("bit", "scratched")
	to_chat(choice, "<span class='danger'>Something invisible [method] you!</span>")
	choice.apply_effect(5, PAIN, 0)
	to_chat(src, "<span class='notice'>You [method] \the [choice].</span>")

	log_and_message_admins("used ghost magic to bite \the [choice] - [x]-[y]-[z]")

	ghost_magic_cd = world.time + 60 SECONDS

/mob/observer/ghost/proc/chill_someone()
	set category = "Cult"
	set name = "Chill"
	set desc = "Pass through someone, making them feel the chill of afterlife for a moment."

	if(!ghost_ability_check())
		return

	var/list/mob/living/carbon/human/choices = list()
	for(var/mob/living/carbon/human/H in range(1))
		choices += H

	var/mob/living/carbon/human/choice = input(src, "Whom do you want to scare?") as null|anything in choices
	if(!choice)
		return

	if(!ghost_ability_check())
		return

	to_chat(choice, "<span class='danger'>You feel as if something cold passed through you!</span>")
	if(choice.bodytemperature >= choice.species.cold_level_1 + 1)
		choice.bodytemperature = max(choice.species.cold_level_1 + 1, choice.bodytemperature - 30)
	to_chat(src, "<span class='notice'>You pass through \the [choice], giving them a sudden chill.</span>")

	log_and_message_admins("used ghost magic to chill \the [choice] - [x]-[y]-[z]")

	ghost_magic_cd = world.time + 60 SECONDS

/mob/observer/ghost/proc/whisper_to_anyone()
	set category = "Cult"
	set name = "Whisper loudly to mind"
	set desc = "Whisper to a human of your choice."

	whisper_proc(1)

/mob/observer/ghost/proc/bloodless_doodle()
	set category = "Cult"
	set name = "Write in own blood"
	set desc = "Write a short message in blood on the floor or a wall. You don't need blood nearby to use this."

	bloody_doodle_proc(1)

/mob/observer/ghost/proc/toggle_visiblity()
	set category = "Cult"
	set name = "Toggle Visibility"
	set desc = "Allows you to become visible or invisible at will."

	if(invisibility && !ghost_ability_check())
		return

	if(invisibility == 0)
		ghost_magic_cd = world.time + 60 SECONDS
		to_chat(src, "<span class='info'>You are now invisible.</span>")
		visible_message("<span class='emote'>It fades from sight...</span>")
		invisibility = INVISIBILITY_OBSERVER
		mouse_opacity = 1
	else
		ghost_magic_cd = world.time + 60 SECONDS
		to_chat(src, "<span class='info'>You are now visible.</span>")
		invisibility = 0
		mouse_opacity = 0 // This is so they don't make people invincible to melee attacks by hovering over them
