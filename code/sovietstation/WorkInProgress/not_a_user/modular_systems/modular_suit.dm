//Module Suit
/obj/item/clothing/suit/armor/modular
	name = "Modular Armor"
//	icon = ''
	icon_state = "exosuit_mk1"
	item_state = "exosuit_mk1"
	w_class = 4
	flags = FPRINT | TABLEPASS
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	allowed = list(/obj/item/weapon/tank/emergency_oxygen, /obj/item/device/flashlight)
	slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | ARMS

	var/list/armor_modules = newlist()
	var/secured = 1

/obj/item/clothing/suit/armor/modular/New()
	processing_objects += src
	..()

/obj/item/clothing/suit/armor/modular/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/screwdriver))
		if(secured)
			user.visible_message("[user] unscrewed [src].", "You unscrewed [src].")
			secured = 0
		else
			user.visible_message("[user] screwed [src].", "You screwed [src].")
			secured = 1
	else if(istype(W, /obj/item/modular/module))
		var/obj/item/modular/module/mod = W
		var/list/d_needing_modules = mod.needing_modules
		for(var/obj/item/modular/module/mod_i in armor_modules)
			if(istype(mod, mod_i) || mod_i.type in mod.conflicting_modules)
				return

			if(mod_i.type in d_needing_modules)
				d_needing_modules -= mod_i.type

		if(d_needing_modules.len)
			return

		user.drop_item()
		mod.loc = src.loc
		armor_modules += mod
		mod.attach()

	else
		for(ar/obj/item/modular/module/mod in armor_modules)
			if(mod.attackby(W, user))
				return
		..()

/obj/item/modular/module
	name = "Module"
	icon_state = "fingerprint0"
	var/list/conflicting_modules = newlist()
	var/list/needing_modules = newlist()

	proc/attach()
		return

	proc/detach()
		return

	proc/p_step()
		return

	attackby(obj/item/W as obj, mob/user as mob)
		return 0