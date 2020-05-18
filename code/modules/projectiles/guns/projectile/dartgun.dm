/obj/item/projectile/bullet/chemdart
	name = "dart"
	icon_state = "dart"
	damage = 5
	sharp = 1
	embed = 1 //the dart is shot fast enough to pierce space suits, so I guess splintering inside the target can be a thing. Should be rare due to low damage.
	var/reagent_amount = 15
	life_span = 15 //shorter range
	unacidable = 1

	muzzle_type = null

/obj/item/projectile/bullet/chemdart/New()
	create_reagents(reagent_amount)
	..()

/obj/item/projectile/bullet/chemdart/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if(blocked < 100 && isliving(target))
		var/mob/living/L = target
		if(L.can_inject(null, def_zone) == CAN_INJECT)
			reagents.trans_to_mob(L, reagent_amount, CHEM_BLOOD)

/obj/item/ammo_casing/chemdart
	name = "chemical dart"
	desc = "A small hardened, hollow dart."
	icon_state = "dart"
	caliber = CALIBER_DART
	projectile_type = /obj/item/projectile/bullet/chemdart
	leaves_residue = 0

/obj/item/ammo_casing/chemdart/expend()
	qdel(src)

/obj/item/ammo_magazine/chemdart
	name = "dart cartridge"
	desc = "A rack of hollow darts."
	icon_state = "darts"
	item_state = "rcdammo"
	origin_tech = list(TECH_MATERIAL = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_DART
	ammo_type = /obj/item/ammo_casing/chemdart
	max_ammo = 5
	multiple_sprites = 1

/obj/item/weapon/gun/projectile/dartgun
	name = "dart gun"
	desc = "Zeng-Hu Pharmaceutical's entry into the arms market, the Z-H P Artemis is a gas-powered dart gun capable of delivering chemical cocktails swiftly across short distances."
	icon = 'icons/obj/guns/dartgun.dmi'
	icon_state = "dartgun-empty"
	item_state = null

	caliber = CALIBER_DART
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic click"
	screen_shake = 0
	silenced = 1
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/chemdart
	allowed_magazines = /obj/item/ammo_magazine/chemdart
	auto_eject = 0
	handle_casings = CLEAR_CASINGS //delete casings instead of dropping them

	var/list/beakers = list() //All containers inside the gun.
	var/list/mixing = list() //Containers being used for mixing.
	var/max_beakers = 3
	var/dart_reagent_amount = 15
	var/container_type = /obj/item/weapon/reagent_containers/glass/beaker
	var/list/starting_chems = null

/obj/item/weapon/gun/projectile/dartgun/Initialize()
	if(starting_chems)
		for(var/chem in starting_chems)
			var/obj/B = new container_type(src)
			B.reagents.add_reagent(chem, 60)
			beakers += B
	. = ..()
	update_icon()

/obj/item/weapon/gun/projectile/dartgun/on_update_icon()
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
	. = ..()
	if (beakers.len)
		to_chat(user, "<span class='notice'>\The [src] contains:</span>")
		for(var/obj/item/weapon/reagent_containers/glass/beaker/B in beakers)
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					to_chat(user, "<span class='notice'>[R.volume] units of [R.name]</span>")

/obj/item/weapon/gun/projectile/dartgun/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		add_beaker(I, user)
		return 1
	..()

/obj/item/weapon/gun/projectile/dartgun/proc/add_beaker(var/obj/item/weapon/reagent_containers/glass/B, mob/user)
	if(!istype(B, container_type))
		to_chat(user, "<span class='warning'>[B] doesn't seem to fit into [src].</span>")
		return
	if(beakers.len >= max_beakers)
		to_chat(user, "<span class='warning'>[src] already has [max_beakers] beakers in it - another one isn't going to fit!</span>")
		return
	if(!user.unEquip(B, src))
		return
	beakers |= B
	user.visible_message("\The [user] inserts \a [B] into [src].", "<span class='notice'>You slot [B] into [src].</span>")

/obj/item/weapon/gun/projectile/dartgun/proc/remove_beaker(var/obj/item/weapon/reagent_containers/glass/B, mob/user)
	mixing -= B
	beakers -= B
	user.put_in_hands(B)
	user.visible_message("\The [user] removes \a [B] from [src].", "<span class='notice'>You remove [B] from [src].</span>")

//fills the given dart with reagents
/obj/item/weapon/gun/projectile/dartgun/proc/fill_dart(var/obj/item/projectile/bullet/chemdart/dart)
	if(mixing.len)
		var/mix_amount = dart.reagent_amount/mixing.len
		for(var/obj/item/weapon/reagent_containers/glass/beaker/B in mixing)
			B.reagents.trans_to_obj(dart, mix_amount)

/obj/item/weapon/gun/projectile/dartgun/attack_self(mob/user)
	Interact(user)

/obj/item/weapon/gun/projectile/dartgun/proc/Interact(mob/user)
	user.set_machine(src)
	var/list/dat = list("<b>[src] mixing control:</b><br><br>")

	if (!beakers.len)
		dat += "There are no beakers inserted!<br><br>"
	else
		for(var/i in 1 to beakers.len)
			var/obj/item/weapon/reagent_containers/glass/beaker/B = beakers[i]
			if(!istype(B)) continue

			dat += "Beaker [i] contains: "
			if(B.reagents && B.reagents.reagent_list.len)
				for(var/datum/reagent/R in B.reagents.reagent_list)
					dat += "<br>    [R.volume] units of [R.name], "
				if(B in mixing)
					dat += "<A href='?src=\ref[src];stop_mix=[i]'><font color='green'>Mixing</font></A> "
				else
					dat += "<A href='?src=\ref[src];mix=[i]'><font color='red'>Not mixing</font></A> "
			else
				dat += "nothing."
			dat += " \[<A href='?src=\ref[src];eject=[i]'>Eject</A>\]<br>"

	if(ammo_magazine)
		if(ammo_magazine.stored_ammo && ammo_magazine.stored_ammo.len)
			dat += "The dart cartridge has [ammo_magazine.stored_ammo.len] shots remaining."
		else
			dat += "<font color='red'>The dart cartridge is empty!</font>"
		dat += " \[<A href='?src=\ref[src];eject_cart=1'>Eject</A>\]<br>"

	dat += "<br>\[<A href='?src=\ref[src];refresh=1'>Refresh</A>\]"

	var/datum/browser/popup = new(user, "dartgun", "[src] mixing control")
	popup.set_content(jointext(dat,null))
	popup.open()

/obj/item/weapon/gun/projectile/dartgun/OnTopic(user, href_list)
	if(href_list["stop_mix"])
		var/index = text2num(href_list["stop_mix"])
		mixing -= beakers[index]
		. = TOPIC_REFRESH
	else if (href_list["mix"])
		var/index = text2num(href_list["mix"])
		mixing |= beakers[index]
		. = TOPIC_REFRESH
	else if (href_list["eject"])
		var/index = text2num(href_list["eject"])
		if(beakers[index])
			remove_beaker(beakers[index], usr)
		. = TOPIC_REFRESH
	else if (href_list["eject_cart"])
		unload_ammo(usr)
		. = TOPIC_REFRESH

	Interact(usr)

/obj/item/weapon/gun/projectile/dartgun/vox
	name = "alien dart gun"
	desc = "A small gas-powered dartgun, fitted for nonhuman hands."

/obj/item/weapon/gun/projectile/dartgun/vox/medical
	starting_chems = list(/datum/reagent/kelotane,/datum/reagent/bicaridine,/datum/reagent/dylovene)

/obj/item/weapon/gun/projectile/dartgun/vox/raider
	starting_chems = list(/datum/reagent/space_drugs,/datum/reagent/soporific,/datum/reagent/impedrezene)
