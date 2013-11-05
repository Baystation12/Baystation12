/obj/item/device/sps
	name = "Space Positioning System"
	desc = "Helping lost spacemen find their way through the galaxy since 3016."
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	w_class = 2.0
	flags = FPRINT
	slot_flags = SLOT_BELT
	origin_tech = "programming=2;engineering=2"
	var/gpstag = "COM0"
	var/emped = 0

/obj/item/device/sps/New()
	name = "Space Positioning System ([gpstag])"
	overlays += "working"

/obj/item/device/sps/emp_act(severity)
	emped = 1
	overlays -= "working"
	overlays += "emp"
	spawn(300)
		emped = 0
		overlays -= "emp"
		overlays += "working"

/obj/item/device/sps/attack_self(mob/user as mob)
	var/obj/item/device/sps/t = ""
	if(emped)
		t += "ERROR"
	else
		t += "<BR><A href='?src=\ref[src];tag=1'>Set Tag</A> "
		t += "<BR>Tag: [gpstag]"

		for(var/obj/item/device/sps/G in world)
			var/turf/pos = get_turf(G)
			var/area/gps_area = get_area(G)
			var/tracked_gpstag = G.gpstag
			if(G.emped == 1)
				t += "<BR>[tracked_gpstag]: ERROR"
			else
				t += "<BR>[tracked_gpstag]: [format_text(gps_area.name)] ([pos.x], [pos.y], [pos.z])"

	var/datum/browser/popup = new(user, "SPS", name, 600, 450)
	popup.set_content(t)
	popup.set_title_image(user.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()

/obj/item/device/sps/Topic(href, href_list)
	if(href_list["tag"] )
		var/a = input("Please enter desired tag.", name, gpstag) as text
		a = copytext(sanitize(a), 1, 20)
		if(length(a) != 4)
			usr << "\blue The tag must be four letters long!"
			return
		else
			gpstag = a
			name = "Space Positioning System ([gpstag])"
			return

/obj/item/device/sps/science
	icon_state = "gps-s"
	gpstag = "SCI0"

/obj/item/device/sps/engineering
	icon_state = "gps-e"
	gpstag = "ENG0"