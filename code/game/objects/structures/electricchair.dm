/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair0"
	var/on = 0
	var/obj/item/assembly/shock_kit/part = null
	var/last_time = 1.0
	buckle_movable = FALSE
	bed_flags = BED_FLAG_CANNOT_BE_ELECTRIFIED | BED_FLAG_CANNOT_BE_PADDED

/obj/structure/bed/chair/e_chair/New()
	..()
	AddOverlays(image('icons/obj/structures/furniture.dmi', src, "echair_over", MOB_LAYER + 1, dir))
	return


/obj/structure/bed/chair/e_chair/use_tool(obj/item/tool, mob/user, list/click_params)
	// Wrench - Dismantle electric chair
	if (isWrench(tool))
		var/obj/structure/bed/chair/chair = new /obj/structure/bed/chair(loc)
		playsound(src, 'sound/items/Ratchet.ogg', 50, TRUE)
		chair.set_dir(dir)
		part.dropInto(loc)
		part.master = null
		transfer_fingerprints_to(chair)
		user.visible_message(
			SPAN_NOTICE("\The [user] removes \the [part] from \the [chair] with \a [tool]."),
			SPAN_NOTICE("You remove \the [part] from \the [chair] with \the [tool].")
		)
		part = null
		qdel_self()
		return TRUE

	return ..()


/obj/structure/bed/chair/e_chair/verb/toggle()
	set name = "Toggle Electric Chair"
	set category = "Object"
	set src in oview(1)

	if(on)
		on = 0
		icon_state = "echair0"
	else
		on = 1
		icon_state = "echair1"
	to_chat(usr, SPAN_NOTICE("You switch [on ? "on" : "off"] [src]."))
	return

/obj/structure/bed/chair/e_chair/rotate()
	..()
	ClearOverlays()
	AddOverlays(image('icons/obj/structures/furniture.dmi', src, "echair_over", MOB_LAYER + 1, dir))
	return

/obj/structure/bed/chair/e_chair/proc/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	// special power handling
	var/area/A = get_area(src)
	if(!isarea(A))
		return
	if(!A.powered(EQUIP))
		return
	A.use_power_oneoff(5000, EQUIP)
	var/light = A.power_light
	A.update_icon()

	flick("echair1", src)
	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(12, 1, src)
	s.start()
	if(buckled_mob)
		buckled_mob.burn_skin(85)
		to_chat(buckled_mob, SPAN_DANGER("You feel a deep shock course through your body!"))
		sleep(1)
		buckled_mob.burn_skin(85)
		buckled_mob.Stun(600)
	visible_message(SPAN_DANGER("The electric chair went off!"), SPAN_DANGER("You hear a deep sharp shock!"))

	A.power_light = light
	A.update_icon()
	return
