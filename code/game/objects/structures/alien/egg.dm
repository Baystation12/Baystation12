#define MAX_PROGRESS 100

/obj/structure/alien/egg
	desc = "It looks like a weird egg."
	name = "egg"
	icon_state = "egg_growing"
	density = 0
	anchored = 1
	var/progress = 0

/obj/structure/alien/New()
	..()
	processing_objects |= src

/obj/structure/alien/Destroy()
	processing_objects -= src
	..()

/obj/structure/alien/egg/process()
	if(progress < MAX_PROGRESS)
		progress++
		if(progress == MAX_PROGRESS)
			src << "todo alert goasts"
		update_icon()
		return
	// Max progress, cancel processing.
	processing_objects -= src

/obj/structure/alien/egg/update_icon()
	if(progress == -1)
		icon_state = "egg_hatched"
	else if(progress < MAX_PROGRESS)
		icon_state = "egg_growing"
	else
		icon_state = "egg"

/obj/structure/alien/egg/attack_ghost(var/mob/dead/observer/user)

	// Check for bans properly.
	if(jobban_isbanned(user, "Xenophage"))
		user << "<span class='danger'>You are banned from playing a xenophage.</span>"
		return

	if(progress == -1) //Egg has been hatched.
		return
	else if(progress < MAX_PROGRESS)
		user << "\The [src] has not yet matured."
		return

	var/confirm = alert(user, "Are you sure you want to join as a xenophage larva?", "Become Larva", "No", "Yes")

	if(!src || confirm != "Yes")
		return

	if(!user || !user.ckey)
		return

	flick("egg_opening",src)
	progress = -1 // No harvesting pls.
	sleep(5)

	if(!src || !user)
		visible_message("<span class='alium'>\The [src] writhes with internal motion, but nothing comes out.</span>")
		progress = MAX_PROGRESS // Someone else can have a go.
		return // What a pain.

	// Create the mob, transfer over key.
	var/mob/living/carbon/alien/larva/larva = new(get_turf(src))
	larva.ckey = user.ckey
	spawn(-1)
		if(user) qdel(user) // Remove the keyless ghost if it exists.

	visible_message("<span class='alium'>\The [src] splits open with a wet slithering noise, and \the [larva] writhes free!</span>")

	// Turn us into a hatched egg.
	name = "hatched alien egg"
	desc += " This one has hatched."
	update_icon()

#undef MAX_PROGRESS