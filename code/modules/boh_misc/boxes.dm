/obj/item/gunbox
	name = "equipment kit"
	desc = "A secure box containing a sidearm."
	icon = 'icons/obj/storage.dmi'
	icon_state = "ammo" //temp

/obj/item/gunbox/attack_self(mob/living/user)
	var/list/options = list()
	options["Ballistic - Military Pistol"] = list(/obj/item/weapon/gun/projectile/pistol/military,/obj/item/ammo_magazine/pistol/double/rubber)
	options["Energy - Smartgun"] = list(/obj/item/weapon/gun/energy/gun/secure)
	options["Taser - Stun Revolver"] = list(/obj/item/weapon/gun/energy/stunrevolver/secure)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM]. This is probably worth more than what your paycheck can be used for.")
		qdel(src)

/////////
// 'Officer' Lockbox
/////////

/obj/item/gunbox/captain
	desc = "A secure box containing a sidearm."

/obj/item/gunbox/captain/attack_self(mob/living/user)
	var/list/options = list()
	options["Ballistic - .454 Revolver"] = list(/obj/item/weapon/gun/projectile/revolver/medium/captain/large,/obj/item/weapon/storage/fancy/cigar,/obj/item/ammo_magazine/speedloader/large)
	options["Ballistic - Mk58 semi-automatic"] = list(/obj/item/weapon/gun/projectile/pistol/sec/lethal,/obj/item/ammo_magazine/pistol,/obj/item/weapon/storage/fancy/cigar)
	options["Energy - EPP"] = list(/obj/item/weapon/gun/energy/pulse_rifle/pistol/epp,/obj/item/documents/epp)
	options["Energy - Smart Service Revolver"] = list(/obj/item/weapon/gun/energy/revolver/secure)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM].")
		qdel(src)

/////////
// 'Officer' Lockbox 2
/////////

/obj/item/gunbox/executive
	desc = "A secure box containing a sidearm."

/obj/item/gunbox/executive/attack_self(mob/living/user)
	var/list/options = list()
	options["Ballistic - Mk58 semi-automatic"] = list(/obj/item/weapon/gun/projectile/pistol/sec/lethal,/obj/item/ammo_magazine/pistol,/obj/item/weapon/storage/fancy/cigar)
	options["Ballistic - Magnum Revolver"] = list(/obj/item/weapon/gun/projectile/revolver/medium/captain/large/xo,/obj/item/weapon/storage/fancy/cigar,/obj/item/ammo_magazine/speedloader/magnum)
	options["Energy - EPP"] = list(/obj/item/weapon/gun/energy/pulse_rifle/pistol/epp,/obj/item/documents/epp)
	options["Energy - Smart Service Revolver"] = list(/obj/item/weapon/gun/energy/revolver/secure)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM].")
		qdel(src)

/////////
// Firearm Kit
/////////
/obj/item/ascentbox
	name = "equipment kit"
	desc = "A secure box containing equipment."
	icon = 'icons/obj/ascent_doodads.dmi'
	icon_state = "box" //temp

/obj/item/ascentbox/attack_self(mob/living/user)
	var/list/options = list()
	options["Support Alate"] = list(/obj/item/stack/medical/resin/large,/obj/item/weapon/gun/energy/particle/support)
	options["Enforcering Alate"] = list(/obj/item/weapon/gun/energy/particle/small,/obj/item/weapon/storage/med_pouch/ascent)
	var/choice = input(user,"What type of equipment?") as null|anything in options
	if(src && choice)
		var/list/things_to_spawn = options[choice]
		for(var/new_type in things_to_spawn)
			var/atom/movable/AM = new new_type(get_turf(src))
			if(istype(AM, /obj/item/weapon/gun/))
				to_chat(user, "You have chosen \the [AM]. This is probably worth more than what your Gyne thinks of you.")
		qdel(src)

