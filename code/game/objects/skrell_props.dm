//Skrell props for awaymissions and ruins featuring Skrell items

//Skrell Lights

/obj/machinery/light/skrell
	name = "skrellian light"
	light_type = /obj/item/light/tube/skrell
	desc = "Some kind of strange alien lighting technology."

/obj/item/light/tube/skrell
	name = "skrellian light filament"
	color = LIGHT_COLOUR_SKRELL
	b_colour = LIGHT_COLOUR_SKRELL
	desc = "Some kind of strange alien lightbulb technology."
	random_tone = FALSE

/obj/item/light/tube/large/skrell
	name = "skrellian light filament"
	color = LIGHT_COLOUR_SKRELL
	b_colour = LIGHT_COLOUR_SKRELL
	desc = "Some kind of strange alien lightbulb technology."

/obj/item/storage/box/lights/tubes/skrell
	name = "box of replacement tubes"
	icon_state = "lighttube"
	startswith = list(/obj/item/light/tube/skrell = 17,
					/obj/item/light/tube/large/skrell = 4)

//Skrell Suit Dispensers

/obj/machinery/suit_storage_unit/skrell
	boots = /obj/item/clothing/shoes/magboots
	color = "#00e1ff"
	helmet = /obj/item/clothing/head/helmet/space/void/skrell/white
	islocked = 1
	name = "Skrell Suit Storage Unit (White)"
	req_access = list("ACCESS_SKRELLSCOUT")
	suit = /obj/item/clothing/suit/space/void/skrell/white

/obj/machinery/suit_storage_unit/skrell/black
	boots = /obj/item/clothing/shoes/magboots
	color = "#00e1ff"
	helmet = /obj/item/clothing/head/helmet/space/void/skrell/black
	islocked = 1
	name = "Skrell Suit Storage Unit (Black)"
	req_access = list("ACCESS_SKRELLSCOUT")
	suit = /obj/item/clothing/suit/space/void/skrell/black

//Skrell Devices

/obj/item/tape_roll/skrell
	name = "modular adhesive dispenser"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	color = "#40e0d0"
	w_class = ITEM_SIZE_SMALL

/obj/machinery/space_heater/skrell
	color = "#40e0d0"
	name = "thermal induction generator"
	desc = "Made by Krri'gli Corp using thermal induction technology, this heater is guaranteed not to set anything, or anyone, on fire."
	set_temperature = T0C+40

/obj/machinery/vending/medical/skrell
	req_access = list(access_skrellscoutship)

/obj/machinery/power/apc/skrell
	req_access = list(access_skrellscoutship)

/obj/machinery/alarm/skrell
	req_access = list(access_skrellscoutship)
	target_temperature = T0C+40

/obj/machinery/alarm/skrell/Initialize()
	. = ..()
	TLV["pressure"] =		list(ONE_ATMOSPHERE*0.80,ONE_ATMOSPHERE*0.90,ONE_ATMOSPHERE*1.30,ONE_ATMOSPHERE*1.40) /* kpa */
	TLV["temperature"] =	list(T0C-26, T0C, T0C+80, T0C+90) // K

/obj/machinery/alarm/skrell/server
	target_temperature = T0C+10

/obj/machinery/alarm/skrell/server/Initialize()
	. = ..()
	TLV["temperature"] =	list(T0C-26, T0C, T0C+30, T0C+40) // K