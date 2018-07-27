// Screen objects hereon out.
/obj/screen/movable/mecha
	name = "hardpoint"
	icon = 'icons/mecha/mecha_hud.dmi'
	icon_state = "hardpoint"
	var/mob/living/heavy_vehicle/owner

/obj/screen/movable/mecha/radio
	name = "radio"
	icon_state = "radio"

/obj/screen/movable/mecha/radio/Click()
	if(..()) owner.radio.attack_self(usr)

/obj/screen/movable/mecha/New(var/mob/living/heavy_vehicle/newowner)
	if(!istype(newowner))
		return qdel(src)
	owner = newowner

/obj/screen/movable/mecha/Click()
	return (!owner || !usr.incapacitated() && (usr == owner || usr.loc == owner))

/obj/screen/movable/mecha/hardpoint
	name = "hardpoint"
	var/hardpoint_tag
	var/obj/item/holding

	maptext_x = 34
	maptext_y = 3
	maptext_width = 64

/obj/screen/movable/mecha/hardpoint/MouseDrop()
	..()
	if(holding) holding.screen_loc = screen_loc

/obj/screen/movable/mecha/hardpoint/proc/update_system_info()

	// No point drawing it if we have no item to use or nobody to see it.
	if(!holding || !owner || (!owner.client && (!owner.pilot || !owner.pilot.client)))
		return

	overlays.Cut()

	if(!owner.body.cell || (owner.body.cell.charge <= 0))
		return

	maptext = holding.get_hardpoint_maptext()

	var/ui_damage = (!owner.body.diagnostics || !owner.body.diagnostics.is_functional() || ((owner.emp_damage>EMP_GUI_DISRUPT) && prob(owner.emp_damage)))

	var/value = holding.get_hardpoint_status_value()
	if(isnull(value))
		return

	if(ui_damage)
		value = -1
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
		GLOB.default_hardpoint_background = image(icon = 'icons/mecha/mecha_hud.dmi', icon_state = "bar_bkg")
		GLOB.default_hardpoint_background.pixel_x = 34
	overlays |= GLOB.default_hardpoint_background

	if(value == 0)
		if(!GLOB.hardpoint_bar_empty)
			GLOB.hardpoint_bar_empty = image(icon='icons/mecha/mecha_hud.dmi',icon_state="bar_flash")
			GLOB.hardpoint_bar_empty.pixel_x = 24
			GLOB.hardpoint_bar_empty.color = "#ff0000"
		overlays |= GLOB.hardpoint_bar_empty
	else if(value < 0)
		if(!GLOB.hardpoint_error_icon)
			GLOB.hardpoint_error_icon = image(icon='icons/mecha/mecha_hud.dmi',icon_state="bar_error")
			GLOB.hardpoint_error_icon.pixel_x = 34
		overlays |= GLOB.hardpoint_error_icon
	else
		value = min(value, BAR_CAP)
		// Draw statbar.
		if(!LAZYLEN(GLOB.hardpoint_bar_cache))
			for(var/i=0;i<BAR_CAP;i++)
				var/image/bar = image(icon='icons/mecha/mecha_hud.dmi',icon_state="bar")
				bar.pixel_x = 24+(i*2)
				if(i>5)
					bar.color = "#00ff00"
				else if(i>1)
					bar.color = "#ffff00"
				else
					bar.color = "#ff0000"
				GLOB.hardpoint_bar_cache += bar
		for(var/i=i;i<=value;i++)
			overlays |= GLOB.hardpoint_bar_cache[i]

/obj/screen/movable/mecha/hardpoint/New(var/newloc, var/newtag)
	..(newloc)
	hardpoint_tag = newtag
	name = "hardpoint ([hardpoint_tag])"

/obj/screen/movable/mecha/hardpoint/Click(var/location, var/control, var/params)

	if(!(..()))
		return

	var/modifiers = params2list(params)
	if(modifiers["ctrl"])
		if(owner.hardpoints_locked)
			to_chat(usr, "<span class='warning'>Hardpoint ejection system is locked.</span>")
			return
		if(owner.remove_system(hardpoint_tag))
			to_chat(usr, "<span class='notice'>You disengage and discard the system mounted to your [hardpoint_tag] hardpoint.</span>")
		else
			to_chat(usr, "<span class='danger'>You fail to remove the system mounted to your [hardpoint_tag] hardpoint.</span>")
		return

	if(owner.selected_hardpoint == hardpoint_tag)
		icon_state = "hardpoint"
		owner.clear_selected_hardpoint()
	else
		if(owner.set_hardpoint(hardpoint_tag))
			icon_state = "hardpoint_selected"

/obj/screen/movable/mecha/eject
	name = "eject"
	icon_state = "eject"

/obj/screen/movable/mecha/eject/Click()
	if(..())
		owner.eject(usr)

/obj/screen/movable/mecha/toggle
	name = "toggle"
	var/toggled

/obj/screen/movable/mecha/toggle/Click()
	if(..()) toggled()

/obj/screen/movable/mecha/toggle/proc/toggled()
	toggled = !toggled
	icon_state = "[initial(icon_state)][toggled ? "_enabled" : ""]"
	return toggled

/obj/screen/movable/mecha/toggle/maint
	name = "toggle maintenance protocol"
	icon_state = "maint"

/obj/screen/movable/mecha/toggle/maint/toggled()
	owner.maintenance_protocols = ..()
	to_chat(usr, "<span class='notice'>Maintenance protocols [owner.maintenance_protocols ? "enabled" : "disabled"].</span>")

/obj/screen/movable/mecha/toggle/hardpoint
	name = "toggle hardpoint lock"
	icon_state = "hardpoint_lock"

/obj/screen/movable/mecha/toggle/hardpoint/toggled()
	owner.hardpoints_locked = ..()
	to_chat(usr, "<span class='notice'>Hardpoint system access is now [owner.hardpoints_locked ? "disabled" : "enabled"].</span>")

/obj/screen/movable/mecha/toggle/hatch
	name = "toggle hatch lock"
	icon_state = "hatch_lock"

/obj/screen/movable/mecha/toggle/hatch/toggled()
	if(!owner.hatch_locked && !owner.hatch_closed)
		to_chat(usr, "<span class='warning'>You cannot lock the hatch while it is open.</span>")
		return
	owner.hatch_locked = ..()
	to_chat(usr, "<span class='notice'>The [owner.body.hatch_descriptor] is [owner.hatch_locked ? "now" : "no longer" ] locked.</span>")

/obj/screen/movable/mecha/toggle/hatch_open
	name = "open or close hatch"
	icon_state = "hatch_status"

/obj/screen/movable/mecha/toggle/hatch_open/toggled()
	if(owner.hatch_locked && owner.hatch_closed)
		to_chat(usr, "<span class='warning'>You cannot open the hatch while it is locked.</span>")
		return
	owner.hatch_closed = ..()
	to_chat(usr, "<span class='notice'>The [owner.body.hatch_descriptor] is now [owner.hatch_closed ? "closed" : "open" ].</span>")
	owner.update_icon()

// This is basically just a holder for the updates the mech does.
/obj/screen/movable/mecha/health
	name = "mech integrity"
	icon_state = "health"

#undef BAR_CAP