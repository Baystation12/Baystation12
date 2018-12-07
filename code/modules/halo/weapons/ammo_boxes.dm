
/obj/item/ammo_box
	name = "Ammo Box"
	desc = "An ammunition box used for quick loading."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "666"
	var/capacity = 20
	var/list/ammo_spawnwith = list()
	var/load_time = 0.5 //The time it takes to load one round from the box to the weapon, in seconds

/obj/item/ammo_box/New()
	.=..()
	spawn(10)
		create_spawnwith_ammo()

/obj/item/ammo_box/proc/create_spawnwith_ammo()
	if(ammo_spawnwith.len == 0)
		return
	var/amount_per_type = round(capacity / ammo_spawnwith.len)
	for(var/C in ammo_spawnwith)
		for(var/i = 1 to amount_per_type)
			contents += new C
	update_icon()

/obj/item/ammo_box/proc/remove_ammo(var/wanted_quantity = 0,var/mob/user)
	var/ammo_removed = 0
	for(var/obj/item/ammo_casing/ammo in contents)
		if(ammo_removed < wanted_quantity)
			if(user.put_in_inactive_hand(ammo))
				contents -= ammo
	update_icon()

/obj/item/ammo_box/proc/add_ammo(var/obj/item/ammo_casing/C,var/mob/living/carbon/human/user)
	if(!(contents.len < capacity))
		return to_chat(user,"<span class = 'notice'>The [name] is full!</span>")
	to_chat(user,"<span class = 'notice'>You put the [C.name] into the [name]</span>")
	user.drop_from_inventory(C)
	contents += C
	update_icon()

/obj/item/ammo_box/attack_self(var/mob/user)
	if(contents.len > 0)
		remove_ammo(1,user)

/obj/item/ammo_box/attackby(var/obj/item/W,var/mob/user)
	. = ..()
	if(istype(W,/obj/item/ammo_casing))
		add_ammo(W,user)
		update_icon()

/obj/item/ammo_box/update_icon()
	desc = "[initial(desc)] It has [contents.len] rounds left."

/obj/item/ammo_box/shotgun
	name = "Shotgun Shell Box"
	desc = "A box of shells to assist in loading pump-action shotguns"
	ammo_spawnwith = list(/obj/item/ammo_casing/shotgun/pellet)

/obj/item/ammo_box/shotgun/update_icon()
	desc = "[initial(desc)] It has [contents.len] shells left."

/obj/item/ammo_box/shotgun/slug
	name = "Shotgun Slug Box"
	desc = "A box of slugs to assist in loading pump-action shotguns"
	ammo_spawnwith = list(/obj/item/ammo_casing/shotgun)

/obj/item/ammo_box/shotgun/slug/update_icon()
	desc = "[initial(desc)] It has [contents.len] slugs left."

/obj/item/ammo_box/shotgun/emp
	name = "Shotgun EMP Box"
	desc = "A box of EMP shells to assist in loading pump-action shotguns"
	ammo_spawnwith = list(/obj/item/ammo_casing/shotgun/emp)

/obj/item/ammo_box/shotgun/emp/update_icon()
	desc = "[initial(desc)] It has [contents.len] EMP shells left."

/obj/item/ammo_box/shotgun/beanbag
	name = "Shotgun Beanbag Box"
	desc = "A box of beanbag shells to assist in loading pump-action shotguns"
	ammo_spawnwith = list(/obj/item/ammo_casing/shotgun/beanbag)

/obj/item/ammo_box/shotgun/beanbag/update_icon()
	desc = "[initial(desc)] It has [contents.len] beanbag shells left."

/obj/item/ammo_box/shotgun/flash
	name = "Shotgun Flash Box"
	desc = "A box of flash shells to assist in loading pump-action shotguns"
	ammo_spawnwith = list(/obj/item/ammo_casing/shotgun/flash)

/obj/item/ammo_box/shotgun/flash/update_icon()
	desc = "[initial(desc)] It has [contents.len] flash shells left."

/obj/item/ammo_box/shotgun/practice
	name = "Shotgun Practice Box"
	desc = "A box of practice shells to assist in loading pump-action shotguns"
	ammo_spawnwith = list(/obj/item/ammo_casing/shotgun/practice)

/obj/item/ammo_box/shotgun/flash/update_icon()
	desc = "[initial(desc)] It has [contents.len] practice shells left."

/obj/item/ammo_box/heavysniper
	name = "Tracerless Sniper Rounds"
	desc = "A box of sniper rounds to assist in holding rounds for bolt-action sniper rifles"
	capacity = 14
	ammo_spawnwith = list(/obj/item/ammo_casing/a145_ap/tracerless)