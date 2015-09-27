/obj/item/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage = 5
	sharp = 1
	embed = 1 //the dart is shot fast enough to pierce space suits, so I guess splintering inside the target can be a thing. Should be rare due to low damage.
	var/reagent_amount = 15
	kill_count = 15 //shorter range
	
	muzzle_type = null

/obj/item/projectile/bullet/chemdart/New()
	reagents = new/datum/reagents(reagent_amount)
	reagents.my_atom = src

/obj/item/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked < 2 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(target_zone=def_zone))
			reagents.trans_to_mob(L, reagent_amount, CHEM_BLOOD)

/obj/item/ammo_casing/chemdart
	name = "chemical dart"
	desc = "A small hardened, hollow dart."
	icon_state = "dart"
	caliber = "dart"
	projectile_type = /obj/item/projectile/bullet/chemdart

/obj/item/ammo_casing/chemdart/expend()
	qdel(src)

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	mag_type = MAGAZINE
	caliber = "dart"
	ammo_type = /obj/item/ammo_casing/chemdart
	max_ammo = 5
	multiple_sprites = 1

/obj/item/weapon/gun/projectile/dartgun
	name = "dart gun"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms market, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances."
	icon_state = "dartgun-empty"
	item_state = null

	caliber = "dart"
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	recoil = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	auto_eject = 0

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for mixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/weapon/reagent_containers/glass/beaker
	var/list/starting_chems = null

/obj/item/weapon/gun/projectile/dartgun/dartgun/New()
	..()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B = new container_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	update_icon()

/obj/item/weapon/gun/projectile/dartgun/update_icon()
	if(!ammo_magazine)
		icon_state = "dartgun-empty"
		return 1

	if(!ammo_magazine.stored_ammo || ammo_magazine.stored_ammo.len)
		icon_state = "dartgun-0"
	else if(ammo_magazine.stored_ammo.len > 5)
		icon_state = "dartgun-5"
	else
		icon_state = "dartgun-[ammo_magazine.stored_ammo.len]"
	return 1

/obj/item/weapon/gun/projectile/dartgun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/bullet/chemdart/dart = .
	if(istype(dart))
		fill_dart(dart)

/obj/item/weapon/gun/projectile/dartgun/examine(mob/user)
	//update_icon()
	//if (!..(user, 2))
	//	return
	..()
	if (beakers.len)
		user << "\blue [src] contains:"
		for(var/obj/item/weapon/reagent_containers/glass/beaker/B in beakers)
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					user << "\blue [R.volume] units of [R.name]"

/obj/item/weapon/gun/projectile/dartgun/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(!istype(I, container_type))
			user << "\blue [I] doesn't seem to fit into [src]."
			return
		if(beakers.len >= max_beakers)
			user << "\blue [src] already has [max_beakers] beakers in it - another one isn't going to fit!"
			return
		var/obj/item/weapon/reagent_containers/glass/beaker/B = I
		user.drop_item()
		B.loc = src
		beakers += B
		user << "\blue You slot [B] into [src]."
		src.updateUsrDialog()
		return 1
	..()

//fills the given dart with reagents
/obj/item/weapon/gun/projectile/dartgun/proc/fill_dart(var/obj/item/projectile/bullet/chemdart/dart)
	if(mixing.len)
		var/mix_amount = dart.reagent_amount/mixing.len
		for(var/obj/item/weapon/reagent_containers/glass/beaker/B in mixing)
			B.reagents.trans_to_obj(dart, mix_amount)

/obj/item/weapon/gun/projectile/dartgun/attack_self(mob/user)
	user.set_machine(src)
	var/dat = "<b>[src] mixing control:</b><br><br>"

	if (beakers.len)
		var/i = 1
		for(var/obj/item/weapon/reagent_containers/glass/beaker/B in beakers)
			dat += "Beaker [i] contains: "
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					dat += "<br>    [R.volume] units of [R.name], "
				if (check_beaker_mixing(B))
					dat += text("<A href='?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> ")
				else
					dat += text("<A href='?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> ")
			else
				dat += "nothing."
			dat += " \[<A href='?src=\ref[src];eject=[i]'>Eject</A>\]<br>"
			i++
	else
		dat += "There are no beakers inserted!<br><br>"

	if(ammo_magazine)
		if(ammo_magazine.stored_ammo && ammo_magazine.stored_ammo.len)
			dat += "The dart cartridge has [ammo_magazine.stored_ammo.len] shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='?src=\ref[src];eject_cart=1'>Eject</A>\]"

	user << browse(dat, "window=dartgun")
	onclose(user, "dartgun", src)

/obj/item/weapon/gun/projectile/dartgun/proc/check_beaker_mixing(var/obj/item/B)
	if(!mixing || !beakers)
		return 0
	for(var/obj/item/M in mixing)
		if(M == B)
			return 1
	return 0

/obj/item/weapon/gun/projectile/dartgun/Topic(href, href_list)
	if(..()) return 1
	src.add_fingerprint(usr)
	if(href_list["stop_mix"])
		var/index = text2num(href_list["stop_mix"])
		if(index <= beakers.len)
			for(var/obj/item/M in mixing)
				if(M == beakers[index])
					mixing -= M
					break
	else if (href_list["mix"])
		var/index = text2num(href_list["mix"])
		if(index <= beakers.len)
			mixing += beakers[index]
	else if (href_list["eject"])
		var/index = text2num(href_list["eject"])
		if(index <= beakers.len)
			if(beakers[index])
				var/obj/item/weapon/reagent_containers/glass/beaker/B = beakers[index]
				usr << "You remove [B] from [src]."
				mixing -= B
				beakers -= B
				B.loc = get_turf(src)
	else if (href_list["eject_cart"])
		unload_ammo(usr)
	src.updateUsrDialog()
	return

/obj/item/weapon/gun/projectile/dartgun/vox
	name = "alien dart gun"
	desc = "A small gas-powered dartgun, fitted for nonhuman hands."

/obj/item/weapon/gun/projectile/dartgun/vox/medical
	starting_chems = list("kelotane","bicaridine","anti_toxin")

/obj/item/weapon/gun/projectile/dartgun/vox/raider
	starting_chems = list("space_drugs","stoxin","impedrezene")
