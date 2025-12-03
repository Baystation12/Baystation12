/obj/item/missile_equipment
	name = "missile equipment"
	desc = "an advanced piece of military tech that does stuff for the missile it's fitted in"
	icon = 'icons/obj/missile_equipment.dmi'
	icon_state = "equipment"
	abstract_type = /obj/item/missile_equipment
	w_class = ITEM_SIZE_LARGE

	/// The slot this equipment fits onto on a missile frame
	var/slot
	/// The next world time when this equipment is due a processing
	var/next_work = 0
	/// How long this piece of equipment takes to process on the overmap
	var/cooldown = 4 SECONDS

/obj/item/missile_equipment/use_tool(obj/item/tool, mob/user)
	if (isMultitool(tool) && can_configure())
		return configure(user)
	return ..()

// Called when the missile containing this equipment is armed
/obj/item/missile_equipment/proc/on_missile_armed(obj/overmap/projectile/overmap_missile)
	return

// Called when the overmap projectile processes
/obj/item/missile_equipment/proc/do_overmap_work(obj/overmap/projectile/overmap_missile)
	if (world.time < next_work)
		return FALSE
	next_work = world.time + cooldown
	return TRUE

// Called before the missile enters the overmap (before the active check, so you have a chance to remove stuff that shouldn't be qdeleted)
/obj/item/missile_equipment/proc/on_touch_map_edge(obj/overmap/projectile/overmap_missile)
	return TRUE

// Called to determine if the missile should attempt to enter a level even if it's not in space
/obj/item/missile_equipment/proc/should_enter(obj/overmap/visitable/overmap_site)
	return FALSE

// Called when the missile enters a new Z level. Return a list of XY coordinates to set a target for the missile
/obj/item/missile_equipment/proc/on_enter_level(z_level)
	return null

// Called by the missile when it detonates
/obj/item/missile_equipment/proc/on_trigger(armed, atom/triggerer)
	return

/obj/item/missile_equipment/proc/can_configure(user)
	return FALSE

/obj/item/missile_equipment/proc/configure(user)
	return TRUE
