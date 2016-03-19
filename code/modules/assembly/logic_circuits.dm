/obj/item/device/assembly/logic_circuit
	name = "logic circuit"
	desc = "A logic chip. You feel an odd urge to deepy fry and salt it."
	icon_state = "logic"
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION
	wire_num = 6
	var/list/operations = list()
	var/operation
	var/list/applicable_categories = list("Numeric", "Quotational", "Smart")
	var/list/applicable_changes = list("Numeric", "Tester", "Numeric", "Operator", "Quotational", "Tester", "Qutational", "Operator", "Smart", "Smart", "Smart", "Electrical")

	var/value1 = -1
	var/value2 = -1
	var/value3 = "ACTIVATE"

	var/last_value_set = null
	var/user_value_set = null

	var/activate_on_received = 1
	var/else_connection = 0
	var/else_connection_name = "NULL"
	var/list/else_send_values = list("Value One", "Value Two", "Sending Data")
	var/else_send_value = "Sending Data"

/obj/item/device/assembly/logic_circuit/New()
	..()
	if(operations.len)
		operation = operations[1]

/obj/item/device/assembly/logic_circuit/holder_attach()
	return 0

/obj/item/device/assembly/logic_circuit/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Operator")
				if(operations.len && operation)
					var/index = operations.Find(operation)
					if(index == operations.len)
						operation = operations[1]
					else
						operation = operations[(index+1)]
					usr << "<span class='notice'>You set \the [src]'s operation to: \"[operation]\"!</span>"
			if("Value One")
				var/inp = input(usr, "What value would you like to set?", "Value")
				if(inp)
					value1 = set_value(inp)
					user_value_set = value1
			if("Value Two")
				var/inp = input(usr, "What value would you like to set?", "Value")
				if(inp)
					value2 = set_value(inp)
					user_value_set = value2
			if("Sending Data")
				var/inp = input(usr, "What value would you like to send?", "Value")
				if(inp)
					if(findtext(inp, "\[value1\]"))
						value3 = value1
					else if(findtext(inp, "\[value2\]"))
						value3 = value2
					else
						value3 = inp
			if("Reset Data")
				value1 = initial(value1)
				value2 = initial(value2)
				value3 = initial(value3)
				user_value_set = null
				last_value_set = null
				else_connection = 0
				else_connection_name = "NULL"
			if("Else if connection")
				add_debug_log("Setting else!")
				if(!holder)
					usr << "There's nothing you can connect \the [src] to!"
				else
					var/list/devices = list()
					for(var/i=1,i<=holder.connected_devices.len,i++)
						var/obj/item/device/assembly/A = holder.connected_devices[i]
						if(A == src) continue
						if(i in connects_to || i == else_connection) continue
						devices.Add(A)
					var/obj/item/device/assembly/connect_to = input(usr, "What device would you like to connect to?", "Connection") in devices
					var/index = get_device_index(connect_to)
					add_debug_log("Got: [connect_to.name] Index: [index]")
					if(num2text(index) == else_connection || num2text(index) in connects_to)
						usr << "<span class='warning'> \The [src] is already connected to \the [connect_to.name]</span>"
					else if(index)
						add_debug_log("Index does exist! \[[src] : [usr]\]")
						if(connect_to != src)
							else_connection = text2num(index)
							usr << "<span class='notice'>You set \the [src]'s alternate connection to [connect_to.name]!</span>"
							else_connection_name = connect_to.name
						else
							usr << "<span class='warning'>You cannot connect \the [src] to itself!</span>"
			if("Else Send Data")
				var/index = else_send_values.Find(else_send_value)
				if(!index || index == else_send_values.len) index = 1
				else index += 1
				else_send_value = else_send_values[index]
				usr << "<span class='notice'>You set \the [src]'s alternate send data to [else_send_value]!</span>"

	..()

/obj/item/device/assembly/logic_circuit/proc/failed()
	if(holder && else_connection)
		var/obj/item/device/assembly/A = holder.connected_devices[else_connection]
		if(A && istype(A))
			switch(else_send_value)
				if("Value One")
					A.process_receive_data(list(value1), src)
				if("Value Two")
					A.process_receive_data(list(value2), src)
				if("Sending Data")
					A.process_receive_data(list(value3), src)

