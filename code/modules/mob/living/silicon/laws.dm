/mob/living/silicon/proc/laws_sanity_check()
	if (!src.laws)
		laws = new base_law_type

/mob/living/silicon/proc/set_zeroth_law(var/law, var/law_borg)
	laws_sanity_check()
	laws.set_zeroth_law(law, law_borg)

/mob/living/silicon/proc/add_inherent_law(var/law)
	laws_sanity_check()
	laws.add_inherent_law(law)

/mob/living/silicon/proc/clear_inherent_laws()
	laws_sanity_check()
	laws.clear_inherent_laws()

/mob/living/silicon/proc/clear_ion_laws()
	laws_sanity_check()
	laws.clear_ion_laws()

/mob/living/silicon/proc/add_supplied_law(var/number, var/law)
	laws_sanity_check()
	laws.add_supplied_law(number, law)

/mob/living/silicon/proc/clear_supplied_laws()
	laws_sanity_check()
	laws.clear_supplied_laws()

/mob/living/silicon/proc/statelaws() // -- TLE
	var/prefix = ""
	switch(lawchannel)
		if(MAIN_CHANNEL) prefix = ";"
		if("Binary") prefix = ":b "
		else
			prefix = get_radio_key_from_channel(lawchannel == "Holopad" ? "department" : lawchannel) + " "

	dostatelaws(lawchannel, prefix)

/mob/living/silicon/proc/dostatelaws(var/method, var/prefix)
	if(stating_laws[prefix])
		src << "<span class='notice'>[method]: Already stating laws using this communication method.</span>"
		return

	stating_laws[prefix] = 1

	var/can_state = statelaw("[prefix]Current Active Laws:")

	//src.laws_sanity_check()
	//src.laws.show_laws(world)
	if (can_state && src.laws.zeroth)
		if (src.lawcheck[1] == "Yes") //This line and the similar lines below make sure you don't state a law unless you want to. --NeoFite
			can_state = statelaw("[prefix]0. [src.laws.zeroth]")

	for (var/index = 1, can_state && index <= src.laws.ion.len, index++)
		var/law = src.laws.ion[index]
		var/num = ionnum()
		if (length(law) > 0)
			if (src.ioncheck[index] == "Yes")
				can_state = statelaw("[prefix][num]. [law]")

	var/number = 1
	for (var/index = 1, can_state && index <= src.laws.inherent.len, index++)
		var/law = src.laws.inherent[index]
		if (length(law) > 0)
			if (src.lawcheck[index+1] == "Yes")
				can_state = statelaw("[prefix][number]. [law]")
			number++

	for (var/index = 1, can_state && index <= src.laws.supplied.len, index++)
		var/law = src.laws.supplied[index]
		if (length(law) > 0)
			if(src.lawcheck.len >= number+1)
				if (src.lawcheck[number+1] == "Yes")
					can_state = statelaw("[prefix][number]. [law]")
				number++

	if(!can_state)
		src << "<span class='danger'>[method]: Unable to state laws. Communication method unavailable.</span>"
	stating_laws[prefix] = 0

/mob/living/silicon/proc/statelaw(var/law)
	if(src.say(law))
		sleep(10)
		return 1

	return 0

/mob/living/silicon/proc/checklaws() //Gives you a link-driven interface for deciding what laws the statelaws() proc will share with the crew. --NeoFite
	var/list = "<b>Which laws do you want to include when stating them for the crew?</b><br><br>"


	if (src.laws.zeroth)
		if (!src.lawcheck[1])
			src.lawcheck[1] = "No" //Given Law 0's usual nature, it defaults to NOT getting reported. --NeoFite
		list += {"<A href='byond://?src=\ref[src];lawc=0'>[src.lawcheck[1]] 0:</A> [src.laws.zeroth]<BR>"}

	for (var/index = 1, index <= src.laws.ion.len, index++)
		var/law = src.laws.ion[index]
		if (length(law) > 0)
			if (!src.ioncheck[index])
				src.ioncheck[index] = "Yes"
			list += {"<A href='byond://?src=\ref[src];lawi=[index]'>[src.ioncheck[index]] [ionnum()]:</A> [law]<BR>"}
			src.ioncheck.len += 1

	var/number = 1
	for (var/index = 1, index <= src.laws.inherent.len, index++)
		var/law = src.laws.inherent[index]
		if (length(law) > 0)
			src.lawcheck.len += 1
			if (!src.lawcheck[number+1])
				src.lawcheck[number+1] = "Yes"
			list += {"<A href='byond://?src=\ref[src];lawc=[number]'>[src.lawcheck[number+1]] [number]:</A> [law]<BR>"}
			number++

	for (var/index = 1, index <= src.laws.supplied.len, index++)
		var/law = src.laws.supplied[index]
		if (length(law) > 0)
			src.lawcheck.len += 1
			if (!src.lawcheck[number+1])
				src.lawcheck[number+1] = "Yes"
			list += {"<A href='byond://?src=\ref[src];lawc=[number]'>[src.lawcheck[number+1]] [number]:</A> [law]<BR>"}
			number++

	list += {"<br><A href='byond://?src=\ref[src];lawr=1'>Channel: [src.lawchannel]</A><br>"}
	list += {"<A href='byond://?src=\ref[src];laws=1'>State Laws</A>"}

	usr << browse(list, "window=laws")
