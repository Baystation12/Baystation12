/obj/machinery/computer/forensic_scanning
	name = "high-res forensic scanning computer"
	icon_state = "forensic"

	var/screen = "database"
	var/authenticated = 0
	req_access = list(access_forensics_lockers)
	var/scan_progress = -1
	var/obj/item/scanning
	var/datum/data/record/forensic/current

	var/list/filters = list()
	var/list/current_list = list()

	var/list/files = list()

/obj/machinery/computer/forensic_scanning/proc/get_printable_data(var/datum/data/record/forensic/fresh)
	. += "<h2>[fresh.fields["name"]]</h2>"
	. += "Scanned in [fresh.fields["area"]] at [worldtime2text(fresh.fields["time"])]<br>"
	var/list/prints = fresh.fields["fprints"]
	if(prints.len)
		. += "<h3>Fingerprints:</h3>"
		var/incomplete = 0
		for(var/fullprint in prints)
			var/print = prints[fullprint]
			if(is_complete_print(print))
				. += "[print]<br>"
			else
				incomplete++
		if(incomplete)
			. += "[incomplete] incomplete fingerprints."
	else
		. += "<br>No fingerprints recorded.<br>"

	var/list/fibers = fresh.fields["fibers"]
	if(fibers.len)
		. += "<h3>Fibers:</h3>"
		. += "<ul>"
		for(var/fiber in fibers)
			. += "<li>[fiber]</li>"
		. += "</ul>"
	else
		. += "<br>No fibers recorded."

	var/list/bloods = fresh.fields["blood"]
	if(bloods.len)
		. += "<h3>Blood:</h3>"
		. += "<ul>"
		for(var/blood in bloods)
			. += "<li>DNA: [blood] Type: [bloods[blood]]</li>"
		. += "</ul>"
	else
		. += "<br>No blood recorded."

/obj/machinery/computer/forensic_scanning/proc/add_record(var/datum/data/record/forensic/fresh)
	var/datum/data/record/forensic/old = files[fresh.uid]
	if(old)
		fresh.merge(old)
		fresh.fields["label"] = old.fields["label"]
	files[fresh.uid] = fresh

	//updating partial prints on other things
	var/list/fprints = fresh.fields["fprints"]
	if(fprints.len)
		for(var/id in files)
			var/datum/data/record/forensic/rec = files[id]
			if(rec.update_prints(fprints))
				files[id] = rec

/obj/machinery/computer/forensic_scanning/proc/process_card(var/obj/item/weapon/f_card/card)
	if(card.fingerprints)
		usr << "<span class='notice'>\The [src] sucks in \the [card] and whirrs, scanning it.</span>"
		var/found = 0
		for(var/id in files)
			var/datum/data/record/forensic/rec = files[id]
			found = rec.update_prints(card.fingerprints)
			if (found)
				files[id] = rec
		if(found)
			usr << "<span class='notice'>Complete match found.</span>"
		else
			usr << "<span class='notice'>No match found.</span>"
		return 1
	else
		usr << "<span class='warning'>No fingerprints detected on [card].</span>"
		return 0

//Takes a list of forensic records, with key being reference to object, and updates internal database.
/obj/machinery/computer/forensic_scanning/proc/sync_data(var/list/newdata)
	for(var/id in newdata)
		var/datum/data/record/forensic/fresh = newdata[id]
		add_record(fresh)

/obj/machinery/computer/forensic_scanning/proc/get_filtered_set()
	.= list()
	for(var/id in files)
		var/datum/data/record/forensic/cur = files[id]
		var/add = 1
		if(filters["name"])
			add = 0
			for(var/filter in filters["name"])
				if(findtext(cur.fields["name"], filter))
					add = 1
					break

		if(filters["area"])
			add = 0
			for(var/filter in filters["area"])
				if(findtext(cur.fields["area"], filter))
					add = 1
					break

		if(filters["fprints"])
			add = 0
			var/list/prints = cur.fields["fprints"]
			for(var/pid in prints)
				var/print = prints[pid]
				if (is_complete_print(print))
					for(var/filter in filters["fprints"])
						if(findtext(print, filter))
							add = 1
							break

		if(filters["fibers"])
			add = 0
			for(var/fiber in cur.fields["fibers"])
				for(var/filter in filters["fibers"])
					if(findtext(fiber, filter))
						add = 1
						break

		if(filters["blood"])
			add = 0
			for(var/DNA in cur.fields["blood"])
				for(var/filter in filters["blood"])
					if(findtext(DNA, filter))
						add = 1
						break

		if(filters["label"])
			add = 0
			for(var/filter in filters["label"])
				if(cur.fields["label"] && findtext(cur.fields["label"], filter))
					add = 1
					break
		if (add)
			.+=cur