/obj/item/device/assembly/logic_circuit/attackby(var/obj/O, var/mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers/food/condiment/saltshaker))
		if(findtext("salty", name))
			user << "<span class='notice'>\The [src] is already salted!</span>"
		user << "<span class='notice'>You salt \the [src]!</span>"
		name = "salty [name]"
	if(istype(O, /obj/item/weapon/screwdriver))
		var/inp = input(user, "What category would you like to change to?", "Category") in applicable_categories
		sleep(0)
		if(inp)
			sleep(10)
			var/list/choices = list()
			if(applicable_changes.len)
				for(var/i=1,i<=applicable_changes.len,i++)
					if(i % 2 == 1)
						if(applicable_changes[i] == inp)
							choices += applicable_changes[(i+1)]
			var/inp2 = input(user, "What type would you like to change to?", "Type") in choices
			var/obj/item/device/assembly/logic_circuit/created
			switch(inp)
				if("Numeric")
					switch(inp2)
						if("Tester")
							created = new /obj/item/device/assembly/logic_circuit/tester/numeric
						if("Operator")
							created = new /obj/item/device/assembly/logic_circuit/operator/numeric
				if("Quotational")
					switch(inp2)
						if("Tester")
							created = new /obj/item/device/assembly/logic_circuit/tester/string
						if("Operator")
							created = new /obj/item/device/assembly/logic_circuit/operator/string
				if("Smart")
					switch(inp2)
						if("Smart")
							created = new /obj/item/device/assembly/logic_circuit/smart
						if("Electrical")
							created = new /obj/item/device/assembly/logic_circuit/smart/electrical
			if(istype(created))
				if(src.value3)
					created.value3 = src.value3
				user.drop_from_inventory(src)
				created.forceMove(get_turf(src))
				user << "<span class='notice'>You've changed \the [src] to a [created.name]</span>"
				qdel(src)
				return 1
		else
			user << "Invalid choice!"

/obj/item/device/assembly/logic_circuit/get_data()
	var/list/data = list()
	data.Add("Operator", operation, "Else if connection", else_connection_name, "Value One", value1, "Value Two", value2, "Sending Data", value3, "Else Send Data", else_send_value)
	return data

/obj/item/device/assembly/logic_circuit/get_buttons()
	var/list/data = list()
	data.Add("Reset Data")
	return data

/obj/item/device/assembly/logic_circuit/get_nonset_data()
	var/list/data = list()
	data.Add("Algorithm: If: ([value1]) [operation] ([value2]) then send data: ([value3])")
	return data

/obj/item/device/assembly/logic_circuit/receive_data(var/list/data = list())
	add_debug_log("Received data \[[src]\]")
	var/received = 0
	if(last_value_set == value1 && user_value_set == value2 || last_value_set == value2 && user_value_set == value1)
		last_value_set = -1 // Not settable by players.
		if(!user_value_set)
			user_value_set = -1
		add_debug_log("Resetting from error! \[[src]\]")
	if(active_wires & WIRE_MISC_CONNECTION)
		for(var/i=1,i<=data.len,i++)
			var/old
			if(last_value_set != value1 && user_value_set != value1)
				old = value1
				value1 = set_value(data[i])
				received = 1
				if(user_value_set != value2)
					last_value_set = value1
				add_debug_log("\[[src] : Value 1 set as [value1]\]")
				if(old == value3)
					value3 = value1
				continue
			else
				add_debug_log("Could not set value1! (Org: [value1] New: [data[i]]) Reason: (1:[last_value_set == value1 ? "1" : "0"])(2:[user_value_set == value1 ? "1" : "0"])")
			if(last_value_set != value2 && user_value_set != value2)
				old = value2
				value2 = set_value(data[i])
				received = 1
				if(user_value_set != value1)
					last_value_set = value2
				add_debug_log("\[[src] : Value 2 set as [value2]\]")
				if(old == value3)
					value3 = value2
				continue
			else
				add_debug_log("Could not set value2! (Org: [value2] New: [data[i]]) Reason: (1:[last_value_set == value2 ? "1" : "0"])(2:[user_value_set == value2 ? "1" : "0"])")
				add_debug_log("Couldn't set data \[[src]([data[i]])!\]")
	if(!received) return 0
	if(activate_on_received)
		process_activation()
	return 1

