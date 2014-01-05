/*/obj/item/weapon/gun/projectile/shotgun/pump
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	max_shells = 4
	w_class = 4.0
	force = 10
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = "combat=4;materials=2"
	ammo_type = "/obj/item/ammo_casing/shotgun/beanbag"
	var/recentpump = 0 // to prevent spammage
	var/pumped = 0
	var/obj/item/ammo_casing/current_shell = null

	isHandgun()
		return 0

	load_into_chamber()
		if(in_chamber)
			return 1
		return 0


	attack_self(mob/living/user as mob)
		if(recentpump)	return
		pump()
		recentpump = 1
		spawn(10)
			recentpump = 0
		return


	proc/pump(mob/M as mob)
		playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
		pumped = 0
		if(current_shell)//We have a shell in the chamber
			current_shell.loc = get_turf(src)//Eject casing
			current_shell = null
			if(in_chamber)
				in_chamber = null
		if(!loaded.len)	return 0
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		current_shell = AC
		if(AC.BB)
			in_chamber = AC.BB //Load projectile into chamber.
		update_icon()	//I.E. fix the desc
		return 1

/obj/item/weapon/gun/projectile/shotgun/pump/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	max_shells = 8
	origin_tech = "combat=5;materials=2"
	ammo_type = "/obj/item/ammo_casing/shotgun"

//this is largely hacky and bad :(	-Pete
/obj/item/weapon/gun/projectile/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "shotgun"
	max_shells = 2
	w_class = 4.0
	force = 10
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK
	caliber = "shotgun"
	origin_tech = "combat=3;materials=1"
	ammo_type = "/obj/item/ammo_casing/shotgun/beanbag"

	New()
		for(var/i = 1, i <= max_shells, i++)
			loaded += new ammo_type(src)

		update_icon()
		return

	load_into_chamber()
//		if(in_chamber)
//			return 1 {R}
		if(!loaded.len)
			return 0

		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		AC.desc += " This one is spent."

		if(AC.BB)
			in_chamber = AC.BB //Load projectile into chamber.
			AC.BB.loc = src //Set projectile loc to gun.
			return 1
		return 0

	attack_self(mob/living/user as mob)
		if(!(locate(/obj/item/ammo_casing/shotgun) in src) && !loaded.len)
			user << "<span class='notice'>\The [src] is empty.</span>"
			return

		for(var/obj/item/ammo_casing/shotgun/shell in src)	//This feels like a hack.	//don't code at 3:30am kids!!
			if(shell in loaded)
				loaded -= shell
			shell.loc = get_turf(src.loc)

		user << "<span class='notice'>You break \the [src].</span>"
		update_icon()

	attackby(var/obj/item/A as obj, mob/user as mob)
		if(istype(A, /obj/item/ammo_casing) && !load_method)
			var/obj/item/ammo_casing/AC = A
			if(AC.caliber == caliber && (loaded.len < max_shells) && (contents.len < max_shells))	//forgive me father, for i have sinned
				user.drop_item()
				AC.loc = src
				loaded += AC
				user << "<span class='notice'>You load a shell into \the [src]!</span>"
		A.update_icon()
		update_icon()
		if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter))
			user << "<span class='notice'>You begin to shorten the barrel of \the [src].</span>"
			if(loaded.len)
				afterattack(user, user)	//will this work?
				afterattack(user, user)	//it will. we call it twice, for twice the FUN
				playsound(user, fire_sound, 50, 1)
				user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
				return
			if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
				icon_state = "sawnshotgun"
				w_class = 3.0
				item_state = "gun"
				slot_flags &= ~SLOT_BACK	//you can't sling it on your back
				slot_flags |= SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
				name = "sawn-off shotgun"
				desc = "Omar's coming!"
				user << "<span class='warning'>You shorten the barrel of \the [src]!</span>" */

/obj/item/weapon/gun/projectile/shotgun
	name = "shotgun"
	desc = "Useful for sweeping alleys."
	icon_state = "shotgun"
	item_state = "shotgun"
	w_class = 4.0
	force = 10
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = "combat=4;materials=2"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	var/recentpump = 0 // to prevent spammage
	var/pumped = 0

/obj/item/weapon/gun/projectile/shotgun/isHandgun()
	return 0

