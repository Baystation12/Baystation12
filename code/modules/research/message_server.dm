/datum/data_pda_msg
	var/recipient = "Unspecified" //name of the person
	var/sender = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message

/datum/data_pda_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "")
	if(param_rec)
		recipient = param_rec
	if(param_sender)
		sender = param_sender
	if(param_message)
		message = param_message

/datum/data_rc_msg
	var/rec_dpt = "Unspecified" //name of the person
	var/send_dpt = "Unspecified" //name of the sender
	var/message = "Blank" //transferred message
	var/stamp = "Unstamped"
	var/id_auth = "Unauthenticated"
	var/priority = "Normal"

/datum/data_rc_msg/New(var/param_rec = "",var/param_sender = "",var/param_message = "",var/param_stamp = "",var/param_id_auth = "",var/param_priority)
	if(param_rec)
		rec_dpt = param_rec
	if(param_sender)
		send_dpt = param_sender
	if(param_message)
		message = param_message
	if(param_stamp)
		stamp = param_stamp
	if(param_id_auth)
		id_auth = param_id_auth
	if(param_priority)
		switch(param_priority)
			if(1)
				priority = "Normal"
			if(2)
				priority = "High"
			if(3)
				priority = "Extreme"
			else
				priority = "Undetermined"

/obj/machinery/message_server
	icon = 'stationobjs.dmi'
	icon_state = "server"
	name = "Messaging Server"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100

	var/list/datum/data_pda_msg/pda_msgs = list()
	var/list/datum/data_rc_msg/rc_msgs = list()

/obj/machinery/message_server/proc/send_pda_message(var/recipient = "",var/sender = "",var/message = "")
	pda_msgs += new/datum/data_pda_msg(recipient,sender,message)

/obj/machinery/message_server/proc/send_rc_message(var/recipient = "",var/sender = "",var/message = "",var/stamp = "", var/id_auth = "", var/priority = 1)
	rc_msgs += new/datum/data_rc_msg(recipient,sender,message,stamp,id_auth)

/obj/machinery/message_server/attack_hand(user as mob)
	user << "\blue There seem to be some parts missing from this server. They should arrive on the station in a few days, give or take a few CentCom delays."



/datum/feedback_variable
	var/variable
	var/value
	var/details

	New(var/param_variable,var/param_value = 0)
		variable = param_variable
		value = param_value

	proc/inc(var/num = 1)
		if(isnum(value))
			value += num
		else
			value = text2num(value)
			if(isnum(value))
				value += num
			else
				value = num

	proc/dec(var/num = 1)
		if(isnum(value))
			value -= num
		else
			value = text2num(value)
			if(isnum(value))
				value -= num
			else
				value = -num

	proc/set_value(var/num)
		if(isnum(num))
			value = num

	proc/get_value()
		return value

	proc/get_variable()
		return variable

	proc/set_details(var/text)
		if(istext(text))
			details = text

	proc/add_details(var/text)
		if(istext(text))
			if(!details)
				details = text
			else
				details += " [text]"

	proc/get_details()
		return details

	proc/get_parsed()
		return list(variable,value,details)

var/obj/machinery/blackbox_recorder/blackbox

/obj/machinery/blackbox_recorder
	icon = 'stationobjs.dmi'
	icon_state = "blackbox"
	name = "Blackbox Recorder"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 100
	var/messages = list()
	var/messages_admin = list()

	var/msg_common = list()
	var/msg_science = list()
	var/msg_command = list()
	var/msg_medical = list()
	var/msg_engineering = list()
	var/msg_security = list()
	var/msg_deathsquad = list()
	var/msg_syndicate = list()
	var/msg_mining = list()
	var/msg_cargo = list()

	var/list/datum/feedback_variable/feedback = new()

	//Only one can exsist in the world!
	New()
		if(blackbox)
			if(istype(blackbox,/obj/machinery/blackbox_recorder))
				del(src)
		blackbox = src

	proc/find_feedback_datum(var/variable)
		for(var/datum/feedback_variable/FV in feedback)
			if(FV.get_variable() == variable)
				return FV
		var/datum/feedback_variable/FV = new(variable)
		feedback += FV
		return FV

	proc/get_round_feedback()
		return feedback

	//This proc is only to be called at round end.
	proc/save_all_data_to_sql()
		if(!feedback) return

		var/user = sqlfdbklogin
		var/pass = sqlfdbkpass
		var/db = sqlfdbkdb
		var/address = sqladdress
		var/port = sqlport

		var/DBConnection/dbcon = new()

		dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
		if(!dbcon.IsConnected()) return
		var/round_id

		var/DBQuery/query = dbcon.NewQuery("SELECT MAX(round_id) AS round_id FROM erro_feedback")
		query.Execute()
		while(query.NextRow())
			round_id = query.item[1]

		if(!isnum(round_id))
			round_id = text2num(round_id)
		round_id++

		for(var/datum/feedback_variable/FV in feedback)
			var/sql = "INSERT INTO erro_feedback VALUES (null, Now(), [round_id], \"[FV.get_variable()]\", [FV.get_value()], \"[FV.get_details()]\")"
			var/DBQuery/query_insert = dbcon.NewQuery(sql)
			query_insert.Execute()

		dbcon.Disconnect()

// Sanitize inputs to avoid SQL injection attacks
proc/sql_sanitize_text(var/text)
	text = dd_replacetext(text, "'", "''")
	text = dd_replacetext(text, ";", "")
	text = dd_replacetext(text, "&", "")
	return text

proc/feedback_set(var/variable,var/value)
	if(!blackbox) return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV) return

	FV.set_value(value)

proc/feedback_inc(var/variable,var/value)
	if(!blackbox) return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV) return

	FV.inc(value)

proc/feedback_dec(var/variable,var/value)
	if(!blackbox) return

	variable = sql_sanitize_text(variable)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV) return

	FV.dec(value)

proc/feedback_set_details(var/variable,var/details)
	if(!blackbox) return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV) return

	FV.set_details(details)

proc/feedback_add_details(var/variable,var/details)
	if(!blackbox) return

	variable = sql_sanitize_text(variable)
	details = sql_sanitize_text(details)

	var/datum/feedback_variable/FV = blackbox.find_feedback_datum(variable)

	if(!FV) return

	FV.add_details(details)