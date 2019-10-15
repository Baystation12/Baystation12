


/* KHOROS AXE */

/obj/item/weapon/electric_axe
	name = "Khoros power axe"
	icon = 'code/modules/halo/factions/npc_factions/gear/khoros.dmi'
	icon_state = "electric_axe0"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/factions/npc_factions/gear/khoros.dmi',
		slot_r_hand_str = 'code/modules/halo/factions/npc_factions/gear/khoros.dmi',
		)
	item_state_slots = list(
		slot_l_hand_str = "electric_axel",
		slot_r_hand_str = "electric_axer",
		)
	throwforce = 15
	force = 35
	var/obj/item/weapon/cell/cell
	var/charge_per_hit = 75
	var/active = 0

/obj/item/weapon/electric_axe/New()
	. = ..()
	cell = new /obj/item/weapon/cell/crap(src)

/obj/item/weapon/electric_axe/examine(var/mob/user)
	. = ..()
	if(src.loc == user || get_dist(src,user) <= 1)
		var/charge = 0
		if(cell)
			charge = round(100 * cell.charge/cell.maxcharge)
			to_chat(user, "<span class='notice'>It has [charge]% charge left.</span>")
		else
			to_chat(user, "<span class='notice'>It does not have a cell installed.</span>")

/obj/item/weapon/electric_axe/update_icon(var/mob/user)
	if(cell)
		icon_state = "electric_axe[active]"
	else
		icon_state = "khoros_axe"

	if(active)
		item_state_slots = list(
			slot_l_hand_str = "electric_axel",
			slot_r_hand_str = "electric_axer",
			)
		force = 40
		throwforce = 20
		damtype = "fire"
	else
		item_state_slots = list(
			slot_l_hand_str = "khoros_axel",
			slot_r_hand_str = "khoros_axer",
			)
		force = 35
		throwforce = 15
		damtype = "brute"

	if(user)
		if(user.hand)
			user.update_inv_l_hand()
		else
			user.update_inv_r_hand()

/obj/item/weapon/electric_axe/attack_self(mob/user)
	if(!active)
		if(!cell || cell.charge <= 0)
			to_chat(user, "<span class='warning'>[src] does not have enough charge to electrify [src].</span>")
			return

	active = !active
	update_icon(user)

	if(active)
		to_chat(user, "<span class='notice'>You activate [src], electrifying the axehead.</span>")
	else
		to_chat(user, "<span class='info'>You deactivate [src].</span>")

/obj/item/weapon/electric_axe/attackby(var/obj/item/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(src.loc == user)
			if(cell)
				if(do_after(user, 3 SECONDS))
					to_chat(user, "<span class='info'>You remove [cell] from [src].</span>")
					cell.loc = get_turf(src)
					if(active)
						active = 0
						if(cell.charge > 0)
							var/shock_dam = cell.charge / 10
							if(user.hand)
								user.electrocute_act(shock_dam, cell, def_zone = BP_L_HAND)
							else
								user.electrocute_act(shock_dam, cell, def_zone = BP_R_HAND)
							cell.use(cell.charge)
							to_chat(user, "<span class='warning'>You are shocked by [cell] as you remove it!</span>")
					cell = null
					update_icon(user)
			else
				to_chat(user, "<span class='notice'>[src] does not have a cell to remove.</span>")
		else
			to_chat(user, "<span class='notice'>You must be holding [src] to do that.</span>")
	else if(istype(I, /obj/item/weapon/cell))
		if(cell)
			to_chat(user, "<span class='notice'>[src] already has [cell] installed.</span>")
		else if(do_after(user, 3 SECONDS))
			user.drop_from_inventory(I, src)
			cell = I
			to_chat(user, "<span class='info'>You install [cell] into [src].</span>")
			update_icon(user)
	else
		. = ..()

/obj/item/weapon/electric_axe/afterattack(var/atom/target,var/mob/user,adjacent,var/clickparams)
	if(active)
		if(cell)
			cell.use(charge_per_hit)

		if(!cell || !cell.charge)
			active = 0
			update_icon(user)
			to_chat(user, "<span class='warning'>[src] shuts down as it runs out of power!</span>")
