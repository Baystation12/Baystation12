// Shield diffuser missile
// Everything that needs doing on detonation is done by the diffuser
/obj/structure/missile/diffusive
	desc = "A CLEARSKY diffuser missile that leaves massive holes in shields for a brief amount of time."

	equipment = list(
		MISSILE_PART_PAYLOAD = /obj/item/missile_equipment/payload/diffuser,
		MISSILE_PART_THRUSTER = /obj/item/missile_equipment/thruster/preset
	)
