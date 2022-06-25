// Screen objects hereon out.
#define MECH_UI_STYLE(X) "<span style=\"font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 5px;\">" + X + "</span>"

/obj/screen/exosuit
	name = "hardpoint"
	icon = 'icons/mecha/mech_hud.dmi'
	icon_state = "base"
	var/mob/living/exosuit/owner
	var/height = 14

/obj/screen/exosuit/radio
	name = "radio"
	maptext = MECH_UI_STYLE("RADIO")
	maptext_x = 5
	maptext_y = 12

/obj/screen/exosuit/radio/Click()
	if(..())
		if(owner.radio)
			owner.radio.attack_self(usr)
		else
			to_chat(usr, SPAN_WARNING("There is no radio installed."))

/obj/screen/exosuit/Initialize()
	. = ..()
	var/mob/living/exosuit/newowner = loc
	if(!istype(newowner))
		return qdel(src)
	owner = newowner

/obj/screen/exosuit/Click()
	return (!usr.incapacitated() && usr.canClick() && (usr == owner || usr.loc == owner))

/obj/screen/exosuit/hardpoint
	name = "hardpoint"
	var/hardpoint_tag
	var/obj/item/holding
	icon_state = "hardpoint"

	maptext_x = 34
	maptext_y = 3
	maptext_width = 72

/obj/screen/exosuit/hardpoint/MouseDrop()
	..()
	if(holding) holding.screen_loc = screen_loc

/obj/screen/exosuit/hardpoint/proc/update_system_info()

	// No point drawing it if we have no item to use or nobody to see it.
	if(!holding || !owner)
		return

	var/has_pilot_with_client = owner.client
	if(!has_pilot_with_client && LAZYLEN(owner.pilots))
		for(var/thing in owner.pilots)
			var/mob/pilot = thing
			if(pilot.client)
				has_pilot_with_client = TRUE
				break
	if(!has_pilot_with_client)
		return

	var/list/new_overlays = list()
	if(!owner.get_cell() || (owner.get_cell().charge <= 0))
		overlays.Cut()
		maptext = ""
		return

	maptext =  SPAN_STYLE("font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;", "[holding.get_hardpoint_maptext()]")

	var/ui_damage = (!owner.body.diagnostics || !owner.body.diagnostics.is_functional() || ((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage)))

	var/value = holding.get_hardpoint_status_value()
	if(isnull(value))
		overlays.Cut()
		return

	if(ui_damage)
		value = -1
		maptext = SPAN_STYLE("font-family: 'Small Fonts'; -dm-text-outline: 1 black; font-size: 7px;", "ERROR")
	else
		if((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage*2))
			if(prob(10))
				value = -1
			else
				value = rand(1,BAR_CAP)
		else
			value = round(value * BAR_CAP)

	// Draw background.
	if(!GLOB.default_hardpoint_background)
		GLOB.default_hardpoint_background = image(icon = 'icons/mecha/mech_hud.dmi', icon_state = "bar_bkg")
		GLOB.default_hardpoint_background.pixel_x = 34
	new_overlays += GLOB.default_hardpoint_background

	if(value == 0)
		if(!GLOB.hardpoint_bar_empty)
			GLOB.hardpoint_bar_empty = image(icon='icons/mecha/mech_hud.dmi',icon_state="bar_flash")
			GLOB.hardpoint_bar_empty.pixel_x = 24
			GLOB.hardpoint_bar_empty.color = "#ff0000"
		new_overlays += GLOB.hardpoint_bar_empty
	else if(value < 0)
		if(!GLOB.hardpoint_error_icon)
			GLOB.hardpoint_error_icon = image(icon='icons/mecha/mech_hud.dmi',icon_state="bar_error")
			GLOB.hardpoint_error_icon.pixel_x = 34
		new_overlays += GLOB.hardpoint_error_icon
	else
		value = min(value, BAR_CAP)
		// Draw statbar.
		if(!LAZYLEN(GLOB.hardpoint_bar_cache))
			for(var/i=0;i<BAR_CAP;i++)
				var/image/bar = image(icon='icons/mecha/mech_hud.dmi',icon_state="bar")
				bar.pixel_x = 24+(i*2)
				if(i>5)
					bar.color = "#00ff00"
				else if(i>1)
					bar.color = "#ffff00"
				else
					bar.color = "#ff0000"
				GLOB.hardpoint_bar_cache += bar
		for(var/i=1;i<=value;i++)
			new_overlays += GLOB.hardpoint_bar_cache[i]
	overlays = new_overlays

/obj/screen/exosuit/hardpoint/Initialize(mapload, var/newtag)
	. = ..()
	hardpoint_tag = newtag
	name = "hardpoint ([hardpoint_tag])"

