//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/**********************************************************************
						Cyborg Spec Items
***********************************************************************/
/obj/item/borg/overdrive
	name = "overdrive"
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/**********************************************************************
						HUD/SIGHT things
***********************************************************************/
/obj/item/borg/sight
	icon = 'icons/obj/decals.dmi'
	icon_state = "securearea"
	var/sight_mode = null
	var/hud_type


/obj/item/borg/sight/xray
	name = "\proper x-ray vision"
	sight_mode = BORGXRAY


/obj/item/borg/sight/thermal
	name = "\proper thermal vision"
	sight_mode = BORGTHERM
	icon_state = "thermal"
	icon = 'icons/obj/clothing/obj_eyes.dmi'


/obj/item/borg/sight/meson
	name = "\proper meson vision"
	sight_mode = BORGMESON
	icon_state = "meson"
	icon = 'icons/obj/clothing/obj_eyes.dmi'

/obj/item/borg/sight/material
	name = "\proper material scanner vision"
	sight_mode = BORGMATERIAL

/obj/item/borg/sight/hud
	name = "hud"
	var/obj/item/clothing/glasses/hud/hud = null


/obj/item/borg/sight/hud/med
	name = "medical hud"
	icon_state = "healthhud"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	hud_type = HUD_MEDICAL

/obj/item/borg/sight/hud/med/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/health(src)


/obj/item/borg/sight/hud/sec
	name = "security hud"
	icon_state = "securityhud"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	hud_type = HUD_SECURITY

/obj/item/borg/sight/hud/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/security(src)


/obj/item/borg/sight/hud/jani
	name = "janitor hud"
	icon_state = "janihud"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	hud_type = HUD_JANITOR

/obj/item/borg/sight/hud/jani/Initialize()
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/janitor(src)