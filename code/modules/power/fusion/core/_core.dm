#define MAX_FIELD_STR 10000
#define MIN_FIELD_STR 1

/obj/machinery/power/fusion_core
	name = "\improper R-UST Mk. 8 Tokamak core"
	desc = "An enormous solenoid for generating extremely high power electromagnetic fields. It includes a kinetic energy harvester."
	icon = 'icons/obj/machines/power/fusion_core.dmi'
	icon_state = "core0"
	layer = ABOVE_HUMAN_LAYER
	density = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 50
	active_power_usage = 500 //multiplied by field strength
	anchored = FALSE
	construct_state = /decl/machine_construction/default/panel_closed
	uncreated_component_parts = null
	stat_immune = 0
	base_type = /obj/machinery/power/fusion_core

	var/obj/effect/fusion_em_field/owned_field
	var/field_strength = 1//0.01
	var/initial_id_tag

/obj/machinery/power/fusion_core/mapped
	anchored = TRUE

/obj/machinery/power/fusion_core/Initialize()
	. = ..()
	connect_to_network()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.set_tag(null, initial_id_tag)

/obj/machinery/power/fusion_core/Process()
	if((stat & BROKEN) || !powernet || !owned_field)
		Shutdown()

/obj/machinery/power/fusion_core/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["str"])
		var/dif = text2num(href_list["str"])
		field_strength = min(max(field_strength + dif, MIN_FIELD_STR), MAX_FIELD_STR)
		change_power_consumption(500 * field_strength, POWER_USE_ACTIVE)
		if(owned_field)
			owned_field.ChangeFieldStrength(field_strength)

/obj/machinery/power/fusion_core/proc/Startup()
	if(owned_field)
		return
	owned_field = new(loc, src)
	owned_field.ChangeFieldStrength(field_strength)
	icon_state = "core1"
	update_use_power(POWER_USE_ACTIVE)
	. = 1

/obj/machinery/power/fusion_core/proc/Shutdown(var/force_rupture)
	if(owned_field)
		icon_state = "core0"
		if(force_rupture || owned_field.plasma_temperature > 1000)
			owned_field.Rupture()
		else
			owned_field.RadiateAll()
		qdel(owned_field)
		owned_field = null
	update_use_power(POWER_USE_IDLE)

/obj/machinery/power/fusion_core/proc/AddParticles(var/name, var/quantity = 1)
	if(owned_field)
		owned_field.AddParticles(name, quantity)
		. = 1

/obj/machinery/power/fusion_core/bullet_act(var/obj/item/projectile/Proj)
	if(owned_field)
		. = owned_field.bullet_act(Proj)

/obj/machinery/power/fusion_core/proc/set_strength(var/value)
	value = Clamp(value, MIN_FIELD_STR, MAX_FIELD_STR)
	field_strength = value
	change_power_consumption(5 * value, POWER_USE_ACTIVE)
	if(owned_field)
		owned_field.ChangeFieldStrength(value)

/obj/machinery/power/fusion_core/physical_attack_hand(var/mob/user)
	visible_message("<span class='notice'>\The [user] hugs \the [src] to make it feel better!</span>")
	if(owned_field)
		Shutdown()
	return TRUE

/obj/machinery/power/fusion_core/attackby(var/obj/item/W, var/mob/user)

	if(owned_field)
		to_chat(user,"<span class='warning'>Shut \the [src] off first!</span>")
		return

	if(isMultitool(W))
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.get_new_tag(user)
		return
	
	else if(isWrench(W))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet")
		return

	return ..()

/obj/machinery/power/fusion_core/proc/jumpstart(var/field_temperature)
	field_strength = 501 // Generally a good size.
	Startup()
	if(!owned_field)
		return FALSE
	owned_field.plasma_temperature = field_temperature
	return TRUE

/obj/machinery/power/fusion_core/proc/check_core_status()
	if(stat & BROKEN)
		return FALSE
	if(idle_power_usage > avail())
		return FALSE
	. = TRUE