/obj/screen/exosuit/hardpoint/Click(var/location, var/control, var/params)

	if(!(..()))
		return

	if(!owner?.hatch_closed)
		to_chat(usr, SPAN_WARNING("Error: Hardpoint interface disabled while [owner.body.hatch_descriptor] is open."))
		return

	var/modifiers = params2list(params)
	if(modifiers["ctrl"])
		if(owner.hardpoints_locked)
			to_chat(usr, SPAN_WARNING("Hardpoint ejection system is locked."))
			return
		if(owner.remove_system(hardpoint_tag))
			to_chat(usr, SPAN_NOTICE("You disengage and discard the system mounted to your [hardpoint_tag] hardpoint."))
		else
			to_chat(usr, SPAN_DANGER("You fail to remove the system mounted to your [hardpoint_tag] hardpoint."))
		return

	if(owner.selected_hardpoint == hardpoint_tag)
		icon_state = "hardpoint"
		owner.clear_selected_hardpoint()
	else
		if(owner.set_hardpoint(hardpoint_tag))
			icon_state = "hardpoint_selected"

/obj/screen/exosuit/eject
	name = "eject"
	maptext = MECH_UI_STYLE("EJECT")
	maptext_x = 5
	maptext_y = 12

/obj/screen/exosuit/eject/Click()
	if(..())
		owner.eject(usr)

/obj/screen/exosuit/rename
	name = "rename"
	maptext = MECH_UI_STYLE("RENAME")
	maptext_x = 1
	maptext_y = 12

/obj/screen/exosuit/power
	name = "power"
	icon_state = null

	maptext_width = 64

/obj/screen/exosuit/rename/Click()
	if(..())
		owner.rename(usr)

/obj/screen/exosuit/toggle
	name = "toggle"
	var/toggled = FALSE

/obj/screen/exosuit/toggle/Initialize()
	. = ..()
	queue_icon_update()

/obj/screen/exosuit/toggle/on_update_icon()
	. = ..()
	icon_state = "[initial(icon_state)][toggled ? "_enabled" : ""]"
	maptext = FONT_COLORED(toggled ? COLOR_WHITE : COLOR_GRAY,initial(maptext))

/obj/screen/exosuit/toggle/Click()
	if(..()) toggled()

/obj/screen/exosuit/toggle/proc/toggled()
	toggled = !toggled
	queue_icon_update()
	return toggled

/obj/screen/exosuit/toggle/power_control
	name = "Power control"
	icon_state = "small_important"
	maptext = MECH_UI_STYLE("POWER")
	maptext_x = 3
	maptext_y = 13
	height = 12

/obj/screen/exosuit/toggle/power_control/toggled()
	. = ..()
	owner.toggle_power(usr)

/obj/screen/exosuit/toggle/power_control/on_update_icon()
	toggled = (owner.power == MECH_POWER_ON)
	. = ..()

/obj/screen/exosuit/toggle/air
	name = "air"
	icon_state = "small_important"
	maptext = MECH_UI_STYLE("AIR")
	maptext_x = 9
	maptext_y = 13
	height = 12

/obj/screen/exosuit/toggle/air/toggled()
	owner.use_air = ..()
	to_chat(usr, SPAN_NOTICE("Auxiliary atmospheric system [owner.use_air ? "enabled" : "disabled"]."))

/obj/screen/exosuit/toggle/maint
	name = "toggle maintenance protocol"
	icon_state = "small"
	maptext = MECH_UI_STYLE("MAINT")
	maptext_x = 5
	maptext_y = 13
	height = 12

/obj/screen/exosuit/toggle/maint/toggled()
	owner.maintenance_protocols = ..()
	to_chat(usr, SPAN_NOTICE("Maintenance protocols [owner.maintenance_protocols ? "enabled" : "disabled"]."))

/obj/screen/exosuit/toggle/hardpoint
	name = "toggle hardpoint lock"
	maptext = MECH_UI_STYLE("GEAR")
	maptext_x = 5
	maptext_y = 12

/obj/screen/exosuit/toggle/hardpoint/toggled()
	owner.hardpoints_locked = ..()
	to_chat(usr, SPAN_NOTICE("Hardpoint system access is now [owner.hardpoints_locked ? "disabled" : "enabled"]."))

/obj/screen/exosuit/toggle/hatch
	name = "toggle hatch lock"
	maptext = MECH_UI_STYLE("LOCK")
	maptext_x = 5
	maptext_y = 12

/obj/screen/exosuit/toggle/hatch/toggled()
	if(!owner.hatch_locked && !owner.hatch_closed)
		to_chat(usr, SPAN_WARNING("You cannot lock the hatch while it is open."))
		return
	owner.hatch_locked = ..()
	to_chat(usr, SPAN_NOTICE("The [owner.body.hatch_descriptor] is [owner.hatch_locked ? "now" : "no longer" ] locked."))

/obj/screen/exosuit/toggle/hatch_open
	name = "open or close hatch"
	maptext = MECH_UI_STYLE("CLOSE")
	maptext_x = 4
	maptext_y = 12

/obj/screen/exosuit/toggle/hatch_open/toggled()
	if (!owner)
		return
	if(owner.hatch_locked && owner.hatch_closed)
		to_chat(usr, SPAN_WARNING("You cannot open the hatch while it is locked."))
		return
	owner.hatch_closed = ..()
	to_chat(usr, SPAN_NOTICE("The [owner.body.hatch_descriptor] is now [owner.hatch_closed ? "closed" : "open" ]."))
	owner.update_icon()