/obj/item/device/assembly/logic_circuit/activate()
	if(value1 && value2)
		run_operation()
	return 1

/obj/item/device/assembly/logic_circuit/proc/set_value(var/value)
	return 1

/obj/item/device/assembly/logic_circuit/proc/run_operation()
	return 1

/obj/item/device/assembly/logic_circuit/tester
	name = "tester logic circuit"
	desc = "A logic chip. You feel an odd urge to deep fry and salt it. This one tests values."

	holder_attach()
		return 1

/obj/item/device/assembly/logic_circuit/operator
	name = "operational logic circuit"
	desc = "A logic chip. You feel an odd urge to deep fry and salt it. This one runs operations."

	holder_attach()
		return 1

/obj/item/device/assembly/logic_circuit/operator/get_nonset_data()
	var/list/data = list()
	data.Add("Algorithm", "Send data: ([value1]) [operation] ([value2])")
	return data

/obj/item/device/assembly/logic_circuit/tester/numeric
	name = "numeric logic circuit"
	desc = "A logic chip. You feel an odd urge to deepy fry and salt it. This one compares numeric values."
	operations = list("<", "<=", ">", ">=", "=", "!=")

	set_value(var/value)
		value = text2num(value)
		if(isnum(value))
			return value
		return null

	run_operation() // Yeah, this is tedious..
		switch(operation)
			if("<")
				if(value1 < value2)
					send_data(list(value3))
				else failed()
			if("<=")
				if(value1 <= value2)
					send_data(list(value3))
				else failed()
			if(">")
				if(value1 > value2)
					send_data(list(value3))
				else failed()
			if(">=")
				if(value1 >= value2)
					send_data(list(value3))
				else failed()
			if("=")
				if(value1 == value2)
					send_data(list(value3))
				else failed()
			if("!=")
				if(value1 != value2)
					send_data(list(value3))
				else failed()

/obj/item/device/assembly/logic_circuit/operator/numeric
	name = "numeric operation logic circuit"
	desc = "A logic chip. You feel an odd urge to deep fry and salt it. This one runs numeric operations."
	operations = list("Add", "Subtract", "Multiply", "Divide", "Square Root", "Modulo")

	set_value(var/value)
		value = text2num(value)
		if(isnum(value))
			return value
		return null

	run_operation()
		switch(operation)
			if("Add")
				send_data((value1 + value2))
			if("Subtract")
				send_data((value1 - value2))
			if("Multiply")
				send_data((value1 * value2))
			if("Divide")
				send_data((value1 / value2))
			if("Square Root") // Set value2 to zero for 1 value root.
				send_data(sqrt((value1 + value2)))
			if("Modulo")
				send_data((value1 % value2))

/obj/item/device/assembly/logic_circuit/tester/string
	name = "quotational logic circuit"
	desc = "A logic chip. You feel an odd urge to deep fry and salt it. This one compares quotations."
	operations = list("Length(>)", "Length(<)", "Length(=)", "Equal", "Variation")

	set_value(var/value)
		if(istext(value))
			return value
		return null

	run_operation()
		switch(operation)
			if("Length(>)")
				if(length(value1) > length(value2))
					send_data(list(value3))
				else failed()
			if("Length(<)")
				if(length(value1) < length(value2))
					send_data(list(value3))
				else failed()
			if("Length(=)")
				if(length(value1) == length(value2))
					send_data(list(value3))
				else failed()
			if("Equal")
				if(value1 == value2)
					send_data(list(value3))
				else failed()
			if("Variation")
				if(value1 != value2)
					send_data(list(value3))
				else failed()


/obj/item/device/assembly/logic_circuit/operator/string
	name = "quotational operation logic circuit"
	desc = "A logic chip. You feel an odd urge to deepy fry and salt it. This one runs texted-based operations."
	operations = list("Append", "Prepend")

	set_value(var/value)
		if(istext(value))
			return value
		return null

	run_operation()
		switch(operation)
			if("Append")
				value3 = "[value1][value2]"
				send_data(list(value3))
			if("Prepend")
				value3 = "[value2][value1]"
				send_data(list(value3))
