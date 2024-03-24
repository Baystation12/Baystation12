/obj/item/mech_component/manipulators
	name = "arms"
	pixel_y = -12
	icon_state = "loader_arms"
	has_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)

	var/punch_sound = 'sound/mecha/mech_punch.ogg'
	var/melee_damage = 20
	var/action_delay = 15
	var/obj/item/robot_parts/robot_component/actuator/motivator
	power_use = 10
	w_class = ITEM_SIZE_LARGE

/obj/item/mech_component/manipulators/Destroy()
	QDEL_NULL(motivator)
	. = ..()

/obj/item/mech_component/manipulators/show_missing_parts(mob/user)
	if(!motivator)
		to_chat(user, SPAN_WARNING("It is missing an actuator."))

/obj/item/mech_component/manipulators/ready_to_install()
	return motivator

/obj/item/mech_component/manipulators/prebuild()
	motivator = new(src)

/obj/item/mech_component/manipulators/use_tool(obj/item/thing, mob/living/user, list/click_params)
	if(istype(thing,/obj/item/robot_parts/robot_component/actuator))
		if(motivator)
			to_chat(user, SPAN_WARNING("\The [src] already has an actuator installed."))
			return TRUE
		if(install_component(thing, user))
			motivator = thing
			return TRUE
	else
		return ..()

/obj/item/mech_component/manipulators/update_components()
	motivator = locate() in src

/obj/item/mech_component/manipulators/get_damage_string()
	if(!motivator || !motivator.is_functional())
		return SPAN_DANGER("disabled")
	return ..()

/obj/item/mech_component/manipulators/return_diagnostics(mob/user)
	..()
	if(motivator)
		to_chat(user, SPAN_NOTICE(" Actuator Integrity: <b>[round((((motivator.max_dam - motivator.total_dam) / motivator.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Actuator Missing or Non-functional."))

/obj/item/mech_component/manipulators/powerloader
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 70
	power_use = 30
	desc = "The Xion Industrial Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'

/obj/item/mech_component/manipulators/light
	name = "light arms"
	exosuit_desc_string = "lightweight, segmented manipulators"
	icon_state = "light_arms"
	action_delay = 10
	max_damage = 40
	power_use = 10
	desc = "As flexible as they are fragile, these Vey-Med manipulators can follow a pilot's movements in close to real time."
	punch_sound = 'sound/mecha/mech_punch_fast.ogg'

/obj/item/mech_component/manipulators/heavy
	name = "heavy arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Hephaestus Superheavy Lifter series can take a beating and excel at delivering it."
	punch_sound = 'sound/mecha/mech_punch_slow.ogg'
	action_delay = 20
	melee_damage = 30
	max_damage = 90
	power_use = 60

/obj/item/mech_component/manipulators/combat
	name = "combat arms"
	exosuit_desc_string = "flexible, advanced manipulators"
	icon_state = "combat_arms"
	action_delay = 10
	power_use = 50
