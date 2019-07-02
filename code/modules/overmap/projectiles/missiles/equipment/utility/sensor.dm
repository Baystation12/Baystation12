// Lights up the overmap
/obj/item/missile_equipment/sensor
	name = "sensor probe"
	desc = "A portable sensor probe that provides information about nearby sectors and feeds it back to a designated mothership."
	icon_state = "probe"

	cooldown = 10 SECONDS

	var/sensor_range = 2
	var/power_draw = 30 KILOWATTS // per sensor range
	var/obj/item/weapon/cell/cell

/obj/item/missile_equipment/sensor/Initialize()
	. = ..()
	cell = new(src)


/obj/item/missile_equipment/sensor/attackby(var/obj/item/I, var/mob/user)
	if(isScrewdriver(I) && !isnull(cell))
		user.put_in_hands(cell)
		to_chat(user, SPAN_NOTICE("You remove \the [cell] from \the [src]."))
		cell = null

	if(istype(I, /obj/item/weapon/cell) && isnull(cell))
		if(!user.unEquip(I, src))
			return
		cell = I
		to_chat(user, SPAN_NOTICE("You install \the [cell] into \the [src]."))
	return

	..()

// Make sure the probe stays on the overmap
/obj/item/missile_equipment/sensor/on_missile_activated(var/obj/effect/overmap/projectile/P)
	P.set_enter_zs(FALSE)

/obj/item/missile_equipment/sensor/do_overmap_work(var/obj/effect/overmap/projectile/P)
	if(!..())
		return

	if(isnull(cell) || !cell.checked_use(power_draw*sensor_range*CELLRATE))
		P.set_light(0)
		qdel(in_missile)

	P.set_light(1, sensor_range, sensor_range+1)
