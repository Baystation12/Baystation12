datum/preferences/proc/contentEmployment()
	var/data = {"

		<html><body>

		<nav class='vNav'>
		<ul>
		<li><a href='?src=\ref[src];page=1'>Character</a>
		<li><a href='?src=\ref[src];page=2'>Occupation</a>
		<li><a href='?src=\ref[src];page=3'>Loadout</a>
		<li><a href='?src=\ref[src];page=4'>Local Preferences</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=5'>Medical</a>
		<li><a class='active' href='?src=\ref[src];page=6'>Employment</a>
		<li><a href='?src=\ref[src];page=7'>Security</a>
		<li><hr>
		<li><a href='?src=\ref[src];page=8'>Global Preferences</a>
		</ul>
		</nav>

		<nav class='hNav'>
		<ul>
		<li><a href='?src=\ref[src];save=1'>Save</a>
		<li><a href='?src=\ref[src];load=1'>Load</a>
		<li><a href='?src=\ref[src];delete=1'>Reset</a>
		<li><a href='?src=\ref[src];lock=1'>Lock</a>
		</ul>
		</nav>

		<div class='main'> "}
	if(jobban_isbanned(user, "Records"))
		data += "<span class='danger'>You are banned from using character records.</span><br>"
	else
		if(char_lock)
			data += "Medical Records:<br>"
			data += "[TextPreview(med_record,2000)]<br><br>"
		else
			data += "Medical Records:<br>"
			data += "<a href='?src=\ref[src];set_medical_records=1'>[TextPreview(med_record,2000)]</a><br><br>"
	data += {"
		</div>

		<div class='secondary'>
		</div>

		<div class='background'>
		</div>

		</body></html>

		"}

	return data

/datum/preferences/proc/Topic6(var/href, var/list/href_list)

	if(href_list["page"])
		selected_menu = text2num(href_list["page"])