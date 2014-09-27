/* TODO
		if(alien) //Diona nymphs are the only alien monkey currently.
			var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
			if(isturf(loc)) //else, there's considered to be no light
				var/turf/T = loc
				var/area/A = T.loc
				if(A)
					if(A.lighting_use_dynamic)	light_amount = min(10,T.lighting_lumcount) - 5 //hardcapped so it's not abused by having a ton of flashlights
					else						light_amount =  5

			nutrition += light_amount
			traumatic_shock -= light_amount

			if(nutrition > 500)
				nutrition = 500
			if(light_amount > 2) //if there's enough light, heal
				adjustBruteLoss(-1)
				adjustToxLoss(-1)
				adjustOxyLoss(-1)
*/