/obj/machinery/computer/forensic_scanning/attack_hand(mob/user)
	if(..())
		return
	user.set_machine(src)

	var/dat
	if(!authenticated)
		dat += "<a href='?src=\ref[src];operation=login'>{Log In}</a>"
	else
		dat += "<a href='?src=\ref[src];operation=logout'>{Log Out}</a>"
		dat += " | "
		dat += "<a href='?src=\ref[src];operation=screen;screen=database'>Database</a>"
		dat += " | "
		dat += "<a href='?src=\ref[src];operation=screen;screen=details'>Record details</a>"
		dat += " | "
		dat += "<a href='?src=\ref[src];operation=screen;screen=scan'>Scanning</a>"
		dat +="<br><hr><br>"
		switch(screen)
			if("database")	//Database screen
				dat += "Search filters:<br>"
				var/list/filternames = list("Object"="name", "Area"="area", "Fingerprints"="fprints", "Fibers"="fibers", "DNA"="blood", "Label"="label")
				for(var/filter in filternames)
					var/fname = filternames[filter]
					dat += "<br>[filter]: <a href='?src=\ref[src];operation=filter;filter=[fname]'>[filters[fname] ? list2text(filters[fname], ",") : "All"]</a>"

				current_list = get_filtered_set()
				dat+= "<br><hr><br>"
				if(current_list.len < 1)
					dat += "No data matching your request found."
				else
					dat += "<table><tr>"
					dat += "<th>Object</th><th>Area</th><th>Fingerprints</th><th>Fibers</th><th>Blood</th><th>Label</th></tr>"
					for(var/datum/data/record/forensic/record in current_list)
						dat += "<tr><td><a href='?src=\ref[src];operation=details;identifier=[record.uid]'>[record.fields["name"]]</td>"
						dat += "<td>[record.fields["area"]]</td>"
						for(var/criteria in list("fprints", "fibers", "blood"))
							var/list/data = record.fields[criteria]
							dat += "<td>[data.len ? data.len : "None"]</td>"
						dat += "<td>[record.fields["label"] ? record.fields["label"] : ""]</td>"
						dat += "<td><a href='?src=\ref[src];operation=delete;identifier=[record.uid]'>Delete</a></td>"
						dat += "</tr>"
					dat += "</table>"
					dat += "<a href='?src=\ref[src];operation=printall'>Print all listed</a><br>"

			if("details")	//Details screen
				if(!current)
					dat += "<br>NO RECORD SELECTED"
				else
					dat += get_printable_data(current)
					dat += "<br><b>Labels:</b> "
					dat += "<a href='?src=\ref[src];operation=label'>[current.fields["label"] ? current.fields["label"] : "None"]</a><br>"
					dat += "<a href='?src=\ref[src];operation=print'>Print record</a><br>"

			if("scan")	//Scanning screen
				dat += "Object: <a href='?src=\ref[src];operation=object'>[scanning ? scanning.name : "-----"]</a><br>"
				if (scanning)
					if (scan_progress > 0)
						dat += "Scan in progress."
						dat += " <a href='?src=\ref[src];operation=cancel'>Cancel</a><br>"
					else
						dat += "<a href='?src=\ref[src];operation=scan'>Scan</a><br>"
				dat += "Insert fingerprint card here: <a href='?src=\ref[src];operation=card'>-----</a>"

	user << browse(dat,"window=fscanner")
	onclose(user,"fscanner")

/obj/machinery/computer/forensic_scanning/Topic(href,href_list)
	if(..()) return 1
	switch(href_list["operation"])
		if("login")
			var/mob/M = usr
			if(istype(M,/mob/living/silicon) || allowed(M))
				authenticated = 1
		if("logout")
			authenticated = 0
		if("filter")
			var/filterstr = sanitize(input("Input the search criteria. Multiple values can be input, separated by a comma.", "Filter setting") as text|null)
			if(filterstr)
				filters[href_list["filter"]] = text2list(filterstr,",")
			else
				filters[href_list["filter"]] = null
		if("screen")
			screen = href_list["screen"]
		if("details")
			if(href_list["identifier"])
				screen = "details"
				current = files[href_list["identifier"]]
			else
				usr << "<spawn class='warning'>No record found.</span>"
		if("delete")
			if(href_list["identifier"])
				if(alert("Are you sure you want to delete this record?","Record deletion", "Yes", "No") == "Yes")
					files.Remove(href_list["identifier"])
					if(current && current.uid == href_list["identifier"])
						current = null
		if("label")
			if(current)
				var/label = sanitize(input(usr,"Input the label for this record. Multiple values can be input, separated by a comma.", "Labeling record", current.fields["label"]) as text|null)
				current.fields["label"] = label
		if("object")
			if(scanning)
				scanning.loc = get_turf(src)
				scan_progress = -1
				scanning = null
			else
				var/mob/M = usr
				var/obj/item/I = M.get_active_hand()
				if(I && istype(I))
					if(istype(I, /obj/item/weapon/evidencebag))
						scanning = I.contents[1]
						scanning.loc = src
						I.overlays.Cut()
						I.w_class = 1
						I.icon_state = "evidenceobj"
					else
						scanning = I
						M.drop_item()
						I.loc = src
				else
					usr << "<spawn class='warning'>Invalid object, rejected.</span>"
		if("scan")
			if(scanning)
				scan_progress = 10
		if("cancel")
			scan_progress = -1
		if("card")
			var/mob/M = usr
			var/obj/item/I = M.get_active_hand()
			if(istype(I, /obj/item/weapon/f_card))
				if(process_card(I))
					M.drop_item()
					qdel(I)
			else
				usr << "<spawn class='warning'>Invalid fingerprint card, rejected.</span>"
		if("print")
			if(current)
				var/obj/item/weapon/paper/P = new(loc)
				P.name = "\improper Forensics Data ([current.fields["name"]])"
				P.icon_state = "paper_words"
				P.info = "<b>Forensics Database</b> - [worldtime2text(world.time)]<br><br>"
				P.info += get_printable_data(current)
		if("printall")
			var/obj/item/weapon/paper/P = new(loc)
			P.name = "\improper Forensics Data"
			P.icon_state = "paper_words"
			P.info = "<b>Forensics Database</b> - [worldtime2text(world.time)]<br><br>"
			for(var/datum/data/record/forensic/cur in current_list)
				P.info += get_printable_data(cur)

	updateUsrDialog()

/obj/machinery/computer/forensic_scanning/process()
	if (!..())
		return
	if(scanning)
		if(scan_progress > 0)
			scan_progress--
			updateUsrDialog()
		if(scan_progress == 0)
			scan_progress = -1
			ping("Scan complete.")
			var/datum/data/record/forensic/fresh = new(scanning)
			add_record(fresh)
			updateUsrDialog()