//			if("Combine")
//				value3 = stringmerge(value1, value2, value4)

/obj/item/device/assembly/logic_circuit/smart
	name = "smart circuit"
	desc = "A very old and wise circuit, you expect."
	operations = list("OR", "AND", "NOR", "XOR", "Between")
	var/operation2 = "<"
	var/list/operations2 = list("<", "<=", ">", ">=", "=", "!=")
	var/value4 = "NULL"

	holder_attach()
		return 1

	set_value(var/value)
		return value

	get_data()
		var/list/data = list()
		data.Add("Operator", operation, "Else if connection", else_connection_name, "Value One", value1, "Value Two", value2, "Compare operation", operation2, "Compare to", value4, "Sending Data", value3, "Else Send Data", else_send_value)
		return data

	get_nonset_data()
		var/list/data = list()
		data.Add("Algorithmn:", "If: [value1] [operation] [value2] [operation == "BETWEEN" ? "and" : "[operation2]"] [value4]")
		return data

	run_operation()
		var/received = 0
		switch(operation)
			if("OR")
				switch(operation2)
					if("<")
						if(value1 < value4 || value2 < value4)
							send_data(list(value3))
							received = 1
					if("<=")
						if(value1 <= value4 || value2 <= value4)
							send_data(list(value3))
							received = 1
					if(">")
						if(value1 > value4 || value2 > value4)
							send_data(list(value3))
							received = 1
					if(">=")
						if(value1 >= value4 || value2 >= value4)
							send_data(list(value3))
							received = 1
					if("=")
						if(value1 == value4 || value2 == value4)
							send_data(list(value3))
							received = 1
					if("!=")
						if(value1 != value4 || value2 != value4)
							send_data(list(value3))
							received = 1
			if("AND")
				switch(operation2)
					if("<")
						if(value1 < value4 && value2 < value4)
							send_data(list(value3))
							received = 1
					if("<=")
						if(value1 <= value4 && value2 <= value4)
							send_data(list(value3))
							received = 1
					if(">")
						if(value1 > value4 && value2 > value4)
							send_data(list(value3))
							received = 1
					if(">=")
						if(value1 >= value4 && value2 >= value4)
							send_data(list(value3))
							received = 1
					if("=")
						if(value1 == value4 && value2 == value4)
							send_data(list(value3))
							received = 1
					if("!=")
						if(value1 != value4 && value2 != value4)
							send_data(list(value3))
							received = 1
			if("NOR")
				switch(operation2)
					if("<")
						if(!(value1 < value4 || value2 < value4))
							send_data(list(value3))
							received = 1
					if("<=")
						if(!(value1 <= value4 || value2 <= value4))
							send_data(list(value3))
							received = 1
					if(">")
						if(!(value1 > value4 || value2 > value4))
							send_data(list(value3))
							received = 1
					if(">=")
						if(!(value1 >= value4 || value2 >= value4))
							send_data(list(value3))
							received = 1
					if("=")
						if(!(value1 == value4 || value2 == value4))
							send_data(list(value3))
							received = 1
					if("!=")
						if(!(value1 != value4 || value2 != value4))
							send_data(list(value3))
							received = 1
			if("XOR")
				switch(operation2)
					if("<")
						if(!(value1 < value4 && value2 < value4) && (value1 < value4 || value2 < value4))
							send_data(list(value3))
							received = 1
					if("<=")
						if(!(value1 <= value4 && value2 <= value4) && (value1 <= value4 || value2 <= value4))
							send_data(list(value3))
							received = 1
					if(">")
						if(!(value1 > value4 && value2 > value4) && (value1 > value4 || value2 > value4))
							send_data(list(value3))
							received = 1
					if(">=")
						if(!(value1 >= value4 && value2 >= value4) && (value1 >= value4 || value2 >= value4))
							send_data(list(value3))
							received = 1
					if("=")
						if(!(value1 == value4 && value2 == value4) && (value1 == value4 || value2 == value4))
							send_data(list(value3))
							received = 1
					if("!=")
						if(!(value1 != value4 && value2 != value4) && (value1 != value4 || value2 != value4))
							send_data(list(value3))
							received = 1
			if("BETWEEN")
				if(value1 < value4 && value1 > value2)
					send_data(list(value2))
					received = 1
		if(!received)
			failed()

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Compare to")
					var/inp = input(usr, "What value would you like to compare?", "Value")
					if(inp)
						value4 = inp
				if("Compare operation")
					var/index = operations2.Find(operation2)
					if(!index || index == operations2.len) index = 1
					else operation2 = operations2[(index+1)]
					usr << "<span class='notice'>You set \the [src]'s comparison operation to [operation2]!</span>"

		..()

