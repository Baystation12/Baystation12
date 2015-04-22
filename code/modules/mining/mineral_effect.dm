/obj/effect/mineral
	name = "mineral vein"
	icon = 'icons/obj/mining.dmi'
	desc = "Shiny."
	mouse_opacity = 0
	density = 0
	anchored = 1
	var/image/scanner_image

/obj/effect/mineral/New(var/newloc, var/ore/M)
	..(newloc)
	name = "[M.display_name] deposit"
	icon_state = "rock_[M.name]"
	var/turf/T = get_turf(src)
	layer = T.layer+0.1

	var/ore/O = ore_data[M.name]
	if(O)
		scanner_image = image(icon, loc = get_turf(src), icon_state = (O.scan_icon ? O.scan_icon : icon_state))