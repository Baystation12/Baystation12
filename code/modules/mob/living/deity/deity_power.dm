/mob/living/deity
	var/power = 0
	var/power_min = 10
	var/power_per_regen = 1

/mob/living/deity/Life()
	. = ..()
	if(.)
		if(power_per_regen < 0 || power < power_min)
			adjust_power(power_per_regen)

/mob/living/deity/proc/adjust_power(var/amount)
	if(amount)
		power = max(0, power + amount)

/mob/living/deity/proc/adjust_power_min(var/amount, var/silent = 0, var/msg)
	if(amount)
		power_min = max(initial(power_min), power_min + amount)
		if(!silent)
			var/feel = ""
			if(abs(amount) > 20)
				feel = " immensely"
			else if(abs(amount) > 10)
				feel = " greatly"
			if(abs(amount) >= 5)
				var/class = amount > 0 ? "notice" : "warning"
				to_chat(src, "<span class='[class]'>You feel your power [amount > 0 ? "increase" : "decrease"][feel][msg ? " [msg]" : ""]</span>")