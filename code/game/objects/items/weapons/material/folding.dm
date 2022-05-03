
// folding/locking knives
/obj/item/material/knife/folding
	name = "pocketknife"
	desc = "A small folding knife."
	icon = 'icons/obj/folding_knife.dmi'
	icon_state = "knife_preview"
	item_state = null
	force = 0.2 //force of folded obj
	max_force = 10
	max_pen = 0
	force_multiplier = 0.2
	applies_material_colour = FALSE
	applies_material_name = FALSE
	unbreakable = TRUE
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("prodded", "tapped")
	hitsound = "swing_hit"
	edge = FALSE
	sharp = FALSE

	var/open = FALSE
	var/takes_colour = TRUE
	var/hardware_closed = "basic_hardware_closed"
	var/hardware_open = "basic_hardware"
	var/handle_icon = "basic_handle"

	var/closed_attack_verbs = list("prodded", "tapped") //initial doesn't work with lists, rip
	var/valid_colors = list(COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_DARK_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_DARK_GREEN_GRAY)

/obj/item/material/knife/folding/Initialize()
	if(takes_colour)
		color = pick(valid_colors)
	icon_state = handle_icon
	update_icon()
	. = ..()

/obj/item/material/knife/folding/attack_self(mob/user)
	open = !open
	update_force()
	update_icon()
	if(open)
		user.visible_message("<span class='warning'>\The [user] opens \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		user.visible_message("<span class='notice'>\The [user] closes \the [src].</span>")
	add_fingerprint(user)

/obj/item/material/knife/folding/update_force()
	if(open)
		edge = TRUE
		sharp = TRUE
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("slashed", "stabbed")
		attack_cooldown_modifier = -1
		base_parry_chance = 15
		..()
	else
		force = initial(force)
		edge = initial(edge)
		sharp = initial(sharp)
		hitsound = initial(hitsound)
		w_class = initial(w_class)
		attack_verb = closed_attack_verbs
		attack_cooldown_modifier = initial(attack_cooldown_modifier)
		base_parry_chance = initial(base_parry_chance)

/obj/item/material/knife/folding/on_update_icon()
	if(open)
		overlays.Cut()
		overlays += overlay_image(icon, hardware_open, flags=RESET_COLOR)
		item_state = "knife"
	else
		overlays.Cut()
		overlays += overlay_image(icon, hardware_closed, flags=RESET_COLOR)
		item_state = initial(item_state)
	if(blood_overlay)
		overlays += blood_overlay

//Subtypes
/obj/item/material/knife/folding/wood
	name = "peasant knife"
	desc = "A small folding knife with a wooden handle and carbon steel blade. Knives like this have been used on Earth for centuries."
	hardware_closed = "peasant_hardware_closed"
	hardware_open = "peasant_hardware"
	handle_icon = "peasant_handle"
	valid_colors = list(WOOD_COLOR_GENERIC, WOOD_COLOR_RICH, WOOD_COLOR_BLACK, WOOD_COLOR_CHOCOLATE, WOOD_COLOR_PALE)

/obj/item/material/knife/folding/tacticool
	name = "folding knife"
	desc = "A small folding knife with a polymer handle and a blackened steel blade. These are typically marketed for self defense purposes."
	hardware_closed = "tacticool_hardware_closed"
	hardware_open = "tacticool_hardware"
	handle_icon = "tacticool_handle"
	valid_colors = list("#0f0f2a", "#2a0f0f", "#0f2a0f", COLOR_GRAY20, COLOR_DARK_GUNMETAL)

/obj/item/material/knife/folding/combat //master obj
	name = "the concept of a fighting knife in which the blade can be stowed in its own handle"
	desc = "This is a master item - berate the admin or mapper who spawned this!"
	max_force = 15
	max_pen = 30
	force_multiplier = 0.25
	thrown_force_multiplier = 0.25
	takes_colour = FALSE
	worth_multiplier = 8
	base_parry_chance = 30

/obj/item/material/knife/folding/combat/balisong
	name = "butterfly knife"
	desc = "A basic metal blade concealed in a lightweight plasteel grip. Small enough when folded to fit in a pocket."
	hardware_closed = "bfly_hardware_closed"
	hardware_open = "bfly_hardware"
	handle_icon = "bfly_handle"

/obj/item/material/knife/folding/combat/switchblade
	name = "switchblade"
	desc = "A classic switchblade with gold engraving. Just holding it makes you feel like a gangster."
	hardware_closed = "switch_hardware_closed"
	hardware_open = "switch_hardware"
	handle_icon = "switch_handle"
