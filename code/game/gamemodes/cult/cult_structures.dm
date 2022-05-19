/obj/structure/cult/pylon
	name = "pylon"
	desc = "A floating crystal that hums with an unearthly energy."
	icon = 'icons/obj/pylon.dmi'
	icon_state = "pylon"
	light_max_bright = 0.5
	light_inner_range = 1
	light_outer_range = 13
	light_color = "#3e0000"
	health_max = 20
	health_min_damage = 4
	damage_hitsound = 'sound/effects/Glasshit.ogg'

/obj/effect/gateway
	name = "gateway"
	desc = "You're pretty sure that abyss is staring back."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "portal"
	pixel_x = -16
	pixel_y = -16
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	density = TRUE
	unacidable = TRUE
	anchored = TRUE
	var/spawnable = null

/obj/effect/gateway/active
	light_outer_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat,
		/mob/living/simple_animal/hostile/creature,
		/mob/living/simple_animal/hostile/faithless
	)

/obj/effect/gateway/active/cult
	light_outer_range=5
	light_color="#ff0000"
	spawnable=list(
		/mob/living/simple_animal/hostile/scarybat/cult,
		/mob/living/simple_animal/hostile/creature/cult,
		/mob/living/simple_animal/hostile/faithless/cult
	)

/obj/effect/gateway/active/New()
	..()
	addtimer(CALLBACK(src, .proc/create_and_delete), rand(30,60) SECONDS)


/obj/effect/gateway/active/proc/create_and_delete()
	var/t = pick(spawnable)
	new t(src.loc)
	qdel(src)

/obj/effect/gateway/active/Crossed(var/atom/A)
	if(!istype(A, /mob/living))
		return

	var/mob/living/M = A

	if(M.stat != DEAD)
		if(M.HasMovementHandler(/datum/movement_handler/mob/transformation))
			return
		if(M.has_brain_worms())
			return //Borer stuff - RR

		if(iscultist(M)) return
		if(!ishuman(M) && !isrobot(M)) return

		M.AddMovementHandler(/datum/movement_handler/mob/transformation)
		M.icon = null
		M.overlays.len = 0
		M.set_invisibility(101)

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/Robot = M
			if(Robot.mmi)
				qdel(Robot.mmi)
		else
			for(var/obj/item/W in M)
				M.drop_from_inventory(W)
				if(istype(W, /obj/item/implant))
					qdel(W)

		var/mob/living/new_mob = new /mob/living/simple_animal/passive/corgi(A.loc)
		new_mob.a_intent = I_HURT
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key

		to_chat(new_mob, "<B>Your form morphs into that of a corgi.</B>")//Because we don't have cluwnes
