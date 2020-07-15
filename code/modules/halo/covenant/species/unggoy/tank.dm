
/obj/item/weapon/tank/methane
	name = "gas tank"
	desc = "A green gas tank."
	icon = GRUNT_GEAR_ICON
	icon_override = GRUNT_GEAR_ICON
	icon_state = "methanetank_green"
	item_state_slots = list(slot_back_str = "methanetank_green_back", slot_l_hand_str = "methanetank_green", slot_r_hand_str = "methanetank_green")
	distribute_pressure = ONE_ATMOSPHERE*O2STANDARD
	var/starting_pressure = 1
	matter = list("nanolaminate" = 1)

/obj/item/weapon/tank/methane/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/red
	desc = "A red gas tank."
	icon_state = "methanetank_red"
	item_state_slots = list(slot_back_str = "methanetank_red_back", slot_l_hand_str = "methanetank_red", slot_r_hand_str = "methanetank_red")

/obj/item/weapon/tank/methane/red/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/blue
	desc = "A blue gas tank."
	icon_state = "methanetank_blue"
	item_state_slots = list(slot_back_str = "methanetank_blue_back", slot_l_hand_str = "methanetank_blue", slot_r_hand_str = "methanetank_blue")

/obj/item/weapon/tank/methane/blue/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/green/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/New()
	. = ..()
	if(starting_pressure > 0)
		air_contents.adjust_gas("methane", (6*ONE_ATMOSPHERE)*volume/(R_IDEAL_GAS_EQUATION*T20C))

/obj/item/weapon/tank/methane/unggoy_internal
	name = "Unggoy methane tank"
	desc = "A methane tank usually found affixed to a unggoy combat harness."
	gauge_icon = "indicator_emergency"
	icon = GRUNT_GEAR_ICON
	icon_state = "methane_tank_orange"
	item_state_slots = list(slot_back_str = "methanetank_red_back", slot_l_hand_str = "methanetank_red", slot_r_hand_str = "methanetank_red")
	slot_flags = SLOT_BACK

/obj/item/weapon/tank/methane/unggoy_internal/red
	icon_state = "methane_tank_red"
	item_state_slots = list(slot_back_str = "methanetank_red_back", slot_l_hand_str = "methanetank_red", slot_r_hand_str = "methanetank_red")

/obj/item/weapon/tank/methane/unggoy_internal/red/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/unggoy_internal/blue
	icon_state = "methane_tank_blue"
	item_state_slots = list(slot_back_str = "methanetank_blue_back", slot_l_hand_str = "methanetank_blue", slot_r_hand_str = "methanetank_blue")

/obj/item/weapon/tank/methane/unggoy_internal/blue/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/unggoy_internal/green
	icon_state = "methane_tank_green"
	item_state_slots = list(slot_back_str = "methanetank_green_back", slot_l_hand_str = "methanetank_green", slot_r_hand_str = "methanetank_green")

/obj/item/weapon/tank/methane/unggoy_internal/green/empty
	starting_pressure = 0

/obj/item/weapon/tank/methane/unggoy_internal/MouseDrop(var/obj/over_object)
	. = ..()
	if(over_object == src)
		ui_interact(usr)
