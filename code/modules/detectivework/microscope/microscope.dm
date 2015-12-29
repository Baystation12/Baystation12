//microscope code itself
/obj/machinery/microscope
	name = "high powered electron microscope"
	desc = "A highly advanced microscope capable of zooming up to 3000x."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "microscope"
	anchored = 1
	density = 1

	var/obj/item/weapon/sample = null
	var/report_num = 0

/obj/machinery/microscope/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(sample)
		user << "<span class='warning'>There is already a slide in the microscope.</span>"
		return

	if(istype(W, /obj/item/weapon/forensics/slide) || istype(W, /obj/item/weapon/sample/print))
		user << "<span class='notice'>You insert \the [W] into the microscope.</span>"
		user.unEquip(W)
		W.forceMove(src)
		sample = W
		update_icon()
		return

/obj/machinery/microscope/attack_hand(mob/user)

	if(!sample)
		user << "<span class='warning'>The microscope has no sample to examine.</span>"
		return

	user << "<span class='notice'>The microscope whirrs as you examine \the [sample].</span>"

	if(!do_after(user, 25) || !sample)
		return

	user << "<span class='notice'>Printing findings now...</span>"
	var/obj/item/weapon/paper/report = new(get_turf(src))
	report.stamped = list(/obj/item/weapon/stamp)
	report.overlays = list("paper_stamped")
	report_num++

	if(istype(sample, /obj/item/weapon/forensics/slide))
		var/obj/item/weapon/forensics/slide/slide = sample
		if(slide.has_swab)
			var/obj/item/weapon/forensics/swab/swab = slide.has_swab

			report.name = "GSR report #[++report_num]: [swab.name]"
			report.info = "<b>Scanned item:</b><br>[swab.name]<br><br>"

			if(swab.gsr)
				report.info += "Residue from a [swab.gsr] bullet detected."
			else
				report.info += "No gunpowder residue found."

		else if(slide.has_sample)
			var/obj/item/weapon/sample/fibers/fibers = slide.has_sample
			report.name = "Fiber report #[++report_num]: [fibers.name]"
			report.info = "<b>Scanned item:</b><br>[fibers.name]<br><br>"
			if(fibers.evidence)
				report.info = "Molecular analysis on provided sample has determined the presence of unique fiber strings.<br><br>"
				for(var/fiber in fibers.evidence)
					report.info += "<span class='notice'>Most likely match for fibers: [fiber]</span><br><br>"
			else
				report.info += "No fibers found."
		else
			report.name = "Empty slide report #[report_num]"
			report.info = "Evidence suggests that there's nothing in this slide."
	else if(istype(sample, /obj/item/weapon/sample/print))
		report.name = "Fingerprint report #[report_num]: [sample.name]"
		report.info = "<b>Fingerprint analysis report #[report_num]</b>: [sample.name]<br>"
		var/obj/item/weapon/sample/print/card = sample
		if(card.evidence && card.evidence.len)
			report.info += "Surface analysis has determined unique fingerprint strings:<br><br>"
			for(var/prints in card.evidence)
				report.info += "<span class='notice'>Fingerprint string: </span>"
				if(!is_complete_print(prints))
					report.info += "INCOMPLETE PRINT"
				else
					report.info += "[prints]"
				report.info += "<br>"
		else
			report.info += "No information available."

	if(report)
		report.update_icon()
		if(report.info)
			user << report.info
	return

/obj/machinery/microscope/proc/remove_sample(var/mob/living/remover)
	if(!istype(remover) || remover.incapacitated() || !Adjacent(remover))
		return ..()
	if(!sample)
		remover << "<span class='warning'>\The [src] does not have a sample in it.</span>"
		return
	remover << "<span class='notice'>You remove \the [sample] from \the [src].</span>"
	sample.forceMove(get_turf(src))
	remover.put_in_hands(sample)
	sample = null
	update_icon()

/obj/machinery/microscope/AltClick()
	remove_sample(usr)

/obj/machinery/microscope/MouseDrop(var/atom/other)
	if(usr == other)
		remove_sample(usr)
	else
		return ..()

/obj/machinery/microscope/update_icon()
	icon_state = "microscope"
	if(sample)
		icon_state += "slide"
