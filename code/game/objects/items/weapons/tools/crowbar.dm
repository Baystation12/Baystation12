/obj/item/weapon/crowbar
	name = "crowbar"
	desc = "A heavy crowbar of solid steel, good and solid in your hand."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 14
	attack_cooldown = 2*DEFAULT_WEAPON_COOLDOWN
	melee_accuracy_bonus = -10
	throwforce = 7
	throw_range = 3
	item_state = "crowbar"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MATERIAL_STEEL = 140)
	center_of_mass = "x=16;y=20"
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")

/obj/item/weapon/crowbar/red
	icon_state = "red_crowbar"
	item_state = "crowbar_red"

/obj/item/weapon/crowbar/prybar
	name = "pry bar"
	desc = "A steel bar with a wedge. It comes in a variety of configurations and colours - collect them all."
	icon_state = "prybar_preview"
	item_state = "crowbar"
	force = 4
	throwforce = 6
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 80)

	var/prybar_types = list("1","2","3","4","5")
	var/valid_colours = list(COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_BOTTLE_GREEN, COLOR_MAROON, COLOR_DARK_BROWN, COLOR_VIOLET, COLOR_GRAY20)

/obj/item/weapon/crowbar/prybar/Initialize()
	var/shape = pick(prybar_types)
	icon_state = "bar[shape]_handle"
	color = pick(valid_colours)
	overlays += overlay_image(icon, "bar[shape]_hardware", flags=RESET_COLOR)
	. = ..()

/obj/item/weapon/crowbar/emergency_forcing_tool
	name = "emergency forcing tool"
	desc = "This is an emergency forcing tool, made of steel bar with a wedge on one end, and a hatchet on the other end. It has a blue plastic grip"
	icon_state = "emergency_forcing_tool"
	item_state = "emergency_forcing_tool"
	force = 10
	throwforce = 6
	throw_range = 5
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_STEEL = 150)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked", "attacked", "slashed", "torn", "ripped", "cut")