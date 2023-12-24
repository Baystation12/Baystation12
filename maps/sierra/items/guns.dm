/obj/item/gun/projectile/revolver/medium/captain
	name = "\improper Final Argument"
	icon = 'maps/sierra/icons/obj/uniques.dmi' // SIERRA TODO: Заменить на спрайт Вольфора, дорисовав анимацию.
	icon_state = "mosley"
	desc = "A shiny al-Maliki & Mosley Autococker automatic revolver, with black accents. Marketed as the 'Revolver for the Modern Era'. This one has 'To the Captain of NSV Sierra' engraved."
	fire_delay = 5.7 //Autorevolver. Also synced with the animation
	fire_anim = "mosley_fire"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	starts_loaded = 0 //Nobody keeps ballistic weapons loaded

/obj/item/gun/energy/stunrevolver/secure/nanotrasen
	name = "corporate stun revolver"
	desc = "This A&M X6 is fitted with an NT1019 chip which allows remote authorization of weapon functionality. It has a NanoTrasen emblem on the grip."
	req_access = list(list(access_brig, access_heads, access_rd))
