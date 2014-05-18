//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/card
	name = "Identification Computer"
	desc = "You can use this to change ID's."
	icon_state = "id"
	req_access = list(access_change_ids)
	circuit = "/obj/item/weapon/circuitboard/card"
	var/obj/item/weapon/card/id/scan = null
	var/obj/item/weapon/card/id/modify = null
	var/authenticated = 0.0
	var/mode = 0.0
	var/printing = null


/obj/machinery/computer/card/attackby(O as obj, user as mob)//TODO:SANITY
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = O
		if(access_change_ids in idcard.access)
			if(!scan)
				usr.drop_item()
				idcard.loc = src
				scan = idcard
			else if(!modify)
				usr.drop_item()
				idcard.loc = src
				modify = idcard
		else
			if(!modify)
				usr.drop_item()
				idcard.loc = src
				modify = idcard
	else
		..()


/obj/machinery/computer/card/attack_ai(var/mob/user as mob)
	return attack_hand(user)


/obj/machinery/computer/card/attack_paw(var/mob/user as mob)
	return attack_hand(user)


/obj/machinery/computer/card/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	var/dat
	if (!( ticker ))
		return
	if (mode) // accessing crew manifest

		dat += "<h4>Crew Manifest</h4>"
		dat += "Entries cannot be modified from this terminal.<br><br>"
		if(data_core)
			dat += data_core.get_manifest(0) // make it monochrome
		dat += "<br>"
		dat += "<a href='?src=\ref[src];choice=print'>Print</a><br>"
		dat += "<br>"
		dat += "<a href='?src=\ref[src];choice=mode;mode_target=0'>Access ID modification console.</a><br>"

		/*var/crew = ""
		var/list/L = list()
		for (var/datum/data/record/t in data_core.general)
			var/R = t.fields["name"] + " - " + t.fields["rank"]
			L += R
		for(var/R in sortList(L))
			crew += "[R]<br>"*/
		//dat = "<tt><b>Crew Manifest:</b><br>Please use security record computer to modify entries.<br><br>[crew]<a href='?src=\ref[src];choice=print'>Print</a><br><br><a href='?src=\ref[src];choice=mode;mode_target=0'>Access ID modification console.</a><br></tt>"
	else
		var/header = "<div align='center'><b>Identification Card Modifier</b></div>"

		var/target_name
		var/target_owner
		var/target_rank
		if(modify)
			target_name = modify.name
		else
			target_name = "--------"
		if(modify && modify.registered_name)
			target_owner = modify.registered_name
		else
			target_owner = "--------"
		if(modify && modify.assignment)
			target_rank = modify.assignment
		else
			target_rank = "Unassigned"

		var/scan_name
		if(scan)
			scan_name = scan.name
		else
			scan_name = "--------"

		if(!authenticated)
			header += "<br><i>Please insert the cards into the slots</i><br>"
			header += "Target: <a href='?src=\ref[src];choice=modify'>[target_name]</a><br>"
			header += "Confirm Identity: <a href='?src=\ref[src];choice=scan'>[scan_name]</a><br>"
		else
			header += "<div align='center'><br>"
			header += "<a href='?src=\ref[src];choice=modify'>Remove [target_name]</a> || "
			header += "<a href='?src=\ref[src];choice=scan'>Remove [scan_name]</a> <br> "
			header += "<a href='?src=\ref[src];choice=mode;mode_target=1'>Access Crew Manifest</a> || "
			header += "<a href='?src=\ref[src];choice=logout'>Log Out</a></div>"

		header += "<hr>"

		var/jobs_all = ""
		var/counter = 0
		jobs_all += "<table><tr><td></td><td><b>Command</b></td>"

		jobs_all += "</tr><tr height='20'><td><b>Special</b></font></td>"//Captain in special because he is head of heads ~Intercross21
		jobs_all += "<td weight='100'><a href='?src=\ref[src];choice=assign;assign_target=Captain'>Captain</a></td>"
		jobs_all += "<td weight='100'><a href='?src=\ref[src];choice=assign;assign_target=Custom'>Custom</a></td>"

		counter = 0
		jobs_all += "</tr><tr><td><font color='#FFA500'><b>Engineering</b></font></td>"//Orange
		for(var/job in engineering_positions)
			counter++
			if(counter >= 6)
				jobs_all += "</tr><tr height='20'><td></td><td></td>"
				counter = 0
			jobs_all += "<td height='20' weight='100'><a href='?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

		counter = 0
		jobs_all += "</tr><tr height='20'><td><font color='#008000'><b>Medical</b></font></td>"//Green
		for(var/job in medical_positions)
			counter++
			if(counter >= 6)
				jobs_all += "</tr><tr height='20'><td></td><td></td>"
				counter = 0
			jobs_all += "<td weight='100'><a href='?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

		counter = 0
		jobs_all += "</tr><tr height='20'><td><font color='#800080'><b>Science</b></font></td>"//Purple
		for(var/job in science_positions)
			counter++
			if(counter >= 6)
				jobs_all += "</tr><tr height='20'><td></td><td></td>"
				counter = 0
			jobs_all += "<td weight='100'><a href='?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

		counter = 0
		jobs_all += "</tr><tr height='20'><td><font color='#808080'><b>Civilian</b></font></td>"//Grey
		for(var/job in civilian_positions)
			counter++
			if(counter >= 6)
				jobs_all += "</tr><tr height='20'><td></td><td></td>"
				counter = 0
			jobs_all += "<td weight='100'><a href='?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

		if(istype(src,/obj/machinery/computer/card/centcom))
			counter = 0
			jobs_all += "</tr><tr><td><font color='#A52A2A'><b>CentComm</b></font></td>"//Brown
			for(var/job in get_all_centcom_jobs())
				if(counter >= 6)
					jobs_all += "</tr><tr><td></td><td></td>"
					counter = 0
				jobs_all += "<td><a href='?src=\ref[src];choice=assign;assign_target=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

		var/body
		if (authenticated && modify)
			var/carddesc = {"<script type="text/javascript">
								function markRed(){
									var nameField = document.getElementById('namefield');
									nameField.style.backgroundColor = "#FFDDDD";
								}
								function markGreen(){
									var nameField = document.getElementById('namefield');
									nameField.style.backgroundColor = "#DDFFDD";
								}
								function markAccountGreen(){
									var nameField = document.getElementById('accountfield');
									nameField.style.backgroundColor = "#DDFFDD";
								}
								function markAccountRed(){
									var nameField = document.getElementById('accountfield');
									nameField.style.backgroundColor = "#FFDDDD";
								}
								function showAll(){
									var allJobsSlot = document.getElementById('alljobsslot');
									allJobsSlot.innerHTML = "<a href='#' onclick='hideAll()'>hide</a><br>"+ "[jobs_all]";
								}
								function hideAll(){
									var allJobsSlot = document.getElementById('alljobsslot');
									allJobsSlot.innerHTML = "<a href='#' onclick='showAll()'>[(modify.assignment) ? modify.assignment : "Unassgied"]</a>";
								}
							</script>"}
			carddesc += "<form name='cardcomp' action='?src=\ref[src]' method='get'>"
			carddesc += "<input type='hidden' name='src' value='\ref[src]'>"
			carddesc += "<input type='hidden' name='choice' value='reg'>"
			carddesc += "<b>registered_name:</b> <input type='text' id='namefield' name='reg' value='[target_owner]' style='width:250px; background-color:white;' onchange='markRed()'>"
			carddesc += "<input type='submit' value='Rename' onclick='markGreen()'>"
			carddesc += "</form>"

			carddesc += "<form name='accountnum' action='?src=\ref[src]' method='get'>"
			carddesc += "<input type='hidden' name='src' value='\ref[src]'>"
			carddesc += "<input type='hidden' name='choice' value='account'>"
			carddesc += "<b>Stored account number:</b> <input type='text' id='accountfield' name='account' value='[modify.associated_account_number]' style='width:250px; background-color:white;' onchange='markAccountRed()'>"
			carddesc += "<input type='submit' value='Modify' onclick='markAccountGreen()'>"
			carddesc += "</form>"

			carddesc += "<b>Assignment:</b> "
			var/jobs = "<span id='alljobsslot'><a href='#' onclick='showAll()'>[target_rank]</a></span>" //CHECK THIS
			var/accesses = ""
			if(istype(src,/obj/machinery/computer/card/centcom))
				accesses += "<h5>Central Command:</h5>"
				for(var/A in get_all_centcom_access())
					if(A in modify.access)
						accesses += "<a href='?src=\ref[src];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]</font></a> "
					else
						accesses += "<a href='?src=\ref[src];choice=access;access_target=[A];allowed=1'>[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]</a> "
			else
				accesses += "<div align='center'><b>Access</b></div>"
				accesses += "<table style='width:100%'>"
				accesses += "<tr>"
				for(var/i = 1; i <= 7; i++)
					accesses += "<td style='width:14%'><b>[get_region_accesses_name(i)]:</b></td>"
				accesses += "</tr><tr>"
				for(var/i = 1; i <= 7; i++)
					accesses += "<td style='width:14%' valign='top'>"
					for(var/A in get_region_accesses(i))
						if(A in modify.access)
							accesses += "<a href='?src=\ref[src];choice=access;access_target=[A];allowed=0'><font color=\"red\">[replacetext(get_access_desc(A), " ", "&nbsp")]</font></a> "
						else
							accesses += "<a href='?src=\ref[src];choice=access;access_target=[A];allowed=1'>[replacetext(get_access_desc(A), " ", "&nbsp")]</a> "
						accesses += "<br>"
					accesses += "</td>"
				accesses += "</tr></table>"
			body = "[carddesc]<br>[jobs]<br><br>[accesses]" //CHECK THIS
		else
			body = "<a href='?src=\ref[src];choice=auth'>{Log in}</a> <br><hr>"
			body += "<a href='?src=\ref[src];choice=mode;mode_target=1'>Access Crew Manifest</a>"
		dat = "<tt>[header][body]<hr><br></tt>"
	user << browse(dat, "window=id_com;size=900x520")
	onclose(user, "id_com")
	return


/obj/machinery/computer/card/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	switch(href_list["choice"])
		if ("modify")
			if (modify)
				data_core.manifest_modify(modify.registered_name, modify.assignment)
				modify.name = text("[modify.registered_name]'s ID Card ([modify.assignment])")
				if(ishuman(usr))
					modify.loc = usr.loc
					if(!usr.get_active_hand())
						usr.put_in_hands(modify)
					modify = null
				else
					modify.loc = loc
					modify = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = src
					modify = I
			authenticated = 0

		if ("scan")
			if (scan)
				if(ishuman(usr))
					scan.loc = usr.loc
					if(!usr.get_active_hand())
						usr.put_in_hands(scan)
					scan = null
				else
					scan.loc = src.loc
					scan = null
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.loc = src
					scan = I
			authenticated = 0
		if ("auth")
			if ((!( authenticated ) && (scan || (istype(usr, /mob/living/silicon))) && (modify || mode)))
				if (check_access(scan))
					authenticated = 1
			else if ((!( authenticated ) && (istype(usr, /mob/living/silicon))) && (!modify))
				usr << "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in."
		if ("logout")
			authenticated = 0
		if("access")
			if(href_list["allowed"])
				if(authenticated)
					var/access_type = text2num(href_list["access_target"])
					var/access_allowed = text2num(href_list["allowed"])
					if(access_type in (istype(src,/obj/machinery/computer/card/centcom)?get_all_centcom_access() : get_all_accesses()))
						modify.access -= access_type
						if(access_allowed == 1)
							modify.access += access_type
		if ("assign")
			if (authenticated)
				var/t1 = href_list["assign_target"]
				if(t1 == "Custom")
					var/temp_t = copytext(sanitize(input("Enter a custom job assignment.","Assignment")),1,45)
					//let custom jobs function as an impromptu alt title, mainly for sechuds
					if(temp_t && modify)
						modify.assignment = temp_t
				else
					var/datum/job/jobdatum
					for(var/jobtype in typesof(/datum/job))
						var/datum/job/J = new jobtype
						if(ckey(J.title) == ckey(t1))
							jobdatum = J
							break
					if(!jobdatum)
						usr << "\red No log exists for this job."
						return

					modify.access = ( istype(src,/obj/machinery/computer/card/centcom) ? get_centcom_access(t1) : jobdatum.get_access() )
					if (modify)
						modify.assignment = t1
						modify.rank = t1
		if ("reg")
			if (authenticated)
				var/t2 = modify
				//var/t1 = input(usr, "What name?", "ID computer", null)  as text
				if ((authenticated && modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(loc, /turf)))
					var/temp_name = reject_bad_name(href_list["reg"])
					if(temp_name)
						modify.registered_name = temp_name
					else
						src.visible_message("<span class='notice'>[src] buzzes rudely.</span>")
		if ("account")
			if (authenticated)
				var/t2 = modify
				//var/t1 = input(usr, "What name?", "ID computer", null)  as text
				if ((authenticated && modify == t2 && (in_range(src, usr) || (istype(usr, /mob/living/silicon))) && istype(loc, /turf)))
					var/account_num = text2num(href_list["account"])
					modify.associated_account_number = account_num
		if ("mode")
			mode = text2num(href_list["mode_target"])
		if ("print")
			if (!( printing ))
				printing = 1
				sleep(50)
				var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( loc )
				/*var/t1 = "<B>Crew Manifest:</B><BR>"
				var/list/L = list()
				for (var/datum/data/record/t in data_core.general)
					var/R = t.fields["name"] + " - " + t.fields["rank"]
					L += R
				for(var/R in sortList(L))
					t1 += "[R]<br>"*/

				var/t1 = "<h4>Crew Manifest</h4>"
				t1 += "<br>"
				if(data_core)
					t1 += data_core.get_manifest(0) // make it monochrome

				P.info = t1
				P.name = text("Crew Manifest ([])", worldtime2text())
				printing = null
	if (modify)
		modify.name = text("[modify.registered_name]'s ID Card ([modify.assignment])")
	updateUsrDialog()
	return



/obj/machinery/computer/card/centcom
	name = "CentCom Identification Computer"
	circuit = "/obj/item/weapon/circuitboard/card/centcom"
	req_access = list(access_cent_captain)

