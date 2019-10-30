/area/soe_argentum/
	name = "Argentum"
	has_gravity = 1
	power_environ = 1
	power_light = 1
	poweralm = 1
	requires_power = 1

/area/soe_argentum/Bridge
	name = "SOE Argentum Bridge"
	icon_state = "bridge"

/area/soe_argentum/engine
	name = "SOE Argentum Engines"
	icon_state = "engine"

/area/soe_argentum/storageroom
	name = "SOE Argentum"
	icon_state = "yellow"

/area/soe_argentum/Messhall
	name = "SOE Argentum Mess Hall"
	icon_state = "kitchen"

/area/soe_argentum/Armory
	name = "SOE Argentum Armory"
	icon_state = "red"

/area/soe_argentum/powercore
	name = "SOE Argentum Engineering"
	icon_state = "engineering"

/area/soe_argentum/portboardingpods
	name = "SOE Argentum Port Boarding Pods"
	icon_state = "Tactical"

/area/soe_argentum/starboardingpods
	name = "SOE Argentum Starboard Boarding Pods"
	icon_state = "Tactical"


/area/soe_argentum/portguns
	name = "Soe Argentum Port Deck Gun"
	icon_state = "red-blue"

/area/soe_argentum/starboardguns
	name = "SOE Argentum Starboard Deck Gun"
	icon_state = "red-blue"



/obj/machinery/overmap_weapon_console/deck_gun_control/local/argentumport
	deck_gun_area = /area/soe_argentum/portguns

/obj/machinery/overmap_weapon_console/deck_gun_control/local/argentumstarboard
	deck_gun_area = /area/soe_argentum/starboardguns