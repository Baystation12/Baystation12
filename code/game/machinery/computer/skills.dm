//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/skills//TODO:SANITY
	name = "employment records console"
	desc = "Used to view, edit and maintain employment records."
	icon_state = "laptop"
	icon_keyboard = "laptop_key"
	icon_screen = "medlaptop"
	light_color = "#00b000"
	req_one_access = list(access_heads)
	circuit = /obj/item/weapon/circuitboard/skills

	var/obj/item/weapon/card/id/scan = null
	var/authenticated = null
	var/write_access_all = list(access_change_ids)  // access levels required to
	var/write_access_any = list()                   // make changes to rank or job
	var/has_write_access = FALSE  // Is the authenticated user able to change jobs and ranks?

	var/screen = null
	var/datum/data/record/active1 = null
	var/a_id = null
	var/temp = null
	var/printing = null
	var/can_change_id = 0
	var/list/Perp
	var/tempname = null
	//Sorting Variables
	var/sortBy = "name"
	var/order = 1 // -1 = Descending - 1 = Ascending

/obj/machinery/computer/skills/attackby(obj/item/O as obj, var/mob/user)
	if(istype(O, /obj/item/weapon/card/id) && !scan && user.unEquip(O))
		O.loc = src
		scan = O
		to_chat(user, "You insert [O].")
	else
		..()

