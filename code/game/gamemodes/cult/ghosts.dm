/mob/dead/observer/var/ghost_magic_cd = 0

/datum/antagonist/cultist/proc/add_ghost_magic(var/mob/dead/observer/M)
	M.verbs += /mob/dead/observer/proc/flick_lights
	if(cult_level >= 2)
		M.verbs += /mob/dead/observer/proc/bloody_doodle
		M.verbs += /mob/dead/observer/proc/shatter_glass
		M.verbs += /mob/dead/observer/proc/slice
		if(cult_level >= 3)
			M.verbs += /mob/dead/observer/proc/move_item
			M.verbs += /mob/dead/observer/proc/whisper_to_cultist
			M.verbs += /mob/dead/observer/proc/bite_someone
			M.verbs += /mob/dead/observer/proc/chill_someone
			if(cult_level >= 4)
				M.verbs += /mob/dead/observer/proc/whisper_to_anyone
				M.verbs += /mob/dead/observer/proc/bloodless_doodle
				M.verbs += /mob/dead/observer/proc/toggle_visiblity

/mob/dead/observer/proc/flick_lights()
	set category = "Cult"
	set name = "Flick lights"
	set desc = "Flick some lights around you."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	for(var/obj/machinery/light/L in range(3))
		L.flicker()

	ghost_magic_cd = world.time + 30 SECONDS

//Used for drawing on walls with blood puddles as a spooky ghost.
/mob/dead/observer/proc/bloody_doodle(var/bloodless = 0)
	set category = "Cult"
	set name = "Write in blood"
	set desc = "Write a short message in blood on the floor or a wall. Remember, no IC in OOC or OOC in IC."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	var/doodle_color = "#A10808"

	if(!bloodless)
		var/list/choices = list()
		for(var/obj/effect/decal/cleanable/blood/B in range(1))
			if(B.amount > 0)
				choices += B

		if(!choices.len)
			to_chat(src, "<span class = 'warning'>There is no blood to use nearby.</span>")
			return

		var/obj/effect/decal/cleanable/blood/choice = input(src, "What blood would you like to use?") in null|choices
		if(!choice)
			return

		if(choice.basecolor)
			doodle_color = choice.basecolor

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

	var/max_length = 50

	var/message = sanitize(input("Write a message. It cannot be longer than [max_length] characters.", "Blood writing", ""))

	if(message)
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

	ghost_magic_cd = world.time + 30 SECONDS

/mob/dead/observer/proc/shatter_glass()
	set category = "Cult"
	set name = "Noise: glass shatter"
	set desc = "Make a sound of glass being shattered."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	playsound(loc, "shatter", 50, 1)

	ghost_magic_cd = world.time + 10 SECONDS

/mob/dead/observer/proc/slice()
	set category = "Cult"
	set name = "Noise: slice"
	set desc = "Make a sound of a sword hit."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1)

	ghost_magic_cd = world.time + 10 SECONDS

/mob/dead/observer/proc/move_item()
	set category = "Cult"
	set name = "Move item"
	set desc = "Move a small item to where you are."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	var/turf/T = get_turf(src)

	var/list/obj/item/choices = list()
	for(var/obj/item/I in range(1))
		if(I.w_class <= 2)
			choices += I

	if(!choices.len)
		to_chat(src, "<span class='warning'>There are no suitable items nearby.</span>")
		return

	var/obj/item/choice = input(src, "What item would you like to pull?") in null|choices
	if(!choice || choice.w_class > 2)
		return

	if(step_to(choice, T))
		choice.visible_message("<span class='warning'>\The [choice] suddenly moves!</span>")

	ghost_magic_cd = world.time + 60 SECONDS

/mob/dead/observer/proc/whisper_to_cultist(var/anyone = 0)
	set category = "Cult"
	set name = "Whisper to mind"
	set desc = "Whisper to a human of your choice. If they are adjusted enough, they'll hear you."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	var/list/mob/living/choices = list()
	for(var/mob/living/M in range(1))
		choices += M

	var/mob/living/choice = input(src, "Whom do you want to whisper to?") in null|choices
	if(!choice)
		return

	var/message = sanitize(input("Decide what you want to whisper.", "Whisper", ""))

	if(message)
		if(iscultist(choice) || anyone)
			to_chat(choice, "<span class='notice'>You hear a faint whisper... It says... \"[message]\"</span>")
		else
			to_chat(choice, "<span class='notice'>You hear a faint whisper, but you can't make out the words.</span>")
		to_chat(src, "You whisper to \the [choice]. Perhaps they heard you.")

	ghost_magic_cd = world.time + 100 SECONDS

/mob/dead/observer/proc/bite_someone()
	set category = "Cult"
	set name = "Bite"
	set desc = "Bite or scratch someone."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	var/list/mob/living/carbon/human/choices = list()
	for(var/mob/living/carbon/human/H in range(1))
		choices += H

	var/mob/living/carbon/human/choice = input(src, "Whom do you want to scratch?") in null|choices
	if(!choice)
		return

	var/method = pick("bit", "scratched")
	to_chat(choice, "<span class='danger'>Something invisible [method] you!</span>")
	choice.apply_effect(5, AGONY, 0)
	to_chat(src, "<span class='notice'>You [method] \the [choice].</span>")

	ghost_magic_cd = world.time + 60 SECONDS

/mob/dead/observer/proc/chill_someone()
	set category = "Cult"
	set name = "Chill"
	set desc = "Pass through someone, making them feel the chill of afterlife for a moment."

	if(ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	var/list/mob/living/carbon/human/choices = list()
	for(var/mob/living/carbon/human/H in range(1))
		choices += H

	var/mob/living/carbon/human/choice = input(src, "Whom do you want to scare?") in null|choices
	if(!choice)
		return

	to_chat(choice, "<span class='danger'>You feel as if something cold passed through you!</span>")
	choice.apply_effect(5, AGONY, 0)
	to_chat(src, "<span class='notice'>You pass through \the [choice], giving them a sudden chill.</span>")

	ghost_magic_cd = world.time + 60 SECONDS

/mob/dead/observer/proc/whisper_to_anyone()
	set category = "Cult"
	set name = "Whisper loudly to mind"
	set desc = "Whisper to a human of your choice."

	whisper_to_cultist(1)

/mob/dead/observer/proc/bloodless_doodle()
	set category = "Cult"
	set name = "Write in own blood"
	set desc = "Write a short message in blood on the floor or a wall. You don't need blood nearby to use this."

	bloody_doodle(1)

/mob/dead/observer/proc/toggle_visiblity()
	set category = "Cult"
	set name = "Toggle Visibility"
	set desc = "Allows you to become visible or invisible at will."

	if(invisibility && ghost_magic_cd > world.time)
		to_chat(src, "<span class='notice'>You need some more time before you can use your abilities.</span>")
		return

	if(invisibility == 0)
		ghost_magic_cd = world.time + 60 SECONDS
		visible_message("<span class='emote'>It fades from sight...</span>", "<span class='info'>You are now invisible.</span>")
		invisibility = INVISIBILITY_OBSERVER
		mouse_opacity = 1
	else
		ghost_magic_cd = world.time + 60 SECONDS
		to_chat(src, "<span class='info'>You are now visible!</span>")
		invisibility = 0
		mouse_opacity = 0 // This is so they don't make people invincible to melee attacks by hovering over them
