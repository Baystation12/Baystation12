// Anti-missile missile intended to take out other missiles
/obj/structure/missile/antispace
	desc = "A GBR-44 missile fitted with the equipment of a predator and the speed of its prey. This missile is specifically designed to safely neutralize other, in-flight missiles."

	equipment = list(
		MISSILE_PART_PAYLOAD = /obj/item/missile_equipment/payload/antimissile,
		MISSILE_PART_THRUSTER = /obj/item/missile_equipment/thruster/hunter/preset
	)
