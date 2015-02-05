//Grown foods.
/obj/item/weapon/reagent_containers/food/snacks/grown

	name = "fruit"
	//icon = 'icons/obj/harvest.dmi' //Todo convert to greyscale
	icon = 'icons/obj/hydroponics_products.dmi'
	desc = "The product of some kind of plant." //Todo store descs for retrieval.

	var/plantname
	var/datum/seed/seed
	var/potency = -1

/obj/item/weapon/reagent_containers/food/snacks/grown/New(newloc,planttype)

	..()

	src.pixel_x = rand(-5.0, 5)
	src.pixel_y = rand(-5.0, 5)

	// Fill the object up with the appropriate reagents.
	if(planttype)
		plantname = planttype

	if(!plantname)
		return

	if(!plant_controller)
		sleep(250) // ugly hack, should mean roundstart plants are fine.
	if(!plant_controller)
		world << "<span class='danger'>Plant controller does not exist and [src] requires it. Aborting.</span>"
		del(src)
		return

	seed = plant_controller.seeds[plantname]

	if(!seed)
		return

	name = "[seed.seed_name]"
	icon_state = "[seed.get_trait(TRAIT_PRODUCT_ICON)]"
	color = "[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"

	if(!seed.chems)
		return

	potency = seed.get_trait(TRAIT_POTENCY)

	for(var/rid in seed.chems)
		var/list/reagent_data = seed.chems[rid]
		var/rtotal = reagent_data[1]
		if(reagent_data.len > 1 && potency > 0)
			rtotal += round(potency/reagent_data[2])
		reagents.add_reagent(rid,max(1,rtotal))

	if(reagents.total_volume > 0)
		bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/Crossed(var/mob/living/M)
	if(seed && seed.get_trait(TRAIT_JUICY) == 2)
		if(istype(M))

			if(M.buckled)
				return

			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.shoes && H.shoes.flags & NOSLIP)
					return

			M.stop_pulling()
			M << "<span class='notice'>You slipped on the [name]!</span>"
			playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
			M.Stun(8)
			M.Weaken(5)
			seed.thrown_at(src,M)
			sleep(-1)
			if(src) del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/grown/throw_impact(atom/hit_atom)
	..()
	if(seed) seed.thrown_at(src,hit_atom)

/obj/item/weapon/reagent_containers/food/snacks/grown/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(seed && seed.get_trait(TRAIT_PRODUCES_POWER) && istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(C.use(5))
			//TODO: generalize this.
			user << "<span class='notice'>You add some cable to the [src.name] and slide it inside the battery casing.</span>"
			var/obj/item/weapon/cell/potato/pocell = new /obj/item/weapon/cell/potato(get_turf(user))
			if(src.loc == user && !(user.l_hand && user.r_hand) && istype(user,/mob/living/carbon/human))
				user.put_in_hands(pocell)
			pocell.maxcharge = src.potency * 10
			pocell.charge = pocell.maxcharge
			del(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/grown/attack(var/mob/living/carbon/M, var/mob/user, var/def_zone)
	if(user == M)
		return ..()

	if(user.a_intent == "hurt")

		// This is being copypasted here because reagent_containers (WHY DOES FOOD DESCEND FROM THAT) overrides it completely.
		// TODO: refactor all food paths to be less horrible and difficult to work with in this respect. ~Z
		if(!istype(M) || (can_operate(M) && do_surgery(M,user,src))) return 0

		user.lastattacked = M
		M.lastattacker = user
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])" )

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			var/hit = H.attacked_by(src, user, def_zone)
			if(hit && hitsound)
				playsound(loc, hitsound, 50, 1, -1)
			return hit
		else
			if(attack_verb.len)
				user.visible_message("<span class='danger'>[M] has been [pick(attack_verb)] with [src] by [user]!</span>")
			else
				user.visible_message("<span class='danger'>[M] has been attacked with [src] by [user]!</span>")

			if (hitsound)
				playsound(loc, hitsound, 50, 1, -1)
			switch(damtype)
				if("brute")
					M.take_organ_damage(force)
					if(prob(33))
						var/turf/simulated/location = get_turf(M)
						if(istype(location)) location.add_blood_floor(M)
				if("fire")
					if (!(COLD_RESISTANCE in M.mutations))
						M.take_organ_damage(0, force)
			M.updatehealth()

		if(seed && seed.get_trait(TRAIT_STINGS))
			if(!reagents || reagents.total_volume <= 0)
				return
			reagents.remove_any(rand(1,3))
			seed.thrown_at(src,M)
			sleep(-1)
			if(!src)
				return
			if(prob(35))
				if(user)
					user << "<span class='danger'>\The [src] has fallen to bits.</span>"
					user.drop_from_inventory(src)
				del(src)

		add_fingerprint(user)
		return 1

	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/grown/attack_self(mob/user as mob)

	if(!seed)
		return

	if(istype(user.loc,/turf/space))
		return

	if(user.a_intent == "hurt")
		user.visible_message("<span class='danger'>\The [user] squashes \the [src]!</span>")
		seed.thrown_at(src,user)
		sleep(-1)
		if(src) del(src)
		return

	if(seed.get_trait(TRAIT_SPREAD) == 0)
		return

	user << "<span class='notice'>You plant the [src.name].</span>"
	new /obj/machinery/portable_atmospherics/hydroponics/soil/invisible(get_turf(user),src.seed)
	del(src)

/obj/item/weapon/reagent_containers/food/snacks/grown/pickup(mob/user)
	..()
	if(!seed)
		return
	if(seed.get_trait(TRAIT_BIOLUM))
		user.SetLuminosity(user.luminosity + seed.get_trait(TRAIT_BIOLUM))
		SetLuminosity(0)
	if(seed.get_trait(TRAIT_STINGS))
		var/mob/living/carbon/human/H = user
		if(istype(H) && H.gloves)
			return
		if(!reagents || reagents.total_volume <= 0)
			return
		reagents.remove_any(rand(1,3)) //Todo, make it actually remove the reagents the seed uses.
		seed.do_thorns(H,src)
		seed.do_sting(H,src,pick("r_hand","l_hand"))

/obj/item/weapon/reagent_containers/food/snacks/grown/dropped(mob/user)
	if(!..() || !seed)
		return
	if(seed.get_trait(TRAIT_BIOLUM))
		user.SetLuminosity(user.luminosity - seed.get_trait(TRAIT_BIOLUM))
		SetLuminosity(seed.get_trait(TRAIT_BIOLUM))

// Predefined types for placing on the map.

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/libertycap
	plantname = "libertycap"

/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris
	plantname = "ambrosia"
