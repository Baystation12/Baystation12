/obj/item/weapon/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	flags = TABLEPASS|OPENCONTAINER|FPRINT|USEDELAY
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	volume = 250
	possible_transfer_amounts = null


/obj/item/weapon/reagent_containers/spray/afterattack(atom/A as mob|obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/rack) || istype(A, /obj/structure/closet) \
	|| istype(A, /obj/item/weapon/reagent_containers) || istype(A, /obj/structure/sink))
		return

	if(istype(A, /obj/effect/proc_holder/spell))
		return

	if(istype(A, /obj/structure/reagent_dispensers) && get_dist(src,A) <= 1) //this block copypasted from reagent_containers/glass, for lack of a better solution
		if(!A.reagents.total_volume && A.reagents)
			user << "<span class='notice'>\The [A] is empty.</span>"
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			user << "<span class='notice'>\The [src] is full.</span>"
			return

		var/trans = A.reagents.trans_to(src, A:amount_per_transfer_from_this)
		user << "<span class='notice'>You fill \the [src] with [trans] units of the contents of \the [A].</span>"
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		user << "<span class='notice'>\The [src] is empty!</span>"
		return

	var/obj/effect/decal/D = new/obj/effect/decal(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(D, amount_per_transfer_from_this, 1/3)

	D.name = "chemicals"
	D.icon = 'icons/obj/chempuff.dmi'

	D.icon += mix_color_from_reagents(D.reagents.reagent_list)

	var/turf/A_turf = get_turf(A)

	spawn(0)
		for(var/i=0, i<3, i++)
			step_towards(D,A)
			D.reagents.reaction(get_turf(D))
			for(var/atom/T in get_turf(D))
				D.reagents.reaction(T)

				// When spraying against the wall, also react with the wall, but
				// not its contents.
				if(get_dist(D, A_turf) == 1 && A_turf.density)
					D.reagents.reaction(A_turf)
				sleep(2)
			sleep(3)
		del(D)

	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)

	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from a spray bottle.")
		log_game("[key_name(user)] fired sulphuric acid from a spray bottle.")
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from a spray bottle.")
		log_game("[key_name(user)] fired Polyacid from a spray bottle.")
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from a spray bottle.")
		log_game("[key_name(user)] fired Space lube from a spray bottle.")
	return

/obj/item/weapon/reagent_containers/spray/attack_self(var/mob/user)

	amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
	user << "<span class='notice'>You switched [amount_per_transfer_from_this == 10 ? "on" : "off"] the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>"


/obj/item/weapon/reagent_containers/spray/examine()
	set src in usr
	..()
	usr << "[round(src.reagents.total_volume)] units left."
	return

/obj/item/weapon/reagent_containers/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if(isturf(usr.loc))
		usr << "<span class='notice'>You empty the [src] onto the floor.</span>"
		reagents.reaction(usr.loc)
		spawn(5) src.reagents.clear_reagents()

//space cleaner
/obj/item/weapon/reagent_containers/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"


/obj/item/weapon/reagent_containers/spray/cleaner/New()
	..()
	reagents.add_reagent("cleaner", 250)

//pepperspray
/obj/item/weapon/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	volume = 40
	amount_per_transfer_from_this = 10


/obj/item/weapon/reagent_containers/spray/pepper/New()
	..()
	reagents.add_reagent("condensedcapsaicin", 40)


//chemsprayer
/obj/item/weapon/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/gun.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throwforce = 3
	w_class = 3.0
	volume = 600
	origin_tech = "combat=3;materials=3;engineering=3"


//this is a big copypasta clusterfuck, but it's still better than it used to be!
/obj/item/weapon/reagent_containers/spray/chemsprayer/afterattack(atom/A as mob|obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/rack) || istype(A, /obj/structure/closet) \
	|| istype(A, /obj/item/weapon/reagent_containers) || istype(A, /obj/structure/sink))
		return

	if(istype(A, /obj/effect/proc_holder/spell))
		return

	if(istype(A, /obj/structure/reagent_dispensers) && get_dist(src,A) <= 1) //this block copypasted from reagent_containers/glass, for lack of a better solution
		if(!A.reagents.total_volume && A.reagents)
			user << "<span class='notice'>\The [A] is empty.</span>"
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			user << "<span class='notice'>\The [src] is full.</span>"
			return

		var/trans = A.reagents.trans_to(src, A:amount_per_transfer_from_this)
		user << "<span class='notice'>You fill \the [src] with [trans] units of the contents of \the [A].</span>"
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		user << "<span class='notice'>\The [src] is empty!</span>"
		return

	var/Sprays[3]
	for(var/i=1, i<=3, i++) // intialize sprays
		if(src.reagents.total_volume < 1) break
		var/obj/effect/decal/D = new/obj/effect/decal(get_turf(src))
		D.name = "chemicals"
		D.icon = 'icons/obj/chempuff.dmi'
		D.create_reagents(amount_per_transfer_from_this)
		src.reagents.trans_to(D, amount_per_transfer_from_this)

		D.icon += mix_color_from_reagents(D.reagents.reagent_list)

		Sprays[i] = D

	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)

	for(var/i=1, i<=Sprays.len, i++)
		spawn()
			var/obj/effect/decal/D = Sprays[i]
			if(!D) continue

			// Spreads the sprays a little bit
			var/turf/my_target = pick(the_targets)
			the_targets -= my_target

			for(var/j=1, j<=rand(6,8), j++)
				step_towards(D, my_target)
				D.reagents.reaction(get_turf(D))
				for(var/atom/t in get_turf(D))
					D.reagents.reaction(t)
				sleep(2)
			del(D)

	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)

	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from a chem sprayer.")
		log_game("[key_name(user)] fired sulphuric acid from a chem sprayer.")
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from a chem sprayer.")
		log_game("[key_name(user)] fired Polyacid from a chem sprayer.")
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from a chem sprayer.")
		log_game("[key_name(user)] fired Space lube from a chem sprayer.")
	return

// Plant-B-Gone
/obj/item/weapon/reagent_containers/spray/plantbgone // -- Skie
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100


/obj/item/weapon/reagent_containers/spray/plantbgone/New()
	..()
	reagents.add_reagent("plantbgone", 100)


/obj/item/weapon/reagent_containers/spray/plantbgone/afterattack(atom/A as mob|obj, mob/user as mob)
	if (istype(A, /obj/machinery/hydroponics)) // We are targeting hydrotray
		return

	if (istype(A, /obj/effect/blob)) // blob damage in blob code
		return

	..()
