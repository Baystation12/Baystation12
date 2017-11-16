/turf/simulated/floor/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C, /obj/item/stack/cable_coil) || (flooring && istype(C, /obj/item/stack/rods)))
		return ..(C, user)

	if(flooring)
		if(iscrowbar(C))
			if(broken || burnt)
				to_chat(user, "<span class='notice'>You remove the broken [flooring.descriptor].</span>")
				make_plating()
			else if(flooring.flags & TURF_IS_FRAGILE)
				to_chat(user, "<span class='danger'>You forcefully pry off the [flooring.descriptor], destroying them in the process.</span>")
				make_plating()
			else if(flooring.flags & TURF_REMOVE_CROWBAR)
				to_chat(user, "<span class='notice'>You lever off the [flooring.descriptor].</span>")
				make_plating(1)
			else
				return
			playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/screwdriver) && (flooring.flags & TURF_REMOVE_SCREWDRIVER))
			if(broken || burnt)
				return
			to_chat(user, "<span class='notice'>You unscrew and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Screwdriver.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/wrench) && (flooring.flags & TURF_REMOVE_WRENCH))
			to_chat(user, "<span class='notice'>You unwrench and remove the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/weapon/shovel) && (flooring.flags & TURF_REMOVE_SHOVEL))
			to_chat(user, "<span class='notice'>You shovel off the [flooring.descriptor].</span>")
			make_plating(1)
			playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
			return
		else if(istype(C, /obj/item/stack/cable_coil))
			to_chat(user, "<span class='warning'>You must remove the [flooring.descriptor] first.</span>")
			return
	else

		if(istype(C, /obj/item/stack))
			if(broken || burnt)
				to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
				return
			//first check, catwalk? Else let flooring do its thing
			if(locate(/obj/structure/catwalk, src))
				return
			if (istype(C, /obj/item/stack/rods))
				var/obj/item/stack/rods/R = C
				if (R.use(2))
					to_chat(user, "<span class='notice'>You lay down the catwalk.</span>")
					playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
					new /obj/structure/catwalk(locate(src.x, src.y, src.z))
				return
			var/obj/item/stack/S = C
			var/decl/flooring/use_flooring
			for(var/flooring_type in flooring_types)
				var/decl/flooring/F = flooring_types[flooring_type]
				if(!F.build_type)
					continue
				if(ispath(S.type, F.build_type) || ispath(S.build_type, F.build_type))
					use_flooring = F
					break
			if(!use_flooring)
				return
			// Do we have enough?
			if(use_flooring.build_cost && S.get_amount() < use_flooring.build_cost)
				to_chat(user, "<span class='warning'>You require at least [use_flooring.build_cost] [S.name] to complete the [use_flooring.descriptor].</span>")
				return
			// Stay still and focus...
			if(use_flooring.build_time && !do_after(user, use_flooring.build_time, src))
				return
			if(flooring || !S || !user || !use_flooring)
				return
			if(S.use(use_flooring.build_cost))
				set_flooring(use_flooring)
				playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
				return
		// Repairs and Deconstruction.
		else if(iscrowbar(C))
			if(broken || burnt)
				playsound(src, 'sound/items/Crowbar.ogg', 80, 1)
				visible_message("<span class='notice'>[user] has begun prying off the damaged plating.</span>")
				var/turf/T = GetBelow(src)
				if(T)
					T.visible_message("<span class='warning'>The ceiling above looks as if it's being pried off.</span>")
				if(do_after(user, 10 SECONDS))
					visible_message("<span class='warning'>[user] has pried off the damaged plating.</span>")
					new /obj/item/stack/tile/floor(src)
					src.ReplaceWithLattice()
					playsound(src, 'sound/items/Deconstruct.ogg', 80, 1)
					if(T)
						T.visible_message("<span class='danger'>The ceiling above has been pried off!</span>")
			else
				return
			return
		else if(istype(C, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/welder = C
			if(welder.isOn() && (is_plating()))
				if(broken || burnt)
					if(welder.isOn())
						to_chat(user, "<span class='notice'>You fix some dents on the broken plating.</span>")
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						icon_state = "plating"
						burnt = null
						broken = null
					else
						to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
					return
				else
					if(welder.isOn())
						playsound(src, 'sound/items/Welder.ogg', 80, 1)
						visible_message("<span class='notice'>[user] has started melting the plating's reinforcements!</span>")
						if(do_after(user, 5 SECONDS) && welder.isOn())
							visible_message("<span class='warning'>[user] has melted the plating's reinforcements! It should be possible to pry it off.</span>")
							playsound(src, 'sound/items/Welder.ogg', 80, 1)
							burnt = 1
							remove_decals()
							update_icon()
					else
						to_chat(user, "<span class='warning'>You need more welding fuel to complete this task.</span>")
					return


	return ..()


/turf/simulated/floor/can_build_cable(var/mob/user)
	if(!is_plating() || flooring)
		to_chat(user, "<span class='warning'>Removing the tiling first.</span>")
		return 0
	if(broken || burnt)
		to_chat(user, "<span class='warning'>This section is too damaged to support anything. Use a welder to fix the damage.</span>")
		return 0
	return 1
