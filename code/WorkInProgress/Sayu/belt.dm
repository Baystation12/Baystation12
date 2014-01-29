// -------------------------------------
//     Bluespace Belt
// -------------------------------------


/obj/item/weapon/storage/belt/bluespace
	name = "Belt of Holding"
	desc = "The greatest in pants-supporting technology."
	icon_state = "medicalbelt"
	item_state = "medical"
	storage_slots = 14
	w_class = 4
	max_w_class = 2
	max_combined_w_class = 21 // = 14 * 1.5, not 14 * 2.  This is deliberate
	origin_tech = "bluespace=4"
	can_hold = list()
	New()
		if(prob(5))
			//Sometimes people choose justice.
			//Sometimes justice chooses you.
			visible_message("That doesn't look like a normal Toolbelt of Holding...")
			new /obj/item/weapon/storage/belt/bluespace/owlman(loc)
			spawn(1)
				del src
			return
		..()

	proc/failcheck(mob/user as mob)
		if (prob(src.reliability)) return 1 //No failure
		if (prob(src.reliability))
			user << "\red The Bluespace portal resists your attempt to add another item." //light failure
		else
			user << "\red The Bluespace generator malfunctions!"
			for (var/obj/O in src.contents) //it broke, delete what was in it
				del(O)
			crit_fail = 1
			return 0

/obj/item/weapon/storage/belt/bluespace/owlman
	name = "Owlman's utility belt"
	desc = "Sometimes people choose justice.  Sometimes, justice chooses you..."
	icon_state = "securitybelt"
	item_state = "security"
	storage_slots = 14
	max_w_class = 3
	max_combined_w_class = 28 // = 14 * 2
	origin_tech = "bluespace=4;syndicate=2"
	allow_quick_empty = 1
	can_hold = list()
	New()
		..()
		new /obj/item/clothing/mask/gas/owl_mask(src)
		new /obj/item/clothing/under/owl(src)
		new /obj/item/weapon/grenade/smokebomb(src)
		new /obj/item/weapon/grenade/smokebomb(src)
		new /obj/item/device/detective_scanner(src)



 // As a last resort, the belt can be used as a plastic explosive with a fixed timer (15 seconds).  Naturally, you'll lose all your gear...
 // Of course, it could be worse.  It could spawn a singularity!
/obj/item/weapon/storage/belt/bluespace/owlman/afterattack(atom/target as obj|turf, mob/user as mob, flag)
	if (!flag)
		return
	if (istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/weapon/storage) || istype(target, /obj/structure/table) || istype(target, /obj/structure/closet))
		return
	user << "Planting explosives..."
	user.visible_message("[user.name] is fiddling with their toolbelt.")
	if(ismob(target))
		user.attack_log += "\[[time_stamp()]\] <font color='red'> [user.real_name] tried planting [name] on [target:real_name] ([target:ckey])</font>"
		log_attack("<font color='red'> [user.real_name] ([user.ckey]) tried planting [name] on [target:real_name] ([target:ckey])</font>")
		user.visible_message("\red [user.name] is trying to strap a belt to [target.name]!")


	if(do_after(user, 50) && in_range(user, target))
		user.drop_item()
		target = target
		loc = null
		var/location
		if (isturf(target)) location = target
		if (ismob(target))
			target:attack_log += "\[[time_stamp()]\]<font color='orange'> Had the [name] planted on them by [user.real_name] ([user.ckey])</font>"
			user.visible_message("\red [user.name] finished planting an explosive on [target.name]!")
		target.overlays += image('icons/obj/assemblies.dmi', "plastic-explosive2")
		user << "You sacrifice your belt for the sake of justice. Timer counting down from 15."
		spawn(150)
			if(target)
				if(ismob(target) || isobj(target))
					location = target.loc // These things can move
				explosion(location, -1, -1, 2, 3)
				if (istype(target, /turf/simulated/wall)) target:dismantle_wall(1)
				else target.ex_act(1)
				if (isobj(target))
					if (target)
						del(target)
				if (src)
					del(src)
/obj/item/weapon/storage/belt/bluespace/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/weapon/storage/belt/bluespace/admin
	name = "Admin's Tool-belt"
	desc = "Holds everything for those that run everything."
	icon_state = "soulstonebelt"
	item_state = "soulstonebelt"
	w_class = 10 // permit holding other storage items
	storage_slots = 28
	max_w_class = 10
	max_combined_w_class = 280
	can_hold = list()

	New()
		..()
		new /obj/item/weapon/crowbar(src)
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/weldingtool/hugetank(src)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/device/multitool(src)
		new /obj/item/stack/cable_coil(src)

		new /obj/item/weapon/handcuffs(src)
		new /obj/item/weapon/dnainjector/xraymut(src)
		new /obj/item/weapon/dnainjector/firemut(src)
		new /obj/item/weapon/dnainjector/telemut(src)
		new /obj/item/weapon/dnainjector/hulkmut(src)
//		new /obj/item/weapon/spellbook(src) // for smoke effects, door openings, etc
//		new /obj/item/weapon/magic/spellbook(src)

//		new/obj/item/weapon/reagent_containers/hypospray/admin(src)

/obj/item/weapon/storage/belt/bluespace/sandbox
	name = "Sandbox Mode Toolbelt"
	desc = "Holds whatever, you can spawn your own damn stuff."
	w_class = 10 // permit holding other storage items
	storage_slots = 28
	max_w_class = 10
	max_combined_w_class = 280
	can_hold = list()

	New()
		..()
		new /obj/item/weapon/crowbar(src)
		new /obj/item/weapon/screwdriver(src)
		new /obj/item/weapon/weldingtool/hugetank(src)
		new /obj/item/weapon/wirecutters(src)
		new /obj/item/weapon/wrench(src)
		new /obj/item/device/multitool(src)
		new /obj/item/stack/cable_coil(src)

		new /obj/item/device/analyzer(src)
		new /obj/item/device/healthanalyzer(src)


//Research for the Bluespace Belt
datum/design/bluespace_belt
	name = "Experimental Bluespace Belt"
	desc = "An astonishingly complex belt popularized by a rich blue-space technology magnate."
	id = "bluespace_belt"
	req_tech = list("bluespace" = 4, "materials" = 6)
	build_type = PROTOLATHE
	materials = list("$gold" = 1500, "$diamond" = 3000, "$uranium" = 1000)
	reliability_base = 80
	build_path = "/obj/item/weapon/storage/belt/bluespace"