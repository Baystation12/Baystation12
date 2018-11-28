
/obj/machinery/autosurgeon
	name = "autodoctor"
	desc = "An advanced piece of machinery for automatically patching up external physical ailments."
	icon = 'autosurgeon.dmi'
	icon_state = "autosurgeon0"
	density = 1
	anchored = 1
	var/icon_state_base = "autosurgeon"
	var/botch_surgery = 0
	var/active = 0
	var/autosurgeon_stage = AUTOSURGEON_START
	var/obj/item/stack/medical/bruise_pack/internal_bruise_pack = new()
	var/obj/item/stack/medical/ointment/internal_ointment = new()
	var/obj/item/stack/medical/splint/internal_splint = new()

	//buckling
	can_buckle = 1
	buckle_dir = SOUTH
	buckle_lying = 1
	buckle_pixel_shift = "x=8;y=8"

	//timing
	var/autosurgeon_action_delay = 0
	var/next_autosurgeon_action = 0
	var/autosurgeon_timeout = 0
	var/start_delay = 60
	var/do_start_delay = 0

	var/list/allowed_species = list(/datum/species/human)

/obj/machinery/autosurgeon/New()
	. = ..()
	internal_bruise_pack.max_amount = 100
	internal_bruise_pack.amount = 10
	internal_ointment.max_amount = 100
	internal_ointment.amount = 10
	internal_splint.max_amount = 100
	internal_splint.amount = 10

/obj/machinery/autosurgeon/proc/set_active(var/new_active)
	if(new_active && !active)
		active = 1

		//startup delay
		if(do_start_delay)
			next_autosurgeon_action = world.time + start_delay
			do_start_delay = 0
		else
			next_autosurgeon_action = world.time + autosurgeon_action_delay

	else if(!new_active && active)
		active = 0
		botch_surgery = 0
		icon_state = "[icon_state_base]0"
		autosurgeon_stage = AUTOSURGEON_START

		//helpfully inform the world
		if(buckled_mob)
			if(buckled_mob.stat == 2)
				src.visible_message("<span class='warning'>\The [src] finishes tending to [buckled_mob] as all signs of life have ceased. The straps slide back</span>")
			else
				src.visible_message("<span class='notice'>\The [src] finishes tending to [buckled_mob]. The straps slide back.</span>")
			unbuckle_mob()
		else
			src.visible_message("<span class='notice'>\The [src] fades into stillness.</span>")
