/obj/machinery/networking
	name = "network object"
	//icon = 'icons/obj/networking.dmi'
	icon_state = ""



//Datum to store IP addresses (IPv4 4-byte style)
/sockaddr_in
	var/_high_word
	var/_low_word

/sockaddr_in/New(var/text_in)
	inet_pton(text_in, src)
	return ..()

/sockaddr_in/proc/get_oc(o)
	if(o == 1)
		return _high_word >> 8
	if(o == 2)
		return _high_word & 255
	if(o == 3)
		return _low_word >> 8
	if(o == 4)
		return _low_word & 255
	return -1

/sockaddr_in/proc/set_oc(o, v)
	v &= 255
	if(o == 1)
		_high_word = (v << 8) | (_high_word & 255)
	else if(o == 2)
		_high_word = v | (_high_word & 65280)
	else if(o == 3)
		_low_word = (v << 8) | (_low_word & 255)
	else if(o == 4)
		_low_word = v | (_low_word & 65280)
	return

/sockaddr_in/proc/to_text()
	return inet_ntop(src)

/sockaddr_in/proc/from_text(var/text_in)
	return inet_pton(text_in, src)

//Helper functions for converting sockaddr_in
/proc/inet_ntop(var/sockaddr_in/ip_in)
	if(istype(ip_in))
		return "[ip_in.get_oc(1)].[ip_in.get_oc(2)].[ip_in.get_oc(3)].[ip_in.get_oc(4)]"
	return null

/proc/inet_pton(var/text_in, var/sockaddr_in/ip_out = null)
	var/list/blocks_out = stringsplit(text_in, ".")
	if(length(blocks_out) != 4)
		return null

	if(!ip_out)
		ip_out = new()

	for(var/i = 1; i <= 4; i++)
		ip_out.set_oc(i, max(0, min(255, blocks_out[i])))

	return ip_out

//Distance 2-point proc.  Not defined anywhere, and I need to use it.
/proc/distance2p(var/x1, var/y1, var/x2, var/y2)
	return sqrt(((x2-x1)**2) + ((y2-y1)**2))