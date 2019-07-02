// Anti-missile missile intended to take out other missiles
/obj/structure/missile/antispace
	name = "GBR-44 missile"
	overmap_name = "missile"
	desc = "A missile fitted with the equipment of a predator and the speed of its prey. This missile is specifically designed to safely neutralize other, in-flight missiles."

	equipment = list(
		/obj/item/missile_equipment/thruster/hunter,
		/obj/item/missile_equipment/autoarm,
		/obj/item/missile_equipment/payload/antimissile
	)
