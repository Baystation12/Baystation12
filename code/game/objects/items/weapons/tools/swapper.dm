#define BOLT_HEAD "bolt head"
#define CUTTER_HEAD "cutting head"
#define PRY_HEAD "prying head"
#define PULSE_HEAD "electrode head"
#define SCREW_HEAD "screw head"

/obj/item/swapper
	abstract_type = /obj/item/swapper
	name = "the concept of a tool that can swap between multiple heads"
	desc = "This is a master item, berate the admin or mapper that spawned this!"
	icon = 'icons/obj/tools.dmi'
	var/icon_stem = null
	icon_state = "crowbar"
	item_state = null
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	force = 4.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	attack_verb = list("poked")
	sharp = TRUE
	edge = FALSE
	var/list/tool_list = list(BOLT_HEAD, CUTTER_HEAD, PULSE_HEAD, PRY_HEAD, SCREW_HEAD)
	var/active_tool = BOLT_HEAD
	var/previous_tool = 1

/obj/item/swapper/istool()
	return TRUE

/obj/item/swapper/IsCrowbar()
	return (active_tool == PRY_HEAD)

/obj/item/swapper/IsMultitool()
	return (active_tool == PULSE_HEAD)

/obj/item/swapper/IsScrewdriver()
	return (active_tool == SCREW_HEAD)

/obj/item/swapper/IsWirecutter()
	return (active_tool == CUTTER_HEAD)

/obj/item/swapper/IsWrench()
	return (active_tool == BOLT_HEAD)

/obj/item/swapper/attack_self(mob/user)
	var/tool_index = tool_list.Find(active_tool)
	previous_tool = tool_index
	tool_index = tool_index + 1
	if (tool_index > length(tool_list))
		tool_index = 1
	active_tool = tool_list[tool_index]
	to_chat(user, SPAN_NOTICE("You attach the [active_tool] to [src]."))
	playsound(src, 'sound/items/Ratchet.ogg', 10, 1)
	update_icon()
	if (active_tool == PRY_HEAD || PULSE_HEAD) //this is mostly to stop people accidentally engraving reinforced walls
		sharp = FALSE
	else
		sharp = TRUE
	if (active_tool == CUTTER_HEAD)
		edge = TRUE
		sharp = TRUE
	else
		edge = FALSE

/obj/item/swapper/on_update_icon()
	overlays -= "[icon_state]_[replacetext_char((tool_list[previous_tool]), " ", "_")]"

	overlays += "[icon_state]_[replacetext_char(active_tool, " ", "_")]"

/obj/item/swapper/power_drill
	name = "hand drill"
	desc = "The Xion Industries DF692 is a cordless drill driver that uses a series of dynamos and other power generation technologies to have effectively zero power consumption. Screw and bolt heads included."
	active_tool = SCREW_HEAD
	icon_state = "p_drill"
	item_state = "power_drill"
	throw_speed = 2
	throw_range = 3//it's heavier than a screw driver/wrench, so it can't be thrown as far
	attack_verb = list("drilled", "stabbed")
	w_class = ITEM_SIZE_NORMAL
	force = 12.0
	throwforce = 5.0
	center_of_mass = "x=16;y=7"
	hitsound = 'sound/weapons/circsawhit.ogg'
	toolspeed = 0.5
	lock_picking_level = 2
	origin_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4)
	matter = list(MATERIAL_STEEL = 75, MATERIAL_PLASTIC = 1000)
	tool_list = list(BOLT_HEAD, SCREW_HEAD)

/obj/item/swapper/jaws_of_life
	name = "hydraulic prying tool"
	desc = "The Xion Industries EVAHT6 is a hydraulic rescue tool that uses several advances in pumping technology to pry apart or cut metal beams with kilonewtons of force from an integrated water supply. Prying and cutting heads included."
	active_tool = PRY_HEAD
	icon_state = "hydraulicprytool"
	item_state = "toolbox_yellow"
	throw_speed = 1
	throw_range = 2
	attack_verb = list("crushed", "sliced")
	w_class = ITEM_SIZE_NORMAL
	force = 20.0
	attack_cooldown = 30.0
	throwforce = 8.0
	hitsound = 'sound/items/jaws_pry.ogg'
	toolspeed = 0.5
	origin_tech = list(TECH_ENGINEERING = 5, TECH_POWER = 4)
	matter = list(MATERIAL_STEEL = 1000, MATERIAL_PLASTIC = 500)
	tool_list = list(PRY_HEAD, CUTTER_HEAD)
