/obj/machinery/anomaly_container
	name = "anomaly container"
	desc = "A massive, steel container used to transport anomalous materials in a suspended state."
	icon = 'icons/obj/machines/research/anomaly_cage.dmi'
	icon_state = "anomaly_container"
	density = TRUE
	idle_power_usage = 0
	active_power_usage = 1 KILOWATTS
	construct_state = /singleton/machine_construction/default/panel_closed
	health_max = 200
	health_min_damage = 10
	req_access = list(access_research)

	machine_name = "anomaly container"
	machine_desc = "A container with an integrated suspension generator to keep anything inside in stasis for the sake of its own safety, and their surroundings."

	var/obj/machinery/artifact/contained
	var/obj/item/paper/attached_paper
	var/locked
	var/broken

/obj/machinery/anomaly_container/Initialize()
	. = ..()
	var/obj/machinery/artifact/A = locate() in loc
	if(A)
		contain(A)

/obj/machinery/anomaly_container/Destroy()
	QDEL_NULL(contained)
	QDEL_NULL(attached_paper)
	..()

/obj/machinery/anomaly_container/attack_hand(mob/user)
	if(!contained)
		to_chat(user, SPAN_WARNING("There's nothing inside \the [src]."))
		return
	if (stat & MACHINE_STAT_NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] remains inert, a small light flashing red."))
		return
	if(Adjacent(user))
		if(!src.allowed(user))
			to_chat(user, SPAN_WARNING("\The [src] blinks red, notifying you of your incorrect access."))
			return
		if(!src.health_dead)
			user.visible_message(
				SPAN_NOTICE("\The [user] begins undoing the locks and latches on \the [src]..."),
				SPAN_NOTICE("You begin undoing the locks and latches on \the [src]...")
			)
			if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
				return
			user.visible_message(
				SPAN_NOTICE("\The [user] finishes undoing the locks and opens the hatch on \the [src]."),
				SPAN_NOTICE("You finish undoing the locks and open the hatch on \the [src].")
			)
			playsound(loc, 'sound/mecha/hydraulic.ogg', 40)
			release()
		else
			to_chat(user, SPAN_WARNING("\The [src] requires a wrench to free its contents out."))
			return
	else
		return ..()

/obj/machinery/anomaly_container/attack_robot(mob/user)
	if(!contained)
		to_chat(user, SPAN_WARNING("There's nothing inside \the [src]."))
		return
	if (stat & MACHINE_STAT_NOPOWER)
		to_chat(user, SPAN_WARNING("\The [src] remains inert, a small light flashing red."))
		return
	if(Adjacent(user))
		if(!src.allowed(user))
			to_chat(user, SPAN_WARNING("\The [src] blinks red, notifying you of your incorrect access."))
			return
		if(!src.health_dead)
			user.visible_message(
				SPAN_NOTICE("\The [user] begins undoing the locks and latches on \the [src]..."),
				SPAN_NOTICE("You begin undoing the locks and latches on \the [src]...")
			)

			if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
				return
			user.visible_message(
					SPAN_NOTICE("\The [user] finishes undoing the locks and opens the hatch on \the [src]."),
					SPAN_NOTICE("You finish undoing the locks and open the hatch on \the [src].")
				)
			playsound(loc, 'sound/mecha/hydraulic.ogg', 40)
			release()
	else
		return ..()

/obj/machinery/anomaly_container/examine(mob/user, distance)
	. = ..()
	if (contained)
		to_chat(usr, SPAN_NOTICE("\The [contained] is kept inside."))
	if (attached_paper)
		to_chat(usr, SPAN_NOTICE("There's a paper clipped on the side."))
		attached_paper.examine(user, distance)
	if (health_dead)
		to_chat(usr, SPAN_DANGER("The borosilicate panels are completely shattered."))

/obj/machinery/anomaly_container/proc/contain(obj/machinery/artifact)
	if(contained)
		return
	contained = artifact
	artifact.forceMove(src)
	underlays += image(artifact)
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/anomaly_container/proc/release()
	if(!contained)
		return
	contained.dropInto(src)
	contained = null
	underlays.Cut()
	update_use_power(POWER_USE_IDLE)

