/obj/machinery/networking
	name = "network object"
	icon = 'icons/obj/networking.dmi'
	icon_state = ""



//Datum to store IP addresses (IPv4 4-byte style)
/ip_addr
	var/blocks[4]

/ip_addr/New(var/text_in)
	text2ip(text_in, src)
	..()

/ip_addr/proc/to_text()
	return ip2text(src)

/ip_addr/proc/from_text(var/text_in)
	return text2ip(text_in, src)

//Helper functions for converting ip_addr
/proc/ip2text(var/ip_addr/ip_in)
	if(istype(ip_in) && length(ip_in.blocks) == 4)
		return "[num2text(ip_in.blocks[1])].[num2text(ip_in.blocks[2])].[num2text(ip_in.blocks[3])].[num2text(ip_in.blocks[4])]"
	return null

/proc/text2ip(var/text_in, var/ip_addr/ip_out = null)
	var/list/blocks_out = stringsplit(text_in, ".")
	if(length(blocks_out) != 4)
		return null

	if(!ip_out)
		ip_out = new()

	for(var/i = 1; i <= 4; i++)
		//sanitize the blocks to byte limits
		ip_out.blocks[i] = max(0, blocks_out[i])
		ip_out.blocks[i] = min(255, blocks_out[i])

	return ip_out

//just because.
/proc/ntop(var/ip_addr/ip_in)
	return ip2text(ip_in)

/proc/pton(var/text_in, var/ip_addr/ip_out = null)
	return text2ip(text_in, ip_out)



//Distance 2-point proc.  Not defined anywhere, and I need to use it.
/proc/distance2p(var/x1, var/y1, var/x2, var/y2)
	return sqrt(((x2-x1)**2) + ((y2-y1)**2))