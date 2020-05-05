
/obj/item/gas_packet
	name = "gas packet"
	desc = "A small sealed container of purified, processed gas for use in industrial applications."
	icon = 'gas_packet.dmi'
	icon_state = "packet_white"
	var/gasid = "None"

/obj/item/gas_packet/New(var/newloc, var/newgas = gasid)
	. = ..()
	if(newgas)
		gasid = newgas
		name = "[gasid] gas packet"
		desc +=  " Contains compressed [gasid]."

/obj/item/gas_packet/oxygen
	gasid = "oxygen"

/obj/item/gas_packet/water
	gasid = "water"
	icon_state = "packet_blue"

/obj/item/gas_packet/noble
	gasid = "noble"
	icon_state = "packet_green"

/obj/item/gas_packet/carbondioxide
	gasid = "carbon dioxide"
	icon_state = "packet_black"

/obj/item/gas_packet/nitrogen
	gasid = "nitrogen"
	icon_state = "packet_brown"

/obj/item/gas_packet/hydrogen
	gasid = "hydrogen"
	icon_state = "packet_teal"

/obj/item/gas_packet/chlorine
	gasid = "chlorine"
	icon_state = "packet_yellow"

/obj/item/gas_packet/helium
	gasid = "helium"
	icon_state = "packet_orange"

/obj/item/gas_packet/methane
	gasid = "methane"
	icon_state = "packet_purple"

/obj/item/gas_packet/sulfurdioxide
	gasid = "sulfur dioxide"
	icon_state = "packet_red"

/obj/item/gas_packet/carbonmonoxide
	gasid = "carbon monoxide"
	icon_state = "packet_pink"
