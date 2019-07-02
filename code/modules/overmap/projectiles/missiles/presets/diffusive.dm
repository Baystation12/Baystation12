// Shield diffuser missile
// Everything that needs doing on detonation is done by the diffuser
/obj/structure/missile/diffusive
	name = "CLEARSKY diffuser missile"
	overmap_name = "diffuser missile"
	desc = "A diffuser missile that leaves massive holes in shields for a brief amount of time."

	equipment = list(
		/obj/item/missile_equipment/thruster,
		/obj/item/missile_equipment/autoarm,
		/obj/item/missile_equipment/payload/diffuser
	)
