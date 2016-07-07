/obj/item/clothing/gloves/color
	desc = "A pair of gloves, they don't look special in any way."
	item_state = "lgloves"
	icon_state = "white"

/obj/item/clothing/gloves/color/white
	color = COLOR_WHITE

/obj/item/clothing/gloves/color/insulated
	desc = "These gloves will protect the wearer from electric shock."
	name = "insulated gloves"
	color = COLOR_YELLOW
	siemens_coefficient = 0
	permeability_coefficient = 0.05

/obj/item/clothing/gloves/color/thick
	desc = "These work gloves are thick and fire-resistant."
	name = "thick gloves"
	color = COLOR_DARK_GRAY
	siemens_coefficient = 0.50
	permeability_coefficient = 0.05

	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/color/insulated/cheap                             //Cheap Chinese Crap
	desc = "These gloves are cheap copies of the coveted gloves, no way this can end badly."
	name = "budget insulated gloves"
	siemens_coefficient = 1			//Set to a default of 1, gets overridden in New()
	permeability_coefficient = 0.05
	species_restricted = list("exclude","Unathi","Tajara")
/obj/item/clothing/gloves/color/insulated/cheap/New()
	..()
	//average of 0.5, somewhat better than regular gloves' 0.75
	siemens_coefficient = pick(0,0.1,0.3,0.5,0.5,0.75,1.35)

/obj/item/clothing/gloves/rainbow
	name = "rainbow gloves"
	desc = "A pair of gloves, they don't look special in any way."
	icon_state = "rainbow"
	item_state = "rainbowgloves"

/obj/item/clothing/gloves/evening
	desc = "A pair of gloves that reach past the elbow.  Fancy!"
	name = "evening gloves"
	icon_state = "evening_gloves"
	item_state = "graygloves"

/obj/item/clothing/gloves/forensic
	desc = "Specially made gloves for forensic technicians. The luminescent threads woven into the material stand out under scrutiny."
	name = "forensic gloves"
	icon_state = "forensic"
	item_state = "bgloves"
	siemens_coefficient = 0.50
