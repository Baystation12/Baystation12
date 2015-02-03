/obj/item/device/detective_scanner
	name = "forensic scanner"
	desc = "Used to scan objects for DNA and fingerprints."
	icon_state = "forensic1"
	var/list/stored = list()
	w_class = 3.0
	item_state = "electronic"
	flags = CONDUCT | NOBLUDGEON
	slot_flags = SLOT_BELT

/obj/item/device/detective_scanner/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if (!ishuman(M))
		user << "<span class='warning'>[M] is not human and cannot have the fingerprints.</span>"
		flick("forensic0",src)
		return 0
	if (( !( istype(M.dna, /datum/dna) ) || M.gloves) )
		user << "<span class='notice'>No fingerprints found on [M]</span>"
		flick("forensic0",src)
		return 0
	else
		var/obj/item/weapon/f_card/F = new /obj/item/weapon/f_card( user.loc )
		F.amount = 1
		F.add_fingerprint(M)
		F.icon_state = "fingerprint1"
		F.name = text("FPrintC- '[M.name]'")
		user << "<span class='notice'>Done printing."
		user << "<span class='notice'>[M]'s Fingerprints: [md5(M.dna.uni_identity)]"
	if ( M.blood_DNA && M.blood_DNA.len )
		user << "<span class='notice'>Blood found on [M]. Analysing...</span>"
		spawn(15)
			for(var/blood in M.blood_DNA)
				user << "<span class='notice'>Blood type: [M.blood_DNA[blood]]\nDNA: [blood]</span>"
	return

/obj/item/device/detective_scanner/afterattack(atom/A as obj|turf, mob/user, proximity)
	if(!proximity) return
	if(ismob(A))
		return
	if(istype(A,/obj/machinery/computer/forensic_scanning))
		user.visible_message("[user] takes a cord out of [src] and hooks its end into [A]" ,\
		"<span class='notice'>You download data from [src] to [A]</span>")
		var/obj/machinery/computer/forensic_scanning/F = A
		F.sync_data(stored)
		return

	if(istype(A,/obj/item/weapon/f_card))
		user << "The scanner displays on the screen: \"ERROR 43: Object on Excluded Object List.\""
		flick("forensic0",src)
		return

	add_fingerprint(user)

	//General
	if ((!A.fingerprints || !A.fingerprints.len) && !A.suit_fibers && !A.blood_DNA)
		user.visible_message("\The [user] scans \the [A] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
		"<span class='warning'>Unable to locate any fingerprints, materials, fibers, or blood on [A]!</span>",\
		"You hear a faint hum of electrical equipment.")
		flick("forensic0",src)
		return 0

	if(add_data(A))
		user << "<span class='notice'>Object already in internal memory. Consolidating data...</span>"
		flick("forensic2",src)
		return

	//PRINTS
	if(A.fingerprints && A.fingerprints.len)
		user << "<span class='notice'>Isolated [A.fingerprints.len] fingerprints:</span>"
		user << "Data Stored: Scan with Hi-Res Forensic Scanner to retrieve.</span>"
		var/list/complete_prints = list()
		for(var/i in A.fingerprints)
			var/print = A.fingerprints[i]
			if(stringpercent(print) <= FINGERPRINT_COMPLETE)
				complete_prints += print
		if(complete_prints.len < 1)
			user << "<span class='notice'>No intact prints found</span>"
		else
			user << "<span class='notice'>Found [complete_prints.len] intact prints</span>"
			for(var/i in complete_prints)
				user << "<span class='notice'>&nbsp;&nbsp;&nbsp;&nbsp;[i]</span>"

	//FIBERS
	if(A.suit_fibers && A.suit_fibers.len)
		user << "<span class='notice'>Fibers/Materials Data Stored: Scan with Hi-Res Forensic Scanner to retrieve."
		flick("forensic2",src)

	//Blood
	if (A.blood_DNA && A.blood_DNA.len)
		user << "<span class='notice'>Blood detected. Analysing...</span>"
		spawn(15)
			for(var/blood in A.blood_DNA)
				user << "Blood type: \red [A.blood_DNA[blood]] \t \black DNA: \red [blood]"

	user.visible_message("\The [user] scans \the [A] with \a [src], the air around [user.gender == MALE ? "him" : "her"] humming[prob(70) ? " gently." : "."]" ,\
	"<span class='notice'>You finish scanning \the [A].</span>",\
	"You hear a faint hum of electrical equipment.")
	flick("forensic2",src)
	return 0

/obj/item/device/detective_scanner/proc/add_data(atom/A as mob|obj|turf|area)
	var/datum/data/record/forensic/old = stored["\ref [A]"]
	var/datum/data/record/forensic/fresh = new(A)

	if(old)
		fresh.merge(old)
		. = 1
	stored["\ref [A]"] = fresh

/obj/item/device/detective_scanner/verb/wipe()
	set name = "Wipe Forensic Data"
	set category = "Object"
	set src in view(1)
	if (alert("Are you sure you want to wipe all data from [src]?",,"Yes","No") == "Yes")
		stored = list()
		usr << "<span class='notice'>Forensic data erase complete.</span>"
