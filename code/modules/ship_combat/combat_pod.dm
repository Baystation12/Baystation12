/obj/machinery/space_battle/combat_pod
	name = "Combat Pod"
	desc = "A pod for launching yourself out of cannons!"
	icon_state = "combat_pod"

	var/mob/living/carbon/human/contained

/obj/machinery/space_battle/combat_pod/Bump(atom/hit_atom)
	explosion(hit_atom, 0, 2, 3, 4)
	spawn(50)
		contained.forceMove(get_turf(src))
		src.visible_message("<span class='danger'>\The [src] starts to fizzle violently..</span>")
		contained = null
		spawn(50)
			explosion(src, 1,2,3,4)
			qdel(src)
	return 1

/obj/machinery/space_battle/combat_pod/ex_act()
	return 1

/obj/machinery/space_battle/combat_pod/verb/climb_inside()
	set name = "Climb Inside"
	set desc = "Climb Inside the Combat Pod."
	set category = "Object"

	if(usr && istype(usr, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.visible_message("<span class='notice'>\The [H] begins climbing inside \the [src]..</span>")
		if(do_after(H, 100))
			H.visible_message("<span class='notice'>\The [H] climbs inside \the [src]..</span>")
			H.forceMove(src)
			contained = H

/obj/machinery/space_battle/combat_pod/verb/eject()
	set name = "Eject"
	set desc = "Eject the occupant of the combat pod."
	set category = "Object"

	if(contained)
		contained.forceMove(get_turf(src))
		contained = null


