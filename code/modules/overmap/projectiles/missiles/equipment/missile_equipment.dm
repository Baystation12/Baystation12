/obj/item/missile_equipment
	name = "missile equipment"
	desc = "an advanced piece of military tech that does stuff for the missile it's fitted in"
	icon = 'icons/obj/missile_equipment.dmi'
	icon_state = "equipment"

	var/next_work = 0
	var/cooldown = 10

// Called when the missile containing this equipment is activated
/obj/item/missile_equipment/proc/on_missile_activated(var/obj/effect/overmap/projectile/P)
	return

// Called when the overmap projectile processes
/obj/item/missile_equipment/proc/do_overmap_work(var/obj/effect/overmap/projectile/P)
	if(world.time < next_work)
		return 0
	next_work = world.time + cooldown
	return 1

// Called before the missile enters the overmap (before the active check, so you have a chance to remove stuff that shouldn't be qdeleted)
/obj/item/missile_equipment/proc/on_touch_map_edge(var/obj/effect/overmap/projectile/P)
	return

// Called to determine if the missile should attempt to enter a level even if it's not in space
/obj/item/missile_equipment/proc/should_enter(var/obj/effect/overmap/O)
	return FALSE

// Called when the missile enters a new Z level. Return a list of XY coordinates to set a target for the missile
/obj/item/missile_equipment/proc/on_enter_level(var/z_level)
	return null

// Called by the missile when it detonates
/obj/item/missile_equipment/proc/on_trigger(var/atom/triggerer)
	return