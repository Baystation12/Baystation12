// Destroys missiles that are traveling on the overmap
/obj/item/missile_equipment/payload
	name = "missile payload"
	desc = "dangerous equipment!!"
	slot = MISSILE_PART_PAYLOAD
	abstract_type = /obj/item/missile_equipment/payload
	var/is_dangerous = TRUE
	var/enters_zs = TRUE
	var/missile_name_override = "missile"
	var/missile_overmap_name_override = "missile"
	matter = list(MATERIAL_ALUMINIUM = 2000)

/obj/item/missile_equipment/payload/on_missile_armed(obj/overmap/projectile/overmap_missile)
	overmap_missile.set_dangerous(is_dangerous)
	overmap_missile.set_enter_zs(enters_zs)
