/proc/isflamesource(A)
	if(istype(A, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = A
		return (WT.isOn())
	else if(istype(A, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = A
		return (F.lit)
	else if(istype(A, /obj/item/device/assembly/igniter))
		return 1
	return 0

//For anything that can light stuff on fire
/obj/item/weapon/flame
	var/lit = 0
	var/waterproof

/obj/item/weapon/flame/proc/light()
	if(lit)
		return 0
	lit = 1
	processing_objects |= src
	update_icon()
	return 1

/obj/item/weapon/flame/proc/die()
	if(!lit)
		return 0
	processing_objects -= src
	lit = 0
	update_icon()
	return 1

/obj/item/weapon/flame/process()
	if(lit)
		if(isliving(loc))
			var/mob/living/M = loc
			M.IgniteMob()
		var/turf/location = get_turf(src)
		if(istype(location))
			location.hotspot_expose(700, 5)
		update_icon()
	return lit
