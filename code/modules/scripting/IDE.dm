client/verb/tcssave()
	set hidden = 1
	if(mob.machine || issilicon(mob))
		if((istype(mob.machine, /obj/machinery/computer/telecomms/traffic) && mob.machine in view(1, mob)) || issilicon(mob))
			var/obj/machinery/computer/telecomms/traffic/Machine = mob.machine
			if(Machine.editingcode != mob)
				return

			if(Machine.SelectedServer)
				var/obj/machinery/telecomms/server/Server = Machine.SelectedServer
				var/tcscode=winget(src, "tcscode", "text")
				var/msg="[mob.name] is adding script to server [Server]: [tcscode]"
				log_misc(msg)
				message_admins("[mob.name] has uploaded a NTLS script to [Machine.SelectedServer] ([mob.x],[mob.y],[mob.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[mob.x];Y=[mob.y];Z=[mob.z]'>JMP</a>)",0,1)
				Server.setcode( tcscode ) // this actually saves the code from input to the server
				src << output(null, "tcserror") // clear the errors
			else
				src << output(null, "tcserror")
				src << output("<font color = red>Failed to save: Unable to locate server machine. (Back up your code before exiting the window!)</font>", "tcserror")
		else
			src << output(null, "tcserror")
			src << output("<font color = red>Failed to save: Unable to locate machine. (Back up your code before exiting the window!)</font>", "tcserror")
	else
		src << output(null, "tcserror")
		src << output("<font color = red>Failed to save: Unable to locate machine. (Back up your code before exiting the window!)</font>", "tcserror")


client/verb/tcscompile()
	set hidden = 1
	if(mob.machine || issilicon(mob))
		if((istype(mob.machine, /obj/machinery/computer/telecomms/traffic) && mob.machine in view(1, mob)) || (issilicon(mob) && istype(mob.machine, /obj/machinery/computer/telecomms/traffic) ))
			var/obj/machinery/computer/telecomms/traffic/Machine = mob.machine
			if(Machine.editingcode != mob)
				return

			if(Machine.SelectedServer)
				var/obj/machinery/telecomms/server/Server = Machine.SelectedServer
				Server.setcode( winget(src, "tcscode", "text") ) // save code first
				var/list/compileerrors = Server.compile() // then compile the code!

				// Output all the compile-time errors
				src << output(null, "tcserror")

				if(compileerrors.len)
					src << output("<b>Compile Errors</b>", "tcserror")
					for(var/scriptError/e in compileerrors)
						src << output("<font color = red>\t>[e.message]</font>", "tcserror")
					src << output("([compileerrors.len] errors)", "tcserror")

					// Output compile errors to all other people viewing the code too
					for(var/mob/M in Machine.viewingcode)
						if(M.client)
							M << output(null, "tcserror")
							M << output("<b>Compile Errors</b>", "tcserror")
							for(var/scriptError/e in compileerrors)
								M << output("<font color = red>\t>[e.message]</font>", "tcserror")
							M << output("([compileerrors.len] errors)", "tcserror")


				else
					src << output("<font color = blue>TCS compilation successful!</font>", "tcserror")
					src << output("(0 errors)", "tcserror")

					for(var/mob/M in Machine.viewingcode)
						if(M.client)
							M << output("<font color = blue>TCS compilation successful!</font>", "tcserror")
							M << output("(0 errors)", "tcserror")

			else
				src << output(null, "tcserror")
				src << output("<font color = red>Failed to compile: Unable to locate server machine. (Back up your code before exiting the window!)</font>", "tcserror")
		else
			src << output(null, "tcserror")
			src << output("<font color = red>Failed to compile: Unable to locate machine. (Back up your code before exiting the window!)</font>", "tcserror")
	else
		src << output(null, "tcserror")
		src << output("<font color = red>Failed to compile: Unable to locate machine. (Back up your code before exiting the window!)</font>", "tcserror")

