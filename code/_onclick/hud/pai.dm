/datum/hud/pai/FinalizeInstantiation()
	adding = list()
	var/obj/screen/using

	using = new /obj/screen/pai/software()
	using.SetName("Software Interface")
	adding += using

	using = new /obj/screen/pai/subsystems()
	using.SetName("Subsystems")
	adding += using

	using = new /obj/screen/pai/shell()
	using.SetName("Toggle Chassis")
	adding += using

	using = new /obj/screen/pai/rest()
	using.SetName("Rest")
	adding += using

	using = new /obj/screen/pai/light()
	using.SetName("Toggle Light")
	adding += using

	mymob.client.screen = list()
	mymob.client.screen += adding
	inventory_shown = 0

/obj/screen/pai
	icon = 'icons/mob/screen/pai.dmi'

/obj/screen/pai/Click()
	if(isobserver(usr) || usr.incapacitated())
		return FALSE
	return TRUE

/obj/screen/pai/software
	name = "Software Interface"
	icon_state = "pai"
	screen_loc = ui_pai_software

/obj/screen/pai/software/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.paiInterface()

/obj/screen/pai/shell
	name = "Toggle Chassis"
	icon_state = "pai_holoform"
	screen_loc = ui_pai_shell

/obj/screen/pai/shell/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	if(pAI.is_in_card)
		pAI.unfold()
	else
		pAI.fold()

/obj/screen/pai/chassis
	name = "Holochassis Appearance Composite"
	icon_state = "pai_holoform"

/obj/screen/pai/rest
	name = "Rest"
	icon_state = "pai_rest"
	screen_loc = ui_pai_rest

/obj/screen/pai/rest/Click()
	var/mob/living/silicon/pai/pAI = usr
	pAI.lay_down()

/obj/screen/pai/light
	name = "Toggle Integrated Lights"
	icon_state = "light"
	screen_loc = ui_pai_light

/obj/screen/pai/light/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.toggle_integrated_light()

/obj/screen/pai/pull
	name = "pull"
	icon_state = "pull1"

/obj/screen/pai/pull/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	pAI.stop_pulling()
	pAI.pullin.screen_loc = null
	pAI.client.screen -= pAI.pullin

/obj/screen/pai/subsystems
	name = "SubSystems"
	icon_state = "subsystems"
	screen_loc = ui_pai_subsystems

/obj/screen/pai/subsystems/Click()
	if(!..())
		return
	var/mob/living/silicon/pai/pAI = usr
	var/ss_name = input(usr, "Activates the given subsystem", "Subsystems", "") in pAI.silicon_subsystems_by_name
	if (!ss_name)
		return

	var/stat_silicon_subsystem/SSS = pAI.silicon_subsystems_by_name[ss_name]
	if(istype(SSS))
		SSS.Click()