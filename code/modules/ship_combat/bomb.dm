/obj/machinery/missile/bomb/fire_missile(var/turf/location)
	var/obj/machinery/space_battle/tube/T = locate() in loc
	if(T && T.computer)
		if(T.computer.firing_angle == "Flanking" || (prob(30) && T.computer.firing_angle != "Carefully Aimed"))
			var/area/A = get_area(location)
			location = pick_area_turf(A)
	var/obj/item/missile/ship/projectile = new spawn_type(location)
	spawn(1)
		projectile.boom()
	qdel(src)
	return 1


/obj/item/missile/ship/bomb
	name = "bomb"
	desc = "A bomb!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "bomb"
	var/det_time = 10

	boom()
		spawn(det_time)
			explosion(src, 0, 0, rand(1,2), 4)
			qdel(src)

/obj/machinery/missile/bomb
	name = "bomb"
	desc = "A self-teleporting bomb!"
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "bomb"
	width = 1
	req_grabs = 1
	spawn_type = /obj/item/missile/ship/bomb

/obj/item/missile/ship/bomb/emp
	name = "electrical bomb"
	desc = "A bomb!"
	icon_state = "bomb"
	det_time = 30

	boom()
		spawn(det_time)
			empulse(get_turf(src), rand(1,2), rand(3,7))
			qdel(src)

/obj/machinery/missile/bomb/emp
	name = "emp bomb"
	desc = "A self-teleporting emp bomb!"
	req_grabs = 1
	spawn_type = /obj/item/missile/ship/bomb/emp

/obj/item/weapon/grenade/chem_grenade/large/necrosis
	name = "necrotic grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/bluespace/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/bluespace/B2 = new(src)

		B1.reagents.add_reagent("necrosa", 200)
		B1.reagents.add_reagent("sugar", 100)
		B2.reagents.add_reagent("potassium", 100)
		B2.reagents.add_reagent("chloralhydrate",50)
		B2.reagents.add_reagent("impedrezene",50)
		B2.reagents.add_reagent("phosphorus",100)


		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"

/obj/item/missile/ship/bomb/chem
	name = "chemical bomb"
	var/obj/item/weapon/grenade/chem_grenade/explosive

/obj/item/missile/ship/bomb/chem/boom()
	explosive = new (get_turf(src))
	spawn(0)
		explosive.activate()
		explosive = null
	qdel(src)

/obj/item/missile/ship/bomb/chem/necrosis
	name = "necrosis bomb"

/obj/item/missile/ship/bomb/chem/necrosis/boom()
	explosive = new /obj/item/weapon/grenade/chem_grenade/large/necrosis (get_turf(src))
	spawn(50)
		explosive.activate()
		explosive = null
	qdel(src)

/obj/machinery/missile/bomb/necrosis
	name = "necrosis bomb"
	desc = "A self-teleporting necrosis bomb!"
	req_grabs = 1
	spawn_type = /obj/item/missile/ship/bomb/chem/necrosis

/obj/item/weapon/grenade/chem_grenade/battle_incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2

/obj/item/weapon/grenade/chem_grenade/battle_incendiary/New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 8)
		B1.reagents.add_reagent("fuel",10)
		B2.reagents.add_reagent("phoron", 8)
		B2.reagents.add_reagent("sacid", 8)
		B1.reagents.add_reagent("fuel",10)

		detonator = new/obj/item/device/assembly_holder/timer_igniter(src)

		beakers += B1
		beakers += B2
		icon_state = initial(icon_state) +"_locked"

/obj/item/missile/ship/bomb/chem/incendiary
	name = "incendiary bomb"

/obj/item/missile/ship/bomb/chem/incendiary/boom()
	explosive = new /obj/item/weapon/grenade/chem_grenade/battle_incendiary (get_turf(src))
	spawn(0)
		explosive.activate()
		explosive = null
	qdel(src)

/obj/machinery/missile/bomb/incendiary
	name = "incendiary bomb"
	desc = "A self-teleporting incendiary bomb!"
	req_grabs = 1
	spawn_type = /obj/item/missile/ship/bomb/chem/incendiary

/obj/item/missile/ship/bomb/grav
	name = "gravity bomb"
	var/list/affected = list()
	var/count = 5

	New()
		..()
		boom()

