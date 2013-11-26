/client/proc/epileptic_anomaly()
	set category = "Fun"
	set name = "Epileptic Anomaly(in dev!)"
	if(!check_rights(R_FUN))	return

	var/area/A
	var/color
	var/list/rand = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f")

	A = get_area(usr.loc)
	if(!A)
		return

	if(A.type == /area)
		usr << "<span class='warning'>You can't do it with space!</span>"
		return

	for(var/atom/O in A)
		color = "#" + pick(rand) + pick(rand) + pick(rand) + pick(rand) + pick(rand) + pick(rand)
		O.color = color

	message_admins("[key_name_admin(src)] called color anomaly in [A]", 1)
	log_admin("[key_name(src)] called color anomaly in [A]")

/client/proc/epileptic_anomaly_cancel()
	set category = "Fun"
	set name = "Cancel Epileptic Anomaly"
	if(!check_rights(R_FUN))	return

	var/area/A
	var/color = null

	A = get_area(usr.loc)
	if(!A)
		return

	if(A.type == /area)
		usr << "<span class='warning'>You can't do it with space!</span>"
		return

	for(var/atom/O in A)
		O.color = color

	message_admins("[key_name_admin(src)] trying cancel color anomaly in [A]", 1)
	log_admin("[key_name(src)] trying cancel color anomaly in [A]")