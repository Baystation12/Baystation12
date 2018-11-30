
/obj/item/weapon/pickaxe/plasma_drill
	name = "plasma drill"
	icon = 'plasma_drill.dmi'
	icon_state = "plasma04"
	item_state = "ionrifle"
	digspeed = 20
	desc = "An advanced tool for cutting through metals."
	excavation_amount = 1
	drill_sound = 'sound/effects/teleport.ogg'
	drill_verb = "burning"
	damtype = "brute"
	w_class = ITEM_SIZE_LARGE
	var/charge_level = 100
	var/charge_max = 100
	var/charge_per_hit = 5
	var/active = 0
	force = 5
	sharp = 0
	edge = 0

/obj/item/weapon/pickaxe/plasma_drill/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	charge_level -= charge_per_hit
	update_icon()

/obj/item/weapon/pickaxe/plasma_drill/update_icon()
	var/charge_level = 4
	var/charge_increments = charge_max / 5
	if(charge_level < charge_level - charge_increments)
		charge_level = 3
	else if(charge_level < charge_level - charge_increments * 2)
		charge_level = 2
	else if(charge_level < charge_level - charge_increments * 3)
		charge_level = 1
	else
		charge_level = 0
	icon_state = "plasma[active][charge_level]"

/obj/item/weapon/pickaxe/plasma_drill/attack_self(var/mob/user)
	active = !active
	if(charge_level <= 0)
		active = 0
		to_chat(user, "<span class='notice'>[src] is out of charge</span>")
	else if(active)
		to_chat(user, "<span class='info'>You activate [src]. It has [100*charge_level/charge_max]% charge remaining.</span>")
		force = 35
		sharp = 1
		edge = 1
		damtype = "fire"
	else
		to_chat(user, "<span class='info'>You deactivate [src].</span>")
		force = 5
		sharp = 0
		edge = 0
		damtype = "brute"
	update_icon()
