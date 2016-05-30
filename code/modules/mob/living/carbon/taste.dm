/* what this does:
copies what reagents will be taken out of the holder.
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/mob/living/carbon/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	if(last_taste_time + 50 >= world.time)
		return
	var/datum/reagents/temp = new() //temporary holder used to analyse what gets transfered.
	var/list/tastes = list() //descriptor = strength
	from.trans_to_holder(temp, amount, multiplier, 1)
	var/list/out = list()
	var/minimum_percent = 15
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		minimum_percent = round(15/H.species.taste_sensitivity)
	if(minimum_percent < 100)
		var/total_taste = 0
		for(var/datum/reagent/R in temp.reagent_list)
			var/desc
			if(!R.taste_mult)
				continue
			if(R.id == "nutriment")
				var/list/t = R.get_data()
				for(var/i in 1 to t.len)
					var/A = t[i]
					if(!(A in tastes))
						tastes.Add(A)
						tastes[A] = 0
					tastes[A] += t[A]
					total_taste += t[A]
				continue
			else
				desc = R.taste_description
			if(!(desc in tastes))
				tastes.Add(desc)
				tastes[desc] = 0
			tastes[desc] += temp.get_reagent_amount(R.id) * R.taste_mult
			total_taste += temp.get_reagent_amount(R.id) * R.taste_mult
		if(tastes.len)
			for(var/i in 1 to tastes.len)
				var/size = "a hint of "
				var/percent = tastes[tastes[i]]/total_taste * 100
				if(percent == 100) //completely 1 thing, dont need to do anything to it.
					size = ""
				else if(percent > minimum_percent * 3)
					size = "the strong flavor of "
				else if(percent > minimum_percent * 2)
					size = ""
				else if(percent <= minimum_percent)
					continue
				out.Add("[size][tastes[i]]")
	var/text_output = english_list(out, "something indescribable")
	if(text_output != last_taste_text || last_taste_time + 100 < world.time) //We dont want to spam the same message over and over again at the person. Give it a bit of a buffer.
		src << "<span class='notice'>You can taste [text_output]</span>" //no taste means there are too many tastes and not enough flavor.
		last_taste_time = world.time
		last_taste_text = text_output
	from.trans_to_holder(target,amount,multiplier,copy) //complete transfer