/obj/item/weapon/gun/projectile/shotgun/attackby(var/obj/item/A as obj, mob/user as mob)
	var/num_loaded = 0
	if(istype(A, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			if(magazine.give_round(AC))
				AM.stored_ammo -= AC
				num_loaded++
			else
				break
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = A
		if(magazine.give_round(AC))
			user.drop_item()
			AC.loc = src
			num_loaded++
	if(num_loaded)
		user << "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>"
		A.update_icon()
		update_icon()

/obj/item/weapon/gun/projectile/shotgun/process_chambered()
	return ..(0, 0)

/obj/item/weapon/gun/projectile/shotgun/chamber_round()
	return

/obj/item/weapon/gun/projectile/shotgun/attack_self(mob/living/user)
	if(recentpump)	return
	pump(user)
	recentpump = 1
	spawn(10)
		recentpump = 0
	return


/obj/item/weapon/gun/projectile/shotgun/proc/pump(mob/M)
	playsound(M, 'sound/weapons/shotgunpump.ogg', 60, 1)
	pumped = 0
	if(chambered)//We have a shell in the chamber
		chambered.loc = get_turf(src)//Eject casing
		chambered = null
		if(in_chamber)
			in_chamber = null
	if(!magazine.ammo_count())	return 0
	var/obj/item/ammo_casing/AC = magazine.get_round() //load next casing.
	chambered = AC
	update_icon()	//I.E. fix the desc
	return 1

/obj/item/weapon/gun/projectile/shotgun/examine()
	..()
	if (chambered)
		usr << "A [chambered.BB ? "live" : "spent"] one is in the chamber."

/obj/item/weapon/gun/projectile/shotgun/combat
	name = "combat shotgun"
	icon_state = "cshotgun"
	origin_tech = "combat=5;materials=2"
	ammo_type = /obj/item/ammo_casing/shotgun
	mag_type = /obj/item/ammo_box/magazine/internal/shotcom
	w_class = 5

/obj/item/weapon/gun/projectile/revolver/doublebarrel
	name = "double-barreled shotgun"
	desc = "A true classic."
	icon_state = "dshotgun"
	item_state = "shotgun"
	w_class = 4.0
	force = 10
	flags =  FPRINT | TABLEPASS | CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = "combat=3;materials=1"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	mag_type = /obj/item/ammo_box/magazine/internal/cylinder/dualshot

/obj/item/weapon/gun/projectile/revolver/doublebarrel/isHandgun()
	return 0

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attackby(var/obj/item/A as obj, mob/user as mob)
	..()
	if (istype(A,/obj/item/ammo_box) || istype(A,/obj/item/ammo_casing))
		chamber_round()
	if(istype(A, /obj/item/weapon/circular_saw) || istype(A, /obj/item/weapon/melee/energy) || istype(A, /obj/item/weapon/pickaxe/plasmacutter))
		user << "<span class='notice'>You begin to shorten the barrel of \the [src].</span>"
		if(get_ammo())
			afterattack(user, user)	//will this work?
			afterattack(user, user)	//it will. we call it twice, for twice the FUN
			playsound(user, fire_sound, 50, 1)
			user.visible_message("<span class='danger'>The shotgun goes off!</span>", "<span class='danger'>The shotgun goes off in your face!</span>")
			return
		if(do_after(user, 30))	//SHIT IS STEALTHY EYYYYY
			icon_state = "sawnshotgun"
			w_class = 3.0
			item_state = "gun"
			slot_flags &= ~SLOT_BACK	//you can't sling it on your back
			slot_flags |= SLOT_BELT		//but you can wear it on your belt (poorly concealed under a trenchcoat, ideally)
			user << "<span class='warning'>You shorten the barrel of \the [src]!</span>"
			name = "sawn-off shotgun"
			desc = "Omar's coming!"

/obj/item/weapon/gun/projectile/revolver/doublebarrel/attack_self(mob/living/user as mob)
	var/num_unloaded = 0
	while (get_ammo() > 0)
		var/obj/item/ammo_casing/CB
		CB = magazine.get_round(0)
		chambered = null
		CB.loc = get_turf(src.loc)
		CB.update_icon()
		num_unloaded++
	if (num_unloaded)
		user << "<span class = 'notice'>You break open \the [src] and unload [num_unloaded] shell\s.</span>"
	else
		user << "<span class='notice'>[src] is empty.</span>"