/obj/item/device/radio/intercom
	name = "station intercom"
	desc = "Talk through this."
	icon_state = "intercom"
	anchored = 1
	w_class = 4.0
	canhear_range = 2
	flags = CONDUCT | NOBLOODY
	var/number = 0
	var/anyai = 1
	var/mob/living/silicon/ai/ai = list()
	var/last_tick //used to delay the powercheck

/obj/item/device/radio/intercom/New(turf/loc, var/ndir = 0)
	..()
	processing_objects.Add(src)
	if(ndir)
		pixel_x = (ndir & (NORTH|SOUTH))? 0 : (ndir == EAST ? 28 : -28)
		pixel_y = (ndir & (NORTH|SOUTH))? (ndir == NORTH ? 28 : -28) : 0
		set_dir(ndir)
	update_icon()

/obj/item/device/radio/intercom/Destroy()
	processing_objects.Remove(src)
	..()

/obj/item/device/radio/intercom/attack_ai(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	spawn (0)
		attack_self(user)

/obj/item/device/radio/intercom/attack_self(mob/user as mob)
	if(b_stat && wires.IsAllCut() && !user.isMobAI())
		var/frame = new /obj/item/mounted/frame/intercom(get_turf(src))
		user.visible_message("<span class='warning'>[user] has removed \the [frame] from the wall!</span>", "<span class='notice'>You remove \the [frame] from the wall.</span>")
		qdel(src)
	else
		..()

/obj/item/device/radio/intercom/receive_range(freq, level)
	if (!on)
		return -1
	if(!(0 in level))
		var/turf/position = get_turf(src)
		if(isnull(position) || !(position.z in level))
			return -1
	if (!src.listening)
		return -1
	if(freq in ANTAG_FREQS)
		if(!(src.syndie))
			return -1//Prevents broadcast of messages over devices lacking the encryption

	return canhear_range


/obj/item/device/radio/intercom/hear_talk(mob/M as mob, msg)
	if(!src.anyai && !(M in src.ai))
		return
	..()

/obj/item/device/radio/intercom/process()
	if(((world.timeofday - last_tick) > 30) || ((world.timeofday - last_tick) < 0))
		last_tick = world.timeofday

		if(!src.loc)
			on = 0
		else
			var/area/A = src.loc.loc
			if(!A || !isarea(A))
				on = 0
			else
				on = A.powered(EQUIP) // set "on" to the power status

		if(!on)
			icon_state = "intercom-p"
		else
			icon_state = "intercom"