/obj/item/missile/ship/bomb/grav/boom()
	spawn(25)
		src.visible_message("<span class='warning'>\The [src] pulses!</span>")
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, 1)
		for(var/atom/movable/A in view(5))
			if(istype(A, /obj))
				var/obj/O = A
				var/turf/T = get_turf(O)
				if(T)
					var/mob/living/carbon/human/H = locate() in T
					if(H && istype(H))
						if(O in H.contents)
							if((istype(O, /obj/item/clothing) || istype(O, /obj/item/weapon/card)) && prob(10))
								H.remove_from_mob(O)
								affected += O
								H << "<span class='warning'>You feel your [O] rip and fly off of you!</span>"
							continue
					else
						var/mob/M = locate() in T
						if(O in M)
							continue
				if(!O.anchored)
					affected += O
				else if(prob(1) && !istype(O, /obj/machinery))
					O.anchored = 0
					O.visible_message("<span class='danger'>\The [O]'s bolts screech as they're torn and stretched!</span>")
					affected += O
			else if(istype(A, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = A
				if(!H.lying)
					H << "<span class='danger'>A strong gravitational force slams you to the ground!</span>"
					H.Weaken(20)
					affected += H
		count += rand(5,30)
		processing_objects.Add(src)

/obj/item/missile/ship/bomb/grav/process()
	if(count)
		pull_objects()
		count--
	else
		var/list/turfs = list()
		for(var/turf/T in view(7))
			if(T.density)
				turfs += T
		if(!turfs.len)
			turfs += get_turf(src)
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, 1)
		for(var/atom/movable/A in affected)
			if(istype(A, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = A
				H.Weaken(10)
				H.apply_damage(rand(1,20), BRUTE, null, 0, 0, 0, "Heavy Impact")
			A.throw_at(pick(turfs), 90, 2, src)
		spawn(0)
			affected.Cut()
			processing_objects.Remove(src)
			qdel(src)

/obj/item/missile/ship/bomb/grav/proc/pull_objects()
	for(var/atom/movable/A in affected)
		A.singularity_pull(src, STAGE_THREE)
		sleep(0)

/obj/item/missile/ship/bomb/grav/Destroy()
	affected.Cut()
	return ..()

/obj/machinery/missile/bomb/grav
	name = "grav bomb"
	desc = "A self-teleporting gravity bomb!"
	req_grabs = 1
	spawn_type = /obj/item/missile/ship/bomb/grav

/obj/machinery/missile/bomb/plant
	name = "vine bomb"
	desc = "An invasive plant species is embedded inside!"
	spawn_type = /obj/item/missile/ship/bomb/plant

/obj/item/missile/ship/bomb/plant
	name = "vine bomb"
	desc = "A bomb!"
	icon_state = "bomb"
	det_time = 20

	New()
		..()
		var/turf/T = get_turf(src)
		if(T)
			var/datum/seed/seed = plant_controller.create_random_seed(1)
			seed.set_trait(TRAIT_SPREAD,2)             // So it will function properly as vines.
			seed.set_trait(TRAIT_POTENCY,rand(1,70)) // 70-100 potency will help guarantee a wide spread and powerful effects.
			seed.set_trait(TRAIT_MATURATION,rand(1, 5))
			var/ptype = 0 // So we can guarantee atleast one dangerous effect
			if(prob(10))
				var/consume_oxy = 0
				ptype = 1
				if(prob(50))
					consume_oxy = 1
					seed.consume_gasses = list()
					seed.consume_gasses["oxygen"] = rand(5,12)
				if(prob(50) || !consume_oxy)
					seed.exude_gasses = list()
					seed.exude_gasses["carbon_dioxide"] = rand(5,12)
			if(prob(10) || !ptype)
				ptype = 1
				var/additional_chems = rand(1,3)

				if(additional_chems)
					var/list/possible_chems = list(
						"hyperzine",
						"blood",
						"zombiepowder",
						"plasticide",
						"space_drugs",
						"paroxetine",
						"mercury",
						"radium",
						"thermite",
						"tramadol",
						"cryptobiolin",
						"phoron",
						"condensedcapsaicin",
						"impedrezene",
						"toxin",
						"cyanide",
						"mindbreaker",
						"stoxin",
				)

					for(var/x=1;x<=additional_chems;x++)
						if(!possible_chems.len)
							break
						var/new_chem = pick(possible_chems)
						possible_chems -= new_chem
						seed.chems[new_chem] = list(rand(3,15),rand(15,30))

				seed.set_trait(TRAIT_STINGS,1)
			if(prob(10) || !ptype)
				ptype = 1
				var/carnivorous = 0
				if(prob(50))
					seed.set_trait(TRAIT_CARNIVOROUS,rand(1,2))
					carnivorous = 1
				if(prob(50) || !carnivorous)
					seed.set_trait(TRAIT_BIOLUM,1)
					seed.set_trait(TRAIT_BIOLUM_COLOUR,get_random_colour(0,75,190))

			if(prob(10) || !ptype)
				ptype = 1
				seed.set_trait(TRAIT_ALTER_TEMP,rand(-10,10))
				seed.set_trait(TRAIT_HEAT_TOLERANCE,   rand(30,125))

			//make vine zero start off fully matured
			var/obj/effect/plant/vine = new(T,seed)
			vine.health = vine.max_health
			vine.mature_time = 0
			vine.process()

			log_and_message_admins("Spacevines spawned at \the [get_area(T)]", location = T)
			qdel(src)
			return

	boom()
		return 0