/obj/machinery/computer/skills/attack_ai(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/skills/attack_hand(mob/user as mob)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/skills/ui_interact(mob/user as mob)
	if (!(src.z in using_map.contact_levels))
		to_chat(user, "<span class='danger'>Unable to establish a connection:</span> You're too far away from the station!")
		return
	var/dat

	if (temp)
		dat = text("<TT>[]</TT><BR><BR><A href='?src=\ref[];choice=Clear Screen'>Clear Screen</A>", temp, src)
	else
		dat = text("Confirm Identity: <A href='?src=\ref[];choice=Confirm Identity'>[]</A><HR>", src, (scan ? text("[]", scan.name) : "----------"))
		if (authenticated)
			switch(screen)
				if(1.0)
					dat += {"
<p style='text-align:center;'>"}
					dat += text("<A href='?src=\ref[];choice=Search Records'>Search Records</A><BR>", src)
					dat += text("<A href='?src=\ref[];choice=New Record (General)'>New Record</A><BR>", src)
					dat += {"
</p>
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>
<th>Records:</th>
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th><A href='?src=\ref[src];choice=Sorting;sort=name'>Name</A></th>
<th><A href='?src=\ref[src];choice=Sorting;sort=id'>ID</A></th>
<th><A href='?src=\ref[src];choice=Sorting;sort=rank'>Position</A></th>
<th><A href='?src=\ref[src];choice=Sorting;sort=fingerprint'>Fingerprints</A></th>
</tr>"}
					if(!isnull(data_core.general))
						for(var/datum/data/record/R in sortRecord(data_core.general, sortBy, order))
							for(var/datum/data/record/E in data_core.security)
							var/background
							dat += text("<tr style=[]><td><A href='?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
							dat += text("<td>[]</td>", R.fields["id"])
							dat += text("<td>[]</td>", R.fields["rank"])
							dat += text("<td>[]</td>", R.fields["fingerprint"])
						dat += "</table><hr width='75%' />"
					dat += text("<A href='?src=\ref[];choice=Record Maintenance'>Record Maintenance</A><br><br>", src)
					dat += text("<A href='?src=\ref[];choice=Log Out'>{Log Out}</A>",src)
				if(2.0)
					dat += "<B>Records Maintenance</B><HR>"
					dat += "<BR><A href='?src=\ref[src];choice=Delete All Records'>Delete All Records</A><BR><BR><A href='?src=\ref[src];choice=Return'>Back</A>"
				if(3.0)
					dat += "<CENTER><B>Employment Record</B></CENTER><BR>"
					if ((istype(active1, /datum/data/record) && data_core.general.Find(active1)))
						var/icon/front = active1.fields["photo_front"]
						var/icon/side = active1.fields["photo_side"]

						var/mil_rank_text = ""

						user << browse_rsc(front, "front.png")
						user << browse_rsc(side, "side.png")
						if(using_map.flags & MAP_HAS_BRANCH)
							mil_rank_text += "Branch: <a href='?src=\ref[src];choice=Edit Field;field=mil_branch'>[active1.fields["mil_branch"] || "None"]</a><br>\n"
						if(using_map.flags & MAP_HAS_RANK)
							mil_rank_text += "Rank: <a href='?src=\ref[src];choice=Edit Field;field=mil_rank'>[active1.fields["mil_rank"] || "None"]</a><br>\n"
						dat += "<table><tr><td>	\
						Name: <A href='?src=\ref[src];choice=Edit Field;field=name'>[active1.fields["name"]]</A><BR> \
						ID: <A href='?src=\ref[src];choice=Edit Field;field=id'>[active1.fields["id"]]</A><BR>\n	\
						Sex: <A href='?src=\ref[src];choice=Edit Field;field=sex'>[active1.fields["sex"]]</A><BR>\n	\
						Age: <A href='?src=\ref[src];choice=Edit Field;field=age'>[active1.fields["age"]]</A><BR>\n	\
						Position: <A href='?src=\ref[src];choice=Edit Field;field=rank'>[active1.fields["rank"]]</A><BR>\n	\
						[mil_rank_text]\
						Fingerprint: <A href='?src=\ref[src];choice=Edit Field;field=fingerprint'>[active1.fields["fingerprint"]]</A><BR>\n	\
						Physical Status: [active1.fields["p_stat"]]<BR>\n	\
						Mental Status: [active1.fields["m_stat"]]<BR><BR>\n	\
						Employment/skills summary:<BR> [decode(active1.fields["notes"])]<BR><BR>\n	\
						Known personal relations:<BR>"
						if(active1.fields["connections"])
							for(var/I in active1.fields["connections"])
								dat += "[I]<br>"
						else
							dat+= "None of interest.<br>"
						dat+="</td><td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4>	\
						<img src=side.png height=80 width=80 border=4></td></tr></table>"
					else
						dat += "<B>General Record Lost!</B><BR>"
					dat += text("\n<A href='?src=\ref[];choice=Delete Record (ALL)'>Delete Record (ALL)</A><BR><BR>\n<A href='?src=\ref[];choice=Print Record'>Print Record</A><BR>\n<A href='?src=\ref[];choice=Return'>Back</A><BR>", src, src, src)
				if(4.0)
					if(!Perp.len)
						dat += text("ERROR.  String could not be located.<br><br><A href='?src=\ref[];choice=Return'>Back</A>", src)
					else
						dat += {"
<table style="text-align:center;" cellspacing="0" width="100%">
<tr>					"}
						dat += text("<th>Search Results for '[]':</th>", tempname)
						dat += {"
</tr>
</table>
<table style="text-align:center;" border="1" cellspacing="0" width="100%">
<tr>
<th>Name</th>
<th>ID</th>
<th>Rank</th>
<th>Fingerprints</th>
</tr>					"}
						for(var/i=1, i<=Perp.len, i += 2)
							var/crimstat = ""
							var/datum/data/record/R = Perp[i]
							if(istype(Perp[i+1],/datum/data/record/))
								var/datum/data/record/E = Perp[i+1]
								crimstat = E.fields["criminal"]
							var/background
							background = "'background-color:#00FF7F;'"
							dat += text("<tr style=[]><td><A href='?src=\ref[];choice=Browse Record;d_rec=\ref[]'>[]</a></td>", background, src, R, R.fields["name"])
							dat += text("<td>[]</td>", R.fields["id"])
							dat += text("<td>[]</td>", R.fields["rank"])
							dat += text("<td>[]</td>", R.fields["fingerprint"])
							dat += text("<td>[]</td></tr>", crimstat)
						dat += "</table><hr width='75%' />"
						dat += text("<br><A href='?src=\ref[];choice=Return'>Return to index.</A>", src)
				else
		else
			dat += text("<A href='?src=\ref[];choice=Log In'>{Log In}</A>", src)
	user << browse(text("<HEAD><TITLE>Employment Records</TITLE></HEAD><TT>[]</TT>", dat), "window=secure_rec;size=600x400")
	onclose(user, "secure_rec")
	return

/*Revised /N
I can't be bothered to look more of the actual code outside of switch but that probably needs revising too.
What a mess.*/
/obj/machinery/computer/skills/Topic(href, href_list)
	if(..())
		return 1
	if (!( data_core.general.Find(active1) ))
		active1 = null
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)
		switch(href_list["choice"])
// SORTING!
			if("Sorting")
				// Reverse the order if clicked twice
				if(sortBy == href_list["sort"])
					if(order == 1)
						order = -1
					else
						order = 1
				else
				// New sorting order!
					sortBy = href_list["sort"]
					order = initial(order)
//BASIC FUNCTIONS
			if("Clear Screen")
				temp = null

			if ("Return")
				screen = 1
				active1 = null

			if("Confirm Identity")
				if (scan)
					if(istype(usr,/mob/living/carbon/human) && !usr.get_active_hand())
						usr.put_in_hands(scan)
					else
						scan.loc = get_turf(src)
					scan = null
				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id) && usr.unEquip(I))
						I.loc = src
						scan = I

			if("Log Out")
				authenticated = null
				screen = null
				active1 = null
				has_write_access = FALSE

			if("Log In")
				var/list/users_access

				if (issilicon(usr) && allowed(usr))
					authenticated = usr.name
					users_access = usr.GetAccess()
				else if (istype(scan, /obj/item/weapon/card/id) && check_access(scan))
					authenticated = scan.registered_name
					users_access = scan.GetAccess()

				if(authenticated)
					active1 = null
					screen = 1
					has_write_access = has_access(write_access_all, write_access_any, users_access)


//RECORD FUNCTIONS
			if("Search Records")
				var/t1 = input("Search String: (Partial Name or ID or Fingerprints or Rank)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || !in_range(src, usr)))
					return
				Perp = new/list()
				t1 = lowertext(t1)
				var/list/components = splittext(t1, " ")
				if(components.len > 5)
					return //Lets not let them search too greedily.
				for(var/datum/data/record/R in data_core.general)
					var/temptext = R.fields["name"] + " " + R.fields["id"] + " " + R.fields["fingerprint"] + " " + R.fields["rank"]
					for(var/i = 1, i<=components.len, i++)
						if(findtext(temptext,components[i]))
							var/prelist = new/list(2)
							prelist[1] = R
							Perp += prelist
				for(var/i = 1, i<=Perp.len, i+=2)
					for(var/datum/data/record/E in data_core.security)
						var/datum/data/record/R = Perp[i]
						if ((E.fields["name"] == R.fields["name"] && E.fields["id"] == R.fields["id"]))
							Perp[i+1] = E
				tempname = t1
				screen = 4

			if("Record Maintenance")
				screen = 2
				active1 = null

			if ("Browse Record")
				var/datum/data/record/R = locate(href_list["d_rec"])
				if (!( data_core.general.Find(R) ))
					temp = "Record Not Found!"
				else
					for(var/datum/data/record/E in data_core.security)
					active1 = R
					screen = 3

/*			if ("Search Fingerprints")
				var/t1 = input("Search String: (Fingerprint)", "Secure. records", null, null)  as text
				if ((!( t1 ) || usr.stat || !( authenticated ) || usr.restrained() || (!in_range(src, usr)) && (!istype(usr, /mob/living/silicon))))
					return
				active1 = null
				t1 = lowertext(t1)
				for(var/datum/data/record/R in data_core.general)
					if (lowertext(R.fields["fingerprint"]) == t1)
						active1 = R
				if (!( active1 ))
					temp = text("Could not locate record [].", t1)
				else
					for(var/datum/data/record/E in data_core.security)
						if ((E.fields["name"] == active1.fields["name"] || E.fields["id"] == active1.fields["id"]))
					screen = 3	*/

			if ("Print Record")
				if (!( printing ))
					printing = 1
					sleep(50)
					var/obj/item/weapon/paper/P = new /obj/item/weapon/paper( loc )
					P.info = "<CENTER><B>Employment Record</B></CENTER><BR>"
					if ((istype(active1, /datum/data/record) && data_core.general.Find(active1)))
						P.info += text("Name: [] ID: []<BR>\nSex: []<BR>\nAge: []<BR>\nFingerprint: []<BR>\nPhysical Status: []<BR>\nMental Status: []<BR>\nEmployment/Skills Summary:<BR>\n[]<BR>", active1.fields["name"], active1.fields["id"], active1.fields["sex"], active1.fields["age"], active1.fields["fingerprint"], active1.fields["p_stat"], active1.fields["m_stat"], decode(active1.fields["notes"]))
					else
						P.info += "<B>General Record Lost!</B><BR>"
					P.info += "</TT>"
					if(active1)
						P.name = "Employment Record ([active1.fields["name"]])"
					else
						P.name = "Employment Record (Unknown/Invald Entry)"
						log_debug("[usr] ([usr.ckey]) attempted to print a null employee record, this should be investigated.")
					printing = null
//RECORD DELETE
			if ("Delete All Records")
				temp = ""
				temp += "Are you sure you wish to delete all Employment records?<br>"
				temp += "<a href='?src=\ref[src];choice=Purge All Records'>Yes</a><br>"
				temp += "<a href='?src=\ref[src];choice=Clear Screen'>No</a>"

			if ("Purge All Records")
				if(PDA_Manifest.len)
					PDA_Manifest.Cut()
				for(var/datum/data/record/R in data_core.security)
					qdel(R)
				temp = "All Employment records deleted."

			if ("Delete Record (ALL)")
				if (active1)
					temp = "<h5>Are you sure you wish to delete the record (ALL)?</h5>"
					temp += "<a href='?src=\ref[src];choice=Delete Record (ALL) Execute'>Yes</a><br>"
					temp += "<a href='?src=\ref[src];choice=Clear Screen'>No</a>"
//RECORD CREATE
			if ("New Record (General)")
				if(PDA_Manifest.len)
					PDA_Manifest.Cut()
				active1 = data_core.CreateGeneralRecord()

//FIELD FUNCTIONS
			if ("Edit Field")
				var/a1 = active1
				switch(href_list["field"])
					if("name")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitizeName(input("Please input name:", "Secure. records", active1.fields["name"], null)  as text)
							if ((!( t1 ) || !length(trim(t1)) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon)))) || active1 != a1)
								return
							active1.fields["name"] = t1
					if("id")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitize(input("Please input id:", "Secure. records", active1.fields["id"], null)  as text)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.fields["id"] = t1
					if("fingerprint")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitize(input("Please input fingerprint hash:", "Secure. records", active1.fields["fingerprint"], null)  as text)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.fields["fingerprint"] = t1
					if("sex")
						if (istype(active1, /datum/data/record))
							if (active1.fields["sex"] == "Male")
								active1.fields["sex"] = "Female"
							else
								active1.fields["sex"] = "Male"
					if("age")
						if (istype(active1, /datum/data/record))
							var/t1 = input("Please input age:", "Secure. records", active1.fields["age"], null)  as num
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.fields["age"] = t1
					if("rank")
						if (has_write_access)
							var/list/options = list("<h5>Position:</h5><ul>")
							for(var/rank in joblist)
								options += "<li><a href='?src=\ref[src];choice=Change Rank;rank=[rank]'>[rank]</a></li>"
							options += "</ul>"

							temp = jointext(options, null)
						else
							alert(usr, "You do not have the required access to change the position field.")

					if("mil_branch")
						if(has_write_access)
							var/list/options = list("<h5>Branch:</h5><ul>")
							for(var/branch in mil_branches.branches)
								options += "<li><a href='?src=\ref[src];choice=change_mil_branch;mil_branch=[branch]'>[branch]</a></li>"
							options += "</ul>"

							temp = jointext(options, null)
						else
							alert(usr, "You do not have the required access to change the branch field.")
					if("mil_rank")
						if(has_write_access)
							var/datum/mil_branch/branch = mil_branches.get_branch(active1.fields["mil_branch"])
							if(!istype(branch))
								alert(usr, "There is currently no branch set.")
							else
								var/list/options = list("<h5>Rank:</h5><ul>")
								for(var/rank in branch.ranks)
									options += "<li><a href='?src=\ref[src];choice=change_mil_rank;mil_rank=[rank]'>[rank]</a></li>"
								options += "</ul>"

								temp = jointext(options, null)
						else
							alert(usr, "You do not have the required access to change the rank field.")
					if("species")
						if (istype(active1, /datum/data/record))
							var/t1 = sanitize(input("Please enter race:", "General records", active1.fields["species"], null)  as message)
							if ((!( t1 ) || !( authenticated ) || usr.stat || usr.restrained() || (!in_range(src, usr) && (!istype(usr, /mob/living/silicon))) || active1 != a1))
								return
							active1.fields["species"] = t1

//TEMPORARY MENU FUNCTIONS
			else if (temp)
				temp=null
				if(active1)
					switch(href_list["choice"])
						if ("Change Rank")
							if(has_write_access)
								active1.fields["rank"] = href_list["rank"]
								if(href_list["rank"] in joblist)
									active1.fields["real_rank"] = href_list["real_rank"]

								if(PDA_Manifest.len)
									PDA_Manifest.Cut()
						if("change_mil_branch")
							if(has_write_access && mil_branches.get_branch(href_list["mil_branch"]))  // Check for name validity
								active1.fields["mil_branch"] = href_list["mil_branch"]
								active1.fields["mil_rank"] = null  // Previous entry may be invalid for new branch

								if(PDA_Manifest.len)
									PDA_Manifest.Cut()

						if("change_mil_rank")
							if(has_write_access && mil_branches.get_rank(active1.fields["mil_branch"], href_list["mil_rank"]))
								active1.fields["mil_rank"] = href_list["mil_rank"]

								if(PDA_Manifest.len)
									PDA_Manifest.Cut()

						if ("Delete Record (ALL) Execute")
							if(PDA_Manifest.len)
								PDA_Manifest.Cut()
							for(var/datum/data/record/R in data_core.medical)
								if ((R.fields["name"] == active1.fields["name"] || R.fields["id"] == active1.fields["id"]))
									qdel(R)
								else
							qdel(active1)
						else
							temp = "This function does not appear to be working at the moment. Our apologies."

	add_fingerprint(usr)
	updateUsrDialog()
	return

/obj/machinery/computer/skills/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/data/record/R in data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields["name"] = "[pick(pick(first_names_male), pick(first_names_female))] [pick(last_names)]"
				if(2)
					R.fields["sex"]	= pick("Male", "Female")
				if(3)
					R.fields["age"] = rand(5, 85)
				if(4)
					R.fields["criminal"] = pick("None", "*Arrest*", "Incarcerated", "Parolled", "Released")
				if(5)
					R.fields["p_stat"] = pick("*Unconcious*", "Active", "Physically Unfit")
					if(PDA_Manifest.len)
						PDA_Manifest.Cut()
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			qdel(R)
			continue

	..(severity)
