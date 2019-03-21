// folding knives for general issue

/obj/item/weapon/material/kitchen/utensil/knife/folding
	name = "pocketknife"
	desc = "A small folding knife."
	icon = 'icons/obj/folding_knife.dmi'
	icon_state = "knife_preview"
	force = 0.2 //force of folded obj
	force_divisor = 0.1 //force 6 when made of steel
	applies_material_colour = FALSE
	applies_material_name = FALSE
	unbreakable = TRUE
	w_class = ITEM_SIZE_SMALL
	attack_verb = list("prodded")
	hitsound = "swing_hit"
	edge = FALSE
	sharp = FALSE

	var/open = FALSE
	var/takes_colour = TRUE
	var/hardware_closed = "basic_hardware_closed"
	var/hardware_open = "basic_hardware"
	var/handle_icon = "basic_handle"

	var/valid_colors = list(COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_DARK_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_DARK_GREEN_GRAY)

/obj/item/weapon/material/kitchen/utensil/knife/folding/Initialize()
	if(takes_colour)
		color = pick(valid_colors)
	icon_state = handle_icon
	update_icon()
	. = ..()

/obj/item/weapon/material/kitchen/utensil/knife/folding/attack_self(mob/user)
	open = !open
	update_force()
	update_icon()
	if(open)
		user.visible_message("<span class='warning'>\The [user] opens \the [src].</span>")
		playsound(user, 'sound/weapons/flipblade.ogg', 15, 1)
	else
		user.visible_message("<span class='notice'>\The [user] closes \the [src].</span>")
s
/obj/item/weapon/material/kitchen/utensil/knife/folding/update_force()
	if(open)
		edge = 1
		sharp = 1
		hitsound = 'sound/weapons/bladeslice.ogg'
		w_class = ITEM_SIZE_NORMAL
		attack_verb = list("slashed", "stabbed")
		..()
	else
		force = initial(force)
		edge = initial(edge)
		sharp = initial(sharp)
		hitsound = initial(hitsound)
		w_class = initial(w_class)
		attack_verb = initial(attack_verb)

/obj/item/weapon/material/kitchen/utensil/knife/folding/on_update_icon()
	if(open)
		overlays.Cut()
		overlays += overlay_image(icon, hardware_open, flags=RESET_COLOR)
	else
		overlays.Cut()
		overlays += overlay_image(icon, hardware_closed, flags=RESET_COLOR)
	if(blood_overlay)
		overlays += blood_overlay

/obj/item/weapon/material/kitchen/utensil/knife/folding/wood
	name = "peasant knife"
	desc = "A small folding knife with a wooden handle and carbon steel blade. It's been used for general tasks on Earth for centuries."
	hardware_closed = "peasant_hardware_closed"
	hardware_open = "peasant_hardware"
	handle_icon = "peasant_handle"
	valid_colors = list(WOOD_COLOR_GENERIC, WOOD_COLOR_RICH, WOOD_COLOR_BLACK, WOOD_COLOR_CHOCOLATE, WOOD_COLOR_PALE)