/obj/structure/missile/cargo
	desc = "A PIR7-C missile designed to transport cargo across large distances extremely fast."

	equipment = list(
		MISSILE_PART_PAYLOAD = /obj/item/missile_equipment/payload/cargo,
		MISSILE_PART_THRUSTER = /obj/item/missile_equipment/thruster/preset
	)

/obj/structure/missile/cargo/planet
	name = "cargo missile"
	desc = "A PIR7-GC missile designed to transport cargo across large distances extremely fast. This one is designed for groundside delivery to planets."

	equipment = list(
		MISSILE_PART_PAYLOAD = /obj/item/missile_equipment/payload/cargo,
		MISSILE_PART_THRUSTER = /obj/item/missile_equipment/thruster/planet/preset
	)
