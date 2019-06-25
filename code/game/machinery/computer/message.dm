// Allows you to monitor messages that passes the server.

/obj/machinery/computer/message_monitor
	name = "messaging monitor console"
	desc = "Used to access and maintain data on messaging servers. Allows you to view request console messages."
	icon_screen = "comm_logs"
	light_color = "#00b000"
	var/hack_icon = "error"
	//Server linked to.
	var/obj/machinery/message_server/linkedServer = null
	//Sparks effect - For emag
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread
	//Messages - Saves me time if I want to change something.
	var/noserver = "<span class='alert'>ALERT: No server detected.</span>"
	var/incorrectkey = "<span class='warning'>ALERT: Incorrect decryption key!</span>"
	var/defaultmsg = "<span class='notice'>Welcome. Please select an option.</span>"
	var/rebootmsg = "<span class='warning'>%$&(£: Critical %$$@ Error // !RestArting! <lOadiNg backUp iNput ouTput> - ?pLeaSe wAit!</span>"
	//Computer properties
	var/screen = 0 		// 0 = Main menu, 1 = Message Logs, 2 = Hacked screen, 3 = Custom Message
	var/hacking = 0		// Is it being hacked into by the AI/Cyborg
	var/emag = 0		// When it is emagged.
	var/message = "<span class='notice'>System bootup complete. Please select an option.</span>"	// The message that shows on the main menu.
	var/auth = 0 // Are they authenticated?

/obj/machinery/computer/message_monitor/attackby(obj/item/weapon/O as obj, mob/living/user as mob)
	if(stat & (NOPOWER|BROKEN))
		..()
		return
	if(!istype(user))
		return
	if(isScrewdriver(O) && emag)
		//Stops people from just unscrewing the monitor and putting it back to get the console working again.
		to_chat(user, "<span class='warning'>It is too hot to mess with!</span>")
		return

	..()
	return

/obj/machinery/computer/message_monitor/emag_act(var/remaining_charges, var/mob/user)
	// Will create sparks and print out the console's password. You will then have to wait a while for the console to be back online.
	// It'll take more time if there's more characters in the password..
	if(!emag && operable())
		if(!isnull(src.linkedServer))
			emag = 1
			screen = 2
			spark_system.set_up(5, 0, src)
			src.spark_system.start()
			var/obj/item/weapon/paper/monitorkey/MK = new/obj/item/weapon/paper/monitorkey
			MK.dropInto(loc)
			// Will help make emagging the console not so easy to get away with.
			MK.info += "<br><br><font color='red'>£%@%(*$%&(£&?*(%&£/{}</font>"
			spawn(100*length(src.linkedServer.decryptkey)) UnmagConsole()
			message = rebootmsg
			update_icon()
			return 1
		else
			to_chat(user, "<span class='notice'>A no server error appears on the screen.</span>")

/obj/machinery/computer/message_monitor/on_update_icon()
	if(emag || hacking)
		icon_screen = hack_icon
	else
		icon_screen = initial(icon_screen)
	..()

/obj/machinery/computer/message_monitor/Initialize()
	//Is the server isn't linked to a server, and there's a server available, default it to the first one in the list.
	if(!linkedServer)
		if(message_servers && message_servers.len > 0)
			linkedServer = message_servers[1]
	return ..()

/obj/machinery/computer/message_monitor/interface_interact(user)
	interact(user)
	return TRUE

