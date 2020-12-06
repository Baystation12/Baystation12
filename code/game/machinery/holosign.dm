////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector."
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	layer = ABOVE_DOOR_LAYER
	idle_power_usage = 2
	active_power_usage = 70
	anchored = 1
	var/lit = 0
	var/on_icon = "sign_on"

	uncreated_component_parts = list(
		/obj/item/weapon/stock_parts/radio/receiver,
		/obj/item/weapon/stock_parts/power/apc
	)
	public_variables = list(
		/decl/public_access/public_variable/holosign_on
	)
	public_methods = list(
		/decl/public_access/public_method/holosign_toggle
	)
	stock_part_presets = list(/decl/stock_part_preset/radio/receiver/holosign = 1)

/obj/machinery/holosign/proc/toggle()
	if (inoperable())
		return
	lit = !lit
	update_use_power(lit ? POWER_USE_ACTIVE : POWER_USE_IDLE)
	update_icon()

/obj/machinery/holosign/on_update_icon()
	if (!lit || inoperable())
		icon_state = "sign_off"
		set_light(0)
	else
		icon_state = on_icon
		set_light(0.5, 0.5, 1, l_color = COLOR_CYAN_BLUE)

/decl/public_access/public_variable/holosign_on
	expected_type = /obj/machinery/holosign
	name = "holosign active"
	desc = "Whether or not the holosign is active."
	can_write = FALSE
	has_updates = FALSE

/decl/public_access/public_variable/holosign_on/access_var(obj/machinery/holosign/sign)
	return sign.lit

/decl/public_access/public_method/holosign_toggle
	name = "holosign toggle"
	desc = "Toggle the holosign's active state."
	call_proc = /obj/machinery/holosign/proc/toggle

/decl/stock_part_preset/radio/receiver/holosign
	frequency = BUTTON_FREQ
	receive_and_call = list("button_active" = /decl/public_access/public_method/holosign_toggle)

/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"

/obj/machinery/holosign/chapel
	name = "chapel holosign"
	desc = "Small wall-mounted holographic projector. This one reads SERVICE."
	on_icon = "service"

////////////////////SWITCH///////////////////////////////////////
/obj/machinery/button/holosign
	name = "holosign switch"
	desc = "A remote control switch for holosign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/holosign/on_update_icon()
	icon_state = "light[active]"