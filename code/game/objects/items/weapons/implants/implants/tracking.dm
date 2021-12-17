/obj/item/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_BLUESPACE = 2)
	known = 1
	var/id = 1

/obj/item/implant/tracking/get_data()
	. = {"<b>Implant Specifications:</b><BR>
	<b>Name:</b> Tracking Beacon<BR>
	<b>Life:</b> 10 minutes after death of host<BR>
	<b>Important Notes:</b> None<BR>
	<HR>
	<b>Implant Details:</b> <BR>
	<b>Function:</b> Continuously transmits low power signal. Useful for tracking.<BR>
	<b>Special Features:</b><BR>
	<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
	a malfunction occurs thereby securing safety of subject. The implant will melt and
	disintegrate into bio-safe elements.<BR>
	<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
	circuitry. As a result neurotoxins can cause massive damage.<HR>"}
	if(!malfunction)
		.+= {"ID (1-100):<BR>
		<A href='byond://?src=\ref[src];tracking_id=-10'>-</A>
		<A href='byond://?src=\ref[src];tracking_id=-1'>-</A> [id]
		<A href='byond://?src=\ref[src];tracking_id=1'>+</A>
		<A href='byond://?src=\ref[src];tracking_id=10'>+</A><BR>"}

/obj/item/implant/tracking/Topic(href, href_list)
	..()
	if (href_list["tracking_id"])
		id = clamp(id+text2num(href_list["tracking_id"]), 1, 100)
		interact(usr)

/obj/item/implant/tracking/islegal()
	return TRUE

/obj/item/implant/tracking/emp_act(severity)
	var/power = 4 - severity
	if(prob(power * 15))
		meltdown()
	else if(prob(power * 40))
		disable(rand(power*500,power*5000))//adds in extra time because this is the only other way to sabotage it

/obj/item/implantcase/tracking
	name = "glass case - 'tracking'"
	imp = /obj/item/implant/tracking