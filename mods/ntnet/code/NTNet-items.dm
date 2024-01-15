//  HACSO's HUD and related interactions
// code\__defines\items_clothing.dm - used outside pack
// code\modules\mob\living\carbon\human\examine.dm - used outside pack

/obj/item/clothing/glasses/hud/it
	name = "IT special HUD"
	desc = "An augmented reality device that allows you to see doors NTNet ID's."
	icon = 'mods/NTNet/icons/obj_eyes.dmi'
	item_icons = list(slot_glasses_str = 'mods/NTNet/icons/onmob_eyes.dmi')
	icon_state = "ithud"
	off_state = "ithud_off"
	hud_type = HUD_IT
	body_parts_covered = 0

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (src.isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (MATERIAL_STEEL in i.matter) && i.matter[MATERIAL_STEEL] > 0)
				var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
				s.set_up(5, 1, src)
				s.start()
	return ..()

/obj/machinery/door/airlock/examine(mob/user)
	. = ..()
	if(hasHUD(user, HUD_IT) && arePowerSystemsOn())
		to_chat(user, SPAN_INFO(SPAN_ITALIC("You may notice a small hologram that says: [NTNet_id]")))

/obj/machinery/power/apc/examine(mob/user)
	. = ..()
	if(hasHUD(user, HUD_IT) && has_electronics && terminal())
		to_chat(user, SPAN_INFO(SPAN_ITALIC("You may notice a small hologram that says: [NTNet_id]")))

/obj/machinery/firealarm/examine(mob/user)
	. = ..()
	if(hasHUD(user, HUD_IT))
		to_chat(user, SPAN_INFO(SPAN_ITALIC("You may notice a small hologram that says: [NTNet_id]")))

/obj/item/modular_computer/examine(mob/user)
	. = ..()
	if(hasHUD(user, HUD_IT))
		if(network_card && network_card.check_functionality() && enabled)
			to_chat(user, SPAN_INFO(SPAN_ITALIC("You may notice a small hologram that says: [network_card.get_network_tag()].")))

/obj/machinery/computer/modular/examine(mob/user)
	. = ..()
	if(hasHUD(user, HUD_IT))
		var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
		var/obj/item/stock_parts/computer/network_card/network_card = os.get_component(PART_NETWORK)
		if(istype(network_card) && network_card.check_functionality() && os.on)
			to_chat(user, SPAN_INFO(SPAN_ITALIC("You may notice a small hologram that says: [network_card.get_network_tag()].")))