/obj/machinery/computer/message_monitor/interact(var/mob/living/user)
	//If the computer is being hacked or is emagged, display the reboot message.
	if(hacking || emag)
		message = rebootmsg
	var/list/dat = list()
	dat += "<head><title>Message Monitor Console</title></head><body>"
	dat += "<center><h2>Message Monitor Console</h2></center><hr>"
	dat += "<center><h4><font color='blue'[message]</h5></center>"

	if(auth)
		dat += "<h4><dd><A href='?src=\ref[src];auth=1'>&#09;<font color='green'>\[Authenticated\]</font></a>&#09;/"
		dat += " Server Power: <A href='?src=\ref[src];active=1'>[src.linkedServer && src.linkedServer.active ? "<font color='green'>\[On\]</font>":"<font color='red'>\[Off\]</font>"]</a></h4>"
	else
		dat += "<h4><dd><A href='?src=\ref[src];auth=1'>&#09;<font color='red'>\[Unauthenticated\]</font></a>&#09;/"
		dat += " Server Power: <u>[src.linkedServer && src.linkedServer.active ? "<font color='green'>\[On\]</font>":"<font color='red'>\[Off\]</font>"]</u></h4>"

	if(hacking || emag)
		screen = 2
	else if(!auth || !linkedServer || (linkedServer.stat & (NOPOWER|BROKEN)))
		if(!linkedServer || (linkedServer.stat & (NOPOWER|BROKEN))) message = noserver
		screen = 0

	switch(screen)
		//Main menu
		if(0)
			//&#09; = TAB
			var/i = 0
			dat += "<dd><A href='?src=\ref[src];find=1'>&#09;[++i]. Link To A Server</a></dd>"
			if(auth)
				if(!linkedServer || (linkedServer.stat & (NOPOWER|BROKEN)))
					dat += "<dd><A>&#09;ERROR: Server not found!</A><br></dd>"
				else
					dat += "<dd><A href='?src=\ref[src];viewr=1'>&#09;[++i]. View Request Console Logs </a></br></dd>"
					dat += "<dd><A href='?src=\ref[src];clearr=1'>&#09;[++i]. Clear Request Console Logs</a><br></dd>"
					dat += "<dd><A href='?src=\ref[src];pass=1'>&#09;[++i]. Set Custom Key</a><br></dd>"
			else
				dat += "<br><hr><dd><span class='notice'>Please authenticate with the server in order to show additional options.</span>"
			if((istype(user, /mob/living/silicon/ai) || istype(user, /mob/living/silicon/robot)) && (user.mind.special_role && user.mind.original == user))
				//Malf/Traitor AIs can bruteforce into the system to gain the Key.
				dat += "<dd><A href='?src=\ref[src];hack=1'><i><font color='Red'>*&@#. Bruteforce Key</font></i></font></a></dd>"

		//Hacking screen.
		if(2)
			if(istype(user, /mob/living/silicon/ai) || istype(user, /mob/living/silicon/robot))
				dat += "Brute-forcing for server key.<br> It will take 20 seconds for every character that the password has."
				dat += "In the meantime, this console can reveal your true intentions if you let someone access it. Make sure no humans enter the room during that time."
			else
				//It's the same message as the one above but in binary. Because robots understand binary and humans don't... well I thought it was clever.
				dat += {"01000010011100100111010101110100011001010010110<br>
				10110011001101111011100100110001101101001011011100110011<br>
				10010000001100110011011110111001000100000011100110110010<br>
				10111001001110110011001010111001000100000011010110110010<br>
				10111100100101110001000000100100101110100001000000111011<br>
				10110100101101100011011000010000001110100011000010110101<br>
				10110010100100000001100100011000000100000011100110110010<br>
				10110001101101111011011100110010001110011001000000110011<br>
				00110111101110010001000000110010101110110011001010111001<br>
				00111100100100000011000110110100001100001011100100110000<br>
				10110001101110100011001010111001000100000011101000110100<br>
				00110000101110100001000000111010001101000011001010010000<br>
				00111000001100001011100110111001101110111011011110111001<br>
				00110010000100000011010000110000101110011001011100010000<br>
				00100100101101110001000000111010001101000011001010010000<br>
				00110110101100101011000010110111001110100011010010110110<br>
				10110010100101100001000000111010001101000011010010111001<br>
				10010000001100011011011110110111001110011011011110110110<br>
				00110010100100000011000110110000101101110001000000111001<br>
				00110010101110110011001010110000101101100001000000111100<br>
				10110111101110101011100100010000001110100011100100111010<br>
				10110010100100000011010010110111001110100011001010110111<br>
				00111010001101001011011110110111001110011001000000110100<br>
				10110011000100000011110010110111101110101001000000110110<br>
				00110010101110100001000000111001101101111011011010110010<br>
				10110111101101110011001010010000001100001011000110110001<br>
				10110010101110011011100110010000001101001011101000010111<br>
				00010000001001101011000010110101101100101001000000111001<br>
				10111010101110010011001010010000001101110011011110010000<br>
				00110100001110101011011010110000101101110011100110010000<br>
				00110010101101110011101000110010101110010001000000111010<br>
				00110100001100101001000000111001001101111011011110110110<br>
				10010000001100100011101010111001001101001011011100110011<br>
				10010000001110100011010000110000101110100001000000111010<br>
				001101001011011010110010100101110"}

		//Request Console Logs
		if(4)

			var/index = 0
			/* 	data_rc_msg
				X												 - 5%
				var/rec_dpt = "Unspecified" //name of the person - 15%
				var/send_dpt = "Unspecified" //name of the sender- 15%
				var/message = "Blank" //transferred message		 - 300px
				var/stamp = "Unstamped"							 - 15%
				var/id_auth = "Unauthenticated"					 - 15%
				var/priority = "Normal"							 - 10%
			*/
			dat += "<center><A href='?src=\ref[src];back=1'>Back</a> - <A href='?src=\ref[src];refresh=1'>Refresh</center><hr>"
			dat += {"<table border='1' width='100%'><tr><th width = '5%'>X</th><th width='15%'>Sending Dep.</th><th width='15%'>Receiving Dep.</th>
			<th width='300px' word-wrap: break-word>Message</th><th width='15%'>Stamp</th><th width='15%'>ID Auth.</th><th width='15%'>Priority.</th></tr>"}
			for(var/datum/data_rc_msg/rc in src.linkedServer.rc_msgs)
				index++
				if(index > 3000)
					break
				// Del - Sender   - Recepient - Message
				// X   - Al Green - Your Mom  - WHAT UP!?
				dat += {"<tr><td width = '5%'><center><A href='?src=\ref[src];deleter=\ref[rc]' style='color: rgb(255,0,0)'>X</a></center></td><td width='15%'>[rc.send_dpt]</td>
				<td width='15%'>[rc.rec_dpt]</td><td width='300px'>[rc.message]</td><td width='15%'>[rc.stamp]</td><td width='15%'>[rc.id_auth]</td><td width='15%'>[rc.priority]</td></tr>"}
			dat += "</table>"

	dat += "</body>"
	message = defaultmsg
	var/datum/browser/popup = new(user, "message", "Message Monitoring Console", 700, 700)
	popup.set_content(JOINTEXT(dat))
	popup.open()
	return

/obj/machinery/computer/message_monitor/proc/BruteForce(mob/user as mob)
	if(isnull(linkedServer))
		to_chat(user, "<span class='warning'>Could not complete brute-force: Linked Server Disconnected!</span>")
	else
		var/currentKey = src.linkedServer.decryptkey
		to_chat(user, "<span class='warning'>Brute-force completed! The key is '[currentKey]'.</span>")
	src.hacking = 0
	update_icon()
	src.screen = 0 // Return the screen back to normal

/obj/machinery/computer/message_monitor/proc/UnmagConsole()
	src.emag = 0
	update_icon()

/obj/machinery/computer/message_monitor/Topic(href, href_list)
	if((. = ..()))
		return

	//Authenticate
	if (href_list["auth"])
		if(auth)
			auth = 0
			screen = 0
		else
			var/dkey = trim(input(usr, "Please enter the decryption key.") as text|null)
			if(dkey && dkey != "")
				if(src.linkedServer.decryptkey == dkey)
					auth = 1
				else
					message = incorrectkey

	//Turn the server on/off.
	if (href_list["active"])
		if(auth) linkedServer.active = !linkedServer.active
	//Find a server
	if (href_list["find"])
		if(message_servers && message_servers.len > 1)
			src.linkedServer = input(usr,"Please select a server.", "Select a server.", null) as null|anything in message_servers
			message = "<span class='alert'>NOTICE: Server selected.</span>"
		else if(message_servers && message_servers.len > 0)
			linkedServer = message_servers[1]
			message =  "<span class='notice'>NOTICE: Only Single Server Detected - Server selected.</span>"
		else
			message = noserver

	//Clears the request console logs - KEY REQUIRED
	if (href_list["clearr"])
		if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
			message = noserver
		else
			if(auth)
				src.linkedServer.rc_msgs = list()
				message = "<span class='notice'>NOTICE: Logs cleared.</span>"
	//Change the password - KEY REQUIRED
	if (href_list["pass"])
		if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
			message = noserver
		else
			if(auth)
				var/dkey = trim(input(usr, "Please enter the decryption key.") as text|null)
				if(dkey && dkey != "")
					if(src.linkedServer.decryptkey == dkey)
						var/newkey = trim(input(usr,"Please enter the new key (3 - 16 characters max):"))
						if(length(newkey) <= 3)
							message = "<span class='notice'>NOTICE: Decryption key too short!</span>"
						else if(length(newkey) > 16)
							message = "<span class='notice'>NOTICE: Decryption key too long!</span>"
						else if(newkey && newkey != "")
							src.linkedServer.decryptkey = newkey
						message = "<span class='notice'>NOTICE: Decryption key set.</span>"
					else
						message = incorrectkey

	//Hack the Console to get the password
	if (href_list["hack"])
		if((istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot)) && (usr.mind.special_role && usr.mind.original == usr))
			src.hacking = 1
			src.screen = 2
			update_icon()
			//Time it takes to bruteforce is dependant on the password length.
			spawn(100*length(src.linkedServer.decryptkey))
				if(src && src.linkedServer && usr)
					BruteForce(usr)

	//Delete the request console log.
	if (href_list["deleter"])
		//Are they on the view logs screen?
		if(screen == 4)
			if(!linkedServer || (src.linkedServer.stat & (NOPOWER|BROKEN)))
				message = noserver
			else //if(istype(href_list["delete"], /datum/data_pda_msg))
				src.linkedServer.rc_msgs -= locate(href_list["deleter"])
				message = "<span class='notice'>NOTICE: Log Deleted!</span>"

	//Request Console Logs - KEY REQUIRED
	if(href_list["viewr"])
		if(src.linkedServer == null || (src.linkedServer.stat & (NOPOWER|BROKEN)))
			message = noserver
		else
			if(auth)
				src.screen = 4

	if (href_list["back"])
		src.screen = 0

	return interact(usr)


/obj/item/weapon/paper/monitorkey
	//..()
	name = "Monitor Decryption Key"
	var/obj/machinery/message_server/server = null

/obj/item/weapon/paper/monitorkey/New()
	..()
	spawn(10)
		if(message_servers)
			for(var/obj/machinery/message_server/server in message_servers)
				if(!isnull(server))
					if(!isnull(server.decryptkey))
						info = "<center><h2>Daily Key Reset</h2></center><br>The new message monitor key is '[server.decryptkey]'.<br>This key is only intended for personnel granted access to the messaging server. Keep it safe.<br>If necessary, change the password to a more secure one."
						info_links = info
						icon_state = "paper_words"
						break
