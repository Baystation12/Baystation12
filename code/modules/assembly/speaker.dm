/obj/item/device/assembly/speaker
	name = "speaker"
	desc = "Uses the latest voice synthesis technology to project audio."
	icon_state = "speaker"
	matter = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "waste" = 100)

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_CONNECTION
	wire_num = 4

	var/message = "NULL"
	var/voice = "speaker"
	var/list/voice_tones = list("notice", "warning", "danger", "alert", "message", "prefix", "rose")
	var/active_tone = "notice"
	var/activate_on_received = 1

	activate()
		var/turf/T = get_turf(src.loc)
		if(!message || !voice) return
		if(T)
			T.audible_message("\icon[src.icon]<span class='name'>[voice]</span> bleeps, <span class='[active_tone]'>\"[strip_html_properly(message)]\"</span>")

	receive_data(var/list/data, var/obj/item/device/assembly/sender)
		add_debug_log("Received data \[[src]:[data.len]\]")
		if(active_wires & WIRE_MISC_CONNECTION)
			if(active_wires & WIRE_DIRECT_RECEIVE)
				if(data.len)
					var/T = data[1]
					if(isnum(T))
						T = num2text(T)
					if(istext(T))
						message = T
						add_debug_log("\[[src] : Set message to: [T]\]")
						if(data.len > 1)
							var/V = text2num(data[2])
							if(istext(V))
								voice = V
						if(activate_on_received)
							process_activation()
						return 1
					else
						add_debug_log("Error:Incorrect data type")
				else
					add_debug_log("Error: Invalid Data")

		add_debug_log("Failed to receive data! \[[src]\]")
		return 0

	get_data(var/mob/user, var/ui_key)
		var/list/data = list()
		data.Add("Voice", voice, "Message", message, "Tone", active_tone, "Activate When Receiving Data", activate_on_received)
		return data

	get_buttons(var/mob/user, var/ui_key)
		var/list/data = list()
		data.Add("Speak")
		return data

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Voice")
					var/new_voice = input(usr, "What voice would you like the speaker to synthesise?", "Voice")
					if(new_voice)
						voice = sanitizeName(new_voice)
				if("Message")
					var/new_message = input(usr, "What message would you like the speaker to say?", "Voice")
					if(new_message)
						message = new_message
				if("Speak")
					activate()
				if("Tone")
					var/index = voice_tones.Find(active_tone)
					if(!index || index == voice_tones.len)
						usr << "You set \the [src]'s tone to [voice_tones[1]]!"
						active_tone = voice_tones[1]
					else
						var/new_tone = voice_tones[(index+1)]
						if(new_tone)
							usr << "You set \the [src]'s tone to [new_tone]!"
							active_tone = new_tone
		..()

	attackby(var/obj/O, var/mob/user)
		if(istype(O, /obj/item/device/assembly/data_sender))
			user.visible_message("<span class='notice'>\The [user] begins modifying \the [src]..</span>", "<span class='notice'>You begin to modify \the [src]!</span>")
			if(!do_after(user, rand(20, 60))) return
			user << "<span class='notice'>You've successfully modified \the [src]!</span>"
			user.drop_from_inventory(src)
			var/obj/item/device/assembly/speaker/radio/R = new(src.loc)
			user.drop_item()
			src.loc = R
			qdel(src)
			O.loc = R
			qdel(O)