/obj/screen/exosuit/toggle/hatch_open/on_update_icon()
	toggled = owner.hatch_closed
	. = ..()
	if(toggled)
		maptext = MECH_UI_STYLE("OPEN")
		maptext_x = 5
	else
		maptext = MECH_UI_STYLE("CLOSE")
		maptext_x = 4

// This is basically just a holder for the updates the exosuit does.
/obj/screen/exosuit/health
	name = "exosuit integrity"
	icon_state = "health"

/obj/screen/exosuit/health/Click()
	if(..())
		if(owner && owner.body && owner.get_cell() && owner.body.diagnostics?.is_functional())
			usr.setClickCooldown(0.2 SECONDS)
			to_chat(usr, SPAN_NOTICE("The diagnostics panel blinks several times as it updates:"))
			playsound(owner.loc,'sound/effects/scanbeep.ogg',30,0)
			for(var/obj/item/mech_component/MC in list(owner.arms, owner.legs, owner.body, owner.head))
				if(MC)
					MC.return_diagnostics(usr)

//Controls if cameras set the vision flags
/obj/screen/exosuit/toggle/camera
	name = "toggle camera matrix"
	icon_state = "small_important"
	maptext = MECH_UI_STYLE("SENSOR")
	maptext_x = 1
	maptext_y = 13
	height = 12

/obj/screen/exosuit/toggle/camera/toggled()
	if(!owner.head)
		to_chat(usr, SPAN_WARNING("I/O Error: Camera systems not found."))
		return
	if(!owner.head.vision_flags)
		to_chat(usr,  SPAN_WARNING("Alternative sensor configurations not found. Contact manufacturer for more details."))
		return
	if(!owner.get_cell())
		to_chat(usr,  SPAN_WARNING("The augmented vision systems are offline."))
		return
	owner.head.active_sensors = ..()
	to_chat(usr, SPAN_NOTICE("[owner.head.name] advanced sensor mode is [owner.head.active_sensors ? "now" : "no longer" ] active."))

/obj/screen/exosuit/toggle/camera/on_update_icon()
	toggled = owner.head.active_sensors
	. = ..()
/obj/screen/exosuit/needle
	vis_flags = VIS_INHERIT_ID
	icon_state = "heatprobe_needle"

/obj/screen/exosuit/heat
	name = "heat probe"
	icon_state = "heatprobe"
	var/celsius = TRUE
	var/obj/screen/exosuit/needle/gauge_needle = null
	desc = "TEST"

/obj/screen/exosuit/heat/Initialize()
	. = ..()
	gauge_needle = new /obj/screen/exosuit/needle(owner)
	vis_contents += gauge_needle

/obj/screen/exosuit/heat/Destroy()
	QDEL_NULL(gauge_needle)
	. = ..()

/obj/screen/exosuit/heat/Click(location, control, params)
	if(..())
		var/modifiers = params2list(params)
		if(modifiers["shift"])
			if(owner && owner.material)
				usr.show_message(SPAN_NOTICE("Your suit's safe operating limit ceiling is [(celsius ? "[owner.material.melting_point - T0C] °C" : "[owner.material.melting_point] K" )]."), VISIBLE_MESSAGE)
			return
		if(modifiers["ctrl"])
			celsius = !celsius
			usr.show_message(SPAN_NOTICE("You switch the chassis probe display to use [celsius ? "celsius" : "kelvin"]."), VISIBLE_MESSAGE)
			return
		if(owner && owner.body && owner.body.diagnostics?.is_functional() && owner.loc)
			usr.show_message(SPAN_NOTICE("The life support panel blinks several times as it updates:"), VISIBLE_MESSAGE)

			usr.show_message(SPAN_NOTICE("Chassis heat probe reports temperature of [(celsius ? "[owner.bodytemperature - T0C] °C" : "[owner.bodytemperature] K" )]."), VISIBLE_MESSAGE)
			if(owner.material.melting_point < owner.bodytemperature)
				usr.show_message(SPAN_WARNING("Warning: Current chassis temperature exceeds operating parameters."), VISIBLE_MESSAGE)
			var/air_contents = owner.loc.return_air()
			if(!air_contents)
				usr.show_message(SPAN_WARNING("The external air probe isn't reporting any data!"), VISIBLE_MESSAGE)
			else
				usr.show_message(SPAN_NOTICE("External probes report: [jointext(atmosanalyzer_scan(owner.loc, air_contents), "<br>")]"), VISIBLE_MESSAGE)
		else
			usr.show_message(SPAN_WARNING("The life support panel isn't responding."), VISIBLE_MESSAGE)

/obj/screen/exosuit/heat/proc/Update()
	//Relative value of heat
	if(owner && owner.body && owner.body.diagnostics?.is_functional() && gauge_needle)
		var/value = clamp( owner.bodytemperature / (owner.material.melting_point * 1.55), 0, 1)
		animate(
			gauge_needle,
			transform = matrix().Update(
				rotation = Interpolate(-90, 90, value),
				offset_y = -2
			),
			time = 0.1,
			easing = SINE_EASING
		)


#undef BAR_CAP
#undef MECH_UI_STYLE
