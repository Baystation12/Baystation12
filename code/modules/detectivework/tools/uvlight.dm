/obj/item/device/uv_light
	name = "\improper UV light"
	desc = "A small handheld black light."
	icon = 'icons/obj/uv_light.dmi'
	icon_state = "uv_off"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	action_button_name = "Toggle UV light"
	matter = list(MATERIAL_STEEL = 150)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

	var/list/scanned = list()
	var/list/stored_alpha = list()
	var/list/reset_objects = list()

	var/range = 3
	var/on = 0
	var/step_alpha = 50

/obj/item/device/uv_light/attack_self(mob/user)
	on = !on
	if(on)
		set_light(0.5, 0.1, range, 2, "#007fff")
		START_PROCESSING(SSobj, src)
		icon_state = "uv_on"
	else
		set_light(0)
		clear_last_scan()
		STOP_PROCESSING(SSobj, src)
		icon_state = "uv_off"

/obj/item/device/uv_light/proc/clear_last_scan()
	if(length(scanned))
		for(var/atom/O in scanned)
			O.set_invisibility(scanned[O])
			if(O.fluorescent == ATOM_FLOURESCENCE_ACTVE)
				O.fluorescent = ATOM_FLOURESCENCE_INACTIVE
		scanned.Cut()
	if(length(stored_alpha))
		for(var/atom/O in stored_alpha)
			O.alpha = stored_alpha[O]
			if(O.fluorescent == ATOM_FLOURESCENCE_ACTVE)
				O.fluorescent = ATOM_FLOURESCENCE_INACTIVE
		stored_alpha.Cut()
	if(length(reset_objects))
		for(var/obj/item/I in reset_objects)
			I.overlays -= I.blood_overlay
			if(I.fluorescent == ATOM_FLOURESCENCE_ACTVE)
				I.fluorescent = ATOM_FLOURESCENCE_INACTIVE
		reset_objects.Cut()

/obj/item/device/uv_light/Process()
	clear_last_scan()
	if(on)
		step_alpha = round(255/range)
		var/turf/origin = get_turf(src)
		if(!origin)
			return
		for(var/turf/T in range(range, origin))
			var/use_alpha = 255 - (step_alpha * get_dist(origin, T))
			for(var/atom/A in T.contents)
				if(A.fluorescent == ATOM_FLOURESCENCE_INACTIVE)
					A.fluorescent = ATOM_FLOURESCENCE_ACTVE
					if(A.invisibility)
						scanned[A] = A.invisibility
						A.set_invisibility(0)
						stored_alpha[A] = A.alpha
						A.alpha = use_alpha
					if(istype(A, /obj/item))
						var/obj/item/O = A
						if(O.was_bloodied && !(O.blood_overlay in O.overlays))
							O.overlays |= O.blood_overlay
							reset_objects |= O
