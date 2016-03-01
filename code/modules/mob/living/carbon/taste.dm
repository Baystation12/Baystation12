/* what this does:
copies what reagents will be taken out of the holder.
catalogue the 'taste strength' of each one
calculate text size per text.
*/
/mob/living/carbon/proc/ingest(var/datum/reagents/from, var/datum/reagents/target, var/amount = 1, var/multiplier = 1, var/copy = 0) //we kind of 'sneak' a proc in here for ingesting stuff so we can play with it.
	var/datum/reagents/temp = new() //temporary holder used to analyse what gets transfered.
	var/list/tastes = list() //descriptor = strength
	from.trans_to_holder(temp, amount, multiplier, 1)

	var/minimum_percent = 15
	if(istype(src,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		minimum_percent = round(15 * H.species.taste_sensitivity)

	var/total_taste = 0
	for(var/datum/reagent/R in temp.reagent_list)
		var/desc
		if(!R.taste_mult)
			continue
		if(R.id == "nutriment")
			var/list/t = R.get_data()
			for(var/i = 1, i <= t.len, i++)
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
		var/list/out = list()
		for(var/i = 1, i <= tastes.len, i++)
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
		src << "<span class='notice'>You can taste [english_list(out)]</span>"
	from.trans_to_holder(target,amount,multiplier,copy) //complete transfer