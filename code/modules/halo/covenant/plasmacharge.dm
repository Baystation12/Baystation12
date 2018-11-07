
/obj/item/plasmacharge
	name = "plasma charge"
	desc = "An explosive Covenant device for breaching doors."
	icon = 'plasmacharge.dmi'
	icon_state = "plasmacharge"
	var/detonate_timer = 50

/obj/item/plasmacharge/attack(mob/living/M, mob/living/user, var/target_zone)
	if(istype(M, /obj/machinery/door/airlock))
		user.visible_message("<span class='warning'>[user] attaches [src] to [M] and sets it for a [detonate_timer/10] timer!</span>")
		user.drop_item()
		detonate(M)
		qdel(src)
	else
		return ..()

/obj/item/plasmacharge/proc/detonate(var/atom/movable/target)
	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/A = target
		spawn(detonate_timer)
			if(A)
				A.visible_message("<span class='warning'>A plasma charge detones on [src], breaking it open.</span>")
				A.open(1)
				A.set_broken()