/obj/item/device/assembly/logic_circuit/smart/electrical
	name = "electrical logic circuit"
	desc = "A logic chip. You feel an odd urge to deep fry and salt it. This one manipulates electrical pulses."
	operations = list("WAIT", "WAIT & STAGGER", "DELAY")
	var/list/wait_list = list()
	var/list/specific_conversion = list()
	value4 = 10
	var/value5 = "Number of pulses"
	var/value6 = 2
	value1 = 0
	value2 = 0
	var/block = 1

	get_data()
		var/list/data = list()
		data.Add("Operator", operation, "Sending Data", value3)
		if(operation == "WAIT" || operation == "WAIT & STAGGER")
			data.Add("Wait method", value5, "Wait count", value6)
			if(operation == "WAIT & STAGGER")
				data.Add("Delay", value4)
		data.Add("Blocking pulses", (block ? "TRUE" : "FALSE"))
		return data

	get_nonset_data()
		var/list/data = list()
		data.Add("Num of pulses received: [value1]", "Num of pulsing devices: [value2]")
		return data

	get_help_info()
		var/T = "\
		 This is an electrical logic circuit board. It is used in a similar way as a relay, \
		 in that it is used as a junction between two or more devices. It can, for example, \
		 store all inputs it receives then transmit them once a certain condition has been met.\
		 Once this condition has been met, it will send data to any connected devices to confirm \
		 that the conditions have been met."
		return T

	Topic(href, href_list)
		if(href_list["option"])
			switch(href_list["option"])
				if("Wait method")
					if(value5 == "Number of pulses") value5 = "Number of devices pulsing"
					else value5 = "Number of pulses"
				if("Wait count")
					var/numb = text2num(input(usr, "How many times should this happen?", "Wait"))
					if(numb)
						value6 = numb
				if("Delay")
					var/numb = text2num(input(usr, "How many seconds do you want the delay to last?", "Delay"))
					if(numb)
						value6 = numb
				if("Blocking pulses")
					block = !block
		..()

	run_operation()
		switch(operation)
			if("WAIT")
				if(value5 == "Number of pulses")
					if(value1 >= value6)
						send_pulses()
						send_data(list(value3))
				else
					if(value2 >= value6)
						send_pulses()
						send_data(list(value3))
			if("WAIT & STAGGER")
				var/go_on = 0
				if(value5 == "Number of pulses")
					if(value1 >= value6)
						go_on = 1
				else
					if(value2 >= value6)
						go_on = 1
				if(go_on)
					send_pulses(value4*10)
					send_data(list(value3))
			if("DELAY")
				spawn(value4*10)
					send_pulses()
					send_data(list(value3))


	proc/send_pulses(var/delay = 0)
		add_debug_log("Passing pulses.. \[[src]\]")
		for(var/i=1,i<=wait_list.len,i++)
			if(i % 2)
				var/obj/item/device/assembly/sender = wait_list[i]
				if(sender)
					var/obj/item/device/assembly/receiver = wait_list[(i+1)]
					if(src == receiver) continue
					sender.send_direct_pulse(wait_list[(i+1)])
				else
					add_debug_log("Fatal error: Invalid connection between \[[src]\] and connection sender.")
			sleep(delay)
		value1 = 0
		value2 = 0
		wait_list.Cut()

	holder_pulsing(var/obj/item/device/assembly/sender, var/obj/item/device/assembly/receiver)
		var/list/devices = get_devices_connected_to()
		if(sender in devices)
			if(!(sender in wait_list))
				value2++
				wait_list.Add(sender, receiver)
			value1++
			run_operation()
			if(block)
				return 0
		return 1

