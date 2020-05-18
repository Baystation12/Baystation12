/datum/extension/fake_data
	base_type = /datum/extension/fake_data
	var/list/fake_data = list()

/datum/extension/fake_data/New(datum/holder, data_length)
	..()
	for(var/i = 1, i <= data_length, i++)
		var/list/key = list()
		for(var/j = 1, j <= 10, j++)
			key += ascii2text(rand(65, 90)) //Capital letters
		fake_data += list(list("key" = JOINTEXT(key), "value" = make_value())) //weird data structure is to fascilitate nanoui use.

/datum/extension/fake_data/proc/make_value()
	var/list/value = list("0b")
	for(var/j = 1, j <= 16, j++)
		value += "[pick(0,1)]"
	return JOINTEXT(value)

/datum/extension/fake_data/proc/update_and_return_data()
	var/key = rand(1, length(fake_data))
	fake_data[key]["value"] = make_value()
	return fake_data.Copy()