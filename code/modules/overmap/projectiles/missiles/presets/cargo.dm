/obj/structure/missile/cargo
	name = "PIR7C transporter missile"
	overmap_name = "cargo missile"
	desc = "A missile designed to transport cargo across large distances extremely fast."

	equipment = list(
		/obj/item/missile_equipment/thruster,
		/obj/item/missile_equipment/autoarm,
		/obj/item/missile_equipment/cargo
	)

/obj/structure/missile/cargo/planet
	name = "PIR7OGC transporter missile"
	desc = "A missile designed to transport cargo across large distances extremely fast. This one is designed for groundside delivery to planets."

	equipment = list(
		/obj/item/missile_equipment/thruster/planet,
		/obj/item/missile_equipment/autoarm,
		/obj/item/missile_equipment/cargo
	)