/obj/machinery/artifact/MouseDrop(obj/machinery/anomaly_container/over_object, mob/user)
	if(istype(over_object) && CanMouseDrop(over_object, usr))
		if (over_object.health_dead())
			visible_message(SPAN_WARNING("\The [over_object]'s containment is broken shut."))
			return
		if (!over_object.allowed(usr))
			visible_message(SPAN_WARNING("\The [over_object] blinks red, refusing to open."))
			return
		user.visible_message(
			SPAN_NOTICE("\The [usr] begins placing \the [src] into \the [over_object]."),
			SPAN_NOTICE("You begin placing \the [src] into \the [over_object].")
		)
		if(!do_after(usr, 4 SECONDS, over_object, DO_PUBLIC_UNIQUE))
			return
		user.visible_message(SPAN_NOTICE("The bolts on \the [over_object] drop with an hydraulic hiss, sealing its contents."))
		playsound(loc, 'sound/mecha/hydraulic.ogg', 40)
		Bumped(usr)
		over_object.contain(src)
	return
/obj/machinery/anomaly_container/on_death()
	visible_message(SPAN_DANGER("\The [src]'s glass cracks and shatters, exploding in a shower of shards!"))
	for(var/i = 1 to rand(2,4))
		new /obj/item/material/shard(get_turf(src), MATERIAL_BORON_GLASS)
	playsound(loc, 'sound/effects/Glassbr1.ogg', 60)
	if(!contained)
		return
	contained.my_effect.ToggleActivate(1)
	broken = TRUE
	..()

/obj/machinery/anomaly_container/emp_act(severity)
	SHOULD_CALL_PARENT(FALSE)
	if(health_dead)
		return
	if(contained)
		visible_message(SPAN_DANGER("\The [src]'s latches break loose, freeing the contents!"))
		playsound(loc, 'sound/mecha/hydraulic.ogg', 40)
		release()
	GLOB.empd_event.raise_event(src, severity)


/obj/machinery/anomaly_container/attackby(obj/item/P, mob/user)
	if (istype(P, /obj/item/paper))
		if(attached_paper)
			to_chat(user, SPAN_NOTICE("You swap the reports on \the [src]."))
			P.forceMove(src.loc)
			P.add_fingerprint(usr)
			user.drop_item(P, loc, 1)
			P.forceMove(src)
			user.put_in_hands(P)
			attached_paper = P
		else
			to_chat(user, SPAN_NOTICE("You clip \the [P] to \the [src]'s side."))
			user.drop_item(P, loc, 1)
			attached_paper = P
			P.forceMove(src)

	else if(istype(P, /obj/item/stack/material))
		if (!health_dead)
			to_chat(user, SPAN_NOTICE("\The [src] doesn't require repairs."))
		else
			if (contained)
				user.visible_message(
					SPAN_WARNING("\The [src] must be emptied before repairs can be done!")
				)
				return
			var/obj/item/stack/material/M = P
			if(istype(M, /obj/item/stack/material/glass/boron))
				to_chat(user, SPAN_WARNING("\The [M] needs to be reinforced first."))
			if(istype(P, /obj/item/stack/material/glass/boron_reinforced))
				if(M.get_amount() < 10)
					to_chat(user, SPAN_WARNING("You need at least ten sheets to repair \the [src]."))
				else
					user.visible_message(
						SPAN_NOTICE("[user] begins to repair \the [src]'s containment with \the [M]."),
						SPAN_NOTICE("You being to repair \the [src]'s containment with \the [M].")
					)
					if(!do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
						return
					user.visible_message(
						SPAN_NOTICE("[user] repairs \the [src]'s containment with \the [M]."),
						SPAN_NOTICE("You repair \the [src]'s containment with \the [M].")
					)
					M.use(10)
					revive_health()
					icon_state = "anomaly_container"


	else if (isWrench(P))
		if (!health_dead)
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] begins to wrench apart the bolts on \the [src]..."),
			SPAN_NOTICE("You begin to wrench apart the bolts on \the [src]...")
		)
		if(!do_after(user, 8 SECONDS, src, DO_PUBLIC_UNIQUE))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] carefully loosens off \the [src]'s dented panel with \the [P], freeing its contents."))
		playsound(loc, 'sound/items/Ratchet.ogg', 80, 1)
		release()
	add_fingerprint(user)
	update_icon()
	return ..()

/obj/machinery/anomaly_container/on_update_icon()
	ClearOverlays()
	if(health_dead)
		icon_state = "anomaly_container_broken"
	if(attached_paper)
		AddOverlays("anomaly_container_paper")
	if(panel_open)
		AddOverlays("anomaly_container_panel")
	if(is_powered())
		AddOverlays(list(
			emissive_appearance(icon, "anomaly_container_lights"),
			"anomaly_container_lights"
		))
