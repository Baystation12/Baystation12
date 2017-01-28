//Uses freegeoip.net API

// Returns geoip country name
/proc/geoip_country(var/ip_address)
	var/http[] = world.Export("http://freegeoip.net/json/[ip_address]")
	var/json

	if(!http)
		world.log << "Failed to connect to freegeoip API"
		return

	var/F = http["CONTENT"]
	if(F)
		json = file2text(F)

	if(!json)
		world.log << "Empty geoip response"
		return

	var/data[] = json_decode(json)
	var/R = data["country_name"]

	return R
