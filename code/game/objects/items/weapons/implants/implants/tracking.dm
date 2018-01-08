/obj/item/weapon/implant/tracking
	name = "tracking implant"
	desc = "Track with this."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_BLUESPACE = 2)
	known = 1
	var/id = 1

/obj/item/weapon/implant/tracking/get_data()
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

/obj/item/weapon/implant/tracking/Topic(href, href_list)
	..()
	if (href_list["tracking_id"])
		id = Clamp(id+text2num(href_list["tracking_id"]), 1, 100)
		interact(usr)

/obj/item/weapon/implant/tracking/islegal()
	return TRUE

/obj/item/weapon/implant/tracking/emp_act(severity)
	if (malfunction)	//no, dawg, you can't malfunction while you are malfunctioning
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 20
	switch(severity)
		if(1)
			if(prob(60))
				removed()
				qdel(src)
		if(2)
			delay = rand(5,15) * 600	//from 5 to 15 minutes of free time

	spawn(delay)
		malfunction = 0

/obj/item/weapon/implantcase/tracking
	name = "glass case - 'tracking'"
	imp = /obj/item/weapon/implant/tracking