client/verb/tcsrun()
	set hidden = 1
	if(mob.machine || issilicon(mob))
		if((istype(mob.machine, /obj/machinery/computer/telecomms/traffic) && mob.machine in view(1, mob)) || (issilicon(mob) && istype(mob.machine, /obj/machinery/computer/telecomms/traffic) ))
			var/obj/machinery/computer/telecomms/traffic/Machine = mob.machine
			if(Machine.editingcode != mob)
				return

			if(Machine.SelectedServer)
				var/obj/machinery/telecomms/server/Server = Machine.SelectedServer
				Server.setcode( winget(src, "tcscode", "text") ) // save code first
				var/list/compileerrors = Server.compile() // then compile the code!

				// Output all the compile-time errors
				src << output(null, "tcserror")

				if(compileerrors.len)
					src << output("<b>Compile Errors</b>", "tcserror")
					for(var/scriptError/e in compileerrors)
						src << output("<font color = red>\t>[e.message]</font>", "tcserror")
					src << output("([compileerrors.len] errors)", "tcserror")

					// Output compile errors to all other people viewing the code too
					for(var/mob/M in Machine.viewingcode)
						if(M.client)
							M << output(null, "tcserror")
							M << output("<b>Compile Errors</b>", "tcserror")
							for(var/scriptError/e in compileerrors)
								M << output("<font color = red>\t>[e.message]</font>", "tcserror")
							M << output("([compileerrors.len] errors)", "tcserror")

				else
					// Finally, we run the code!
					src << output("<font color = blue>TCS compilation successful! Code executed.</font>", "tcserror")
					src << output("(0 errors)", "tcserror")

					for(var/mob/M in Machine.viewingcode)
						if(M.client)
							M << output("<font color = blue>TCS compilation successful!</font>", "tcserror")
							M << output("(0 errors)", "tcserror")

					var/datum/signal/signal = new()
					signal.data["message"] = ""
					if(Server.freq_listening.len > 0)
						signal.frequency = Server.freq_listening[1]
					else
						signal.frequency = PUB_FREQ
					signal.data["name"] = ""
					signal.data["job"] = ""
					signal.data["reject"] = 0
					signal.data["server"] = Server

					Server.Compiler.Run(signal)


			else
				src << output(null, "tcserror")
				src << output("<font color = red>Failed to run: Unable to locate server machine. (Back up your code before exiting the window!)</font>", "tcserror")
		else
			src << output(null, "tcserror")
			src << output("<font color = red>Failed to run: Unable to locate machine. (Back up your code before exiting the window!)</font>", "tcserror")
	else
		src << output(null, "tcserror")
		src << output("<font color = red>Failed to run: Unable to locate machine. (Back up your code before exiting the window!)</font>", "tcserror")


client/verb/exittcs()
	set hidden = 1
	if(mob.machine || issilicon(mob))
		if((istype(mob.machine, /obj/machinery/computer/telecomms/traffic) && mob.machine in view(1, mob)) || (issilicon(mob) && istype(mob.machine, /obj/machinery/computer/telecomms/traffic) ))
			var/obj/machinery/computer/telecomms/traffic/Machine = mob.machine
			if(Machine.editingcode == mob)
				Machine.storedcode = "[winget(mob, "tcscode", "text")]"
				Machine.editingcode = null
			else
				if(mob in Machine.viewingcode)
					Machine.viewingcode.Remove(mob)

client/verb/tcsrevert()
	set hidden = 1
	if(mob.machine || issilicon(mob))
		if((istype(mob.machine, /obj/machinery/computer/telecomms/traffic) && mob.machine in view(1, mob)) || (issilicon(mob) && istype(mob.machine, /obj/machinery/computer/telecomms/traffic) ))
			var/obj/machinery/computer/telecomms/traffic/Machine = mob.machine
			if(Machine.editingcode != mob)
				return

			if(Machine.SelectedServer)
				var/obj/machinery/telecomms/server/Server = Machine.SelectedServer

				// Replace quotation marks with quotation macros for proper winset() compatibility
				var/showcode = replacetext(Server.rawcode, "\\\"", "\\\\\"")
				showcode = replacetext(showcode, "\"", "\\\"")

				winset(mob, "tcscode", "text=\"[showcode]\"")

				src << output(null, "tcserror") // clear the errors
			else
				src << output(null, "tcserror")
				src << output("<font color = red>Failed to revert: Unable to locate server machine.</font>", "tcserror")
		else
			src << output(null, "tcserror")
			src << output("<font color = red>Failed to revert: Unable to locate machine.</font>", "tcserror")
	else
		src << output(null, "tcserror")
		src << output("<font color = red>Failed to revert: Unable to locate machine.</font>", "tcserror")


client/verb/tcsclearmem()
	set hidden = 1
	if(mob.machine || issilicon(mob))
		if((istype(mob.machine, /obj/machinery/computer/telecomms/traffic) && mob.machine in view(1, mob)) || (issilicon(mob) && istype(mob.machine, /obj/machinery/computer/telecomms/traffic) ))
			var/obj/machinery/computer/telecomms/traffic/Machine = mob.machine
			if(Machine.editingcode != mob)
				return

			if(Machine.SelectedServer)
				var/obj/machinery/telecomms/server/Server = Machine.SelectedServer
				Server.memory = list() // clear the memory
				// Show results
				src << output(null, "tcserror")
				src << output("<font color = blue>Server memory cleared!</font>", "tcserror")
				for(var/mob/M in Machine.viewingcode)
					if(M.client)
						M << output("<font color = blue>Server memory cleared!</font>", "tcserror")
			else
				src << output(null, "tcserror")
				src << output("<font color = red>Failed to clear memory: Unable to locate server machine.</font>", "tcserror")
		else
			src << output(null, "tcserror")
			src << output("<font color = red>Failed to clear memory: Unable to locate machine.</font>", "tcserror")
	else
		src << output(null, "tcserror")
		src << output("<font color = red>Failed to clear memory: Unable to locate machine.</font>", "tcserror")
