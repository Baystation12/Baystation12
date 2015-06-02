//Food items that are eaten normally and don't leave anything behind.
/obj/item/weapon/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon_state = null
	var/bitesize = 2
	var/bitecount = 0
	var/slices_to
	var/slice_count
	var/dried_type = null
	var/dry = 0
	center_of_mass = list("x"=15, "y"=15)
	w_class = 2
	bitesize = 2

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/weapon/reagent_containers/food/snacks/proc/On_Consume(var/mob/M)
	if(!usr)
		return 0
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>\The [M] finishes eating \the [src].</span>")
		spawn(1)
			M.drop_from_inventory(src)
			qdel(src)
		return 1
	return

/obj/item/weapon/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/snacks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(!reagents.total_volume)
		user << "<span class='danger'>There's none of \the [src] left!</span>"
		user.drop_from_inventory(src)
		qdel(src)
		return 0

	if(istype(M, /mob/living/carbon))
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(M == user)								//If you're eating it yourself
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					user << "Where do you intend to put \the [src]? You don't have a mouth!"
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					user << "<span class='warning'>\The [blocked] is in the way!</span>"
					return

			if (fullness <= 50)
				M << "<span class='danger'>You hungrily chew out a piece of [src] and gobble it!</span>"
			if (fullness > 50 && fullness <= 150)
				M << "<span class='notice'>You hungrily begin to eat [src].</span>"
			if (fullness > 150 && fullness <= 350)
				M << "<span class='notice'>You take a bite of [src].</span>"
			if (fullness > 350 && fullness <= 550)
				M << "<span class='notice'>You unwillingly chew a bit of [src].</span>"
			if (fullness > (550 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				M << "<span class='danger'>You cannot force any more of [src] to go down your throat.</span>"
				return 0
		else
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(!H.check_has_mouth())
					user << "Where do you intend to put \the [src]? \The [H] doesn't have a mouth!"
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					user << "<span class='warning'>\The [blocked] is in the way!</span>"
					return

			if(!istype(M, /mob/living/carbon/slime))		//If you're feeding it to someone else.

				if (fullness <= (550 * (1 + M.overeatduration / 1000)))
					user.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>")
				else
					user.visible_message("<span class='danger'>[user] cannot force anymore of [src] down [M]'s throat.</span>")
					return 0

				if(!do_mob(user, M)) return

				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
				msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)])")

				user.visible_message("<span class='danger'>[user] feeds [M] [src].</span>")

			else
				user << "This creature does not seem to have a mouth!"
				return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(reagents.total_volume)
				if(reagents.total_volume > bitesize)
					reagents.trans_to_mob(M, bitesize, CHEM_INGEST)
				else
					reagents.trans_to_mob(M, reagents.total_volume, CHEM_INGEST)
				bitecount++
				On_Consume(M)
			return 1

	return 0

/obj/item/weapon/reagent_containers/food/snacks/examine(mob/user)
	if(!..(user, 1))
		return
	if (bitecount==0)
		return
	else if (bitecount==1)
		user << "\blue \The [src] was bitten by someone!"
	else if (bitecount<=3)
		user << "\blue \The [src] was bitten [bitecount] times!"
	else
		user << "\blue \The [src] was bitten multiple times!"

/obj/item/weapon/reagent_containers/food/snacks/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/storage))
		..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(W,/obj/item/weapon/material/kitchen/utensil))
		var/obj/item/weapon/material/kitchen/utensil/U = W

		if(!U.reagents)
			U.create_reagents(5)

		if (U.reagents.total_volume > 0)
			user << "\red You already have something on your [U]."
			return

		user.visible_message( \
			"[user] scoops up some [src] with \the [U]!", \
			"\blue You scoop up some [src] with \the [U]!" \
		)

		src.bitecount++
		U.overlays.Cut()
		U.loaded = "[src]"
		var/image/I = new(U.icon, "loadedfood")
		I.color = src.filling_color
		U.overlays += I

		reagents.trans_to_obj(U, min(reagents.total_volume,5))

		if (reagents.total_volume <= 0)
			qdel(src)
		return

/obj/item/weapon/reagent_containers/food/snacks/proc/is_sliceable()
	return (slice_count && slices_to)

/obj/item/weapon/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.loc = get_turf(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/attack_generic(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message("<b>[user]</b> nibbles away at \the [src].","You nibble away at \the [src].")
	bitecount++
	if(reagents && user.reagents)
		reagents.trans_to_mob(user, bitesize, CHEM_INGEST)
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	On_Consume(user)
