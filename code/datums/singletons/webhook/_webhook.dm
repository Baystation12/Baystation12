/**
* Webhook prototype. Allows sending an HTTP message to an endpoint
* in response to some event. Webhooks may use Send directly, but
* in nearly all cases should be dispatched through SSwebhooks.
*/

/singleton/webhook
	abstract_type = /singleton/webhook

	/// The string key for this webhook in webhooks.json.
	var/config_key

	/// A map of (url = availability).
	var/list/urls

	/// Lazy state cache to skip future run attempts if they're pointless.
	var/available = TRUE

	/// Webhook behavior flags. Some combination of WEBHOOK_* below, if any.
	var/webhook_flags = EMPTY_BITFIELD

	var/const/WEBHOOK_REQUIRES_HEADERS = FLAG(0)
	var/const/WEBHOOK_REQUIRES_QUERY = FLAG(1)
	var/const/WEBHOOK_REQUIRES_BODY = FLAG(2)

	// Result codes for Post
	var/const/POST_OK = 0
	var/const/POST_LIBRARY_MISSING = 1
	var/const/POST_INVALID_URL = 2
	var/const/POST_DECODE_ERROR = 3
	var/const/POST_LIBRARY_ERROR = 4


/singleton/webhook/proc/Post(url, headers, body)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (!url)
		return list("code" = POST_INVALID_URL, "error" = url)
	if (!SSwebhooks.http_available)
		return list("code" = POST_LIBRARY_MISSING)
	var/result = call(HTTP_POST_DLL_LOCATION, "send_post_request")(url, body, headers)
	var/list/details
	try
		details = json_decode(result)
	catch
		return list("code" = POST_DECODE_ERROR)
	if (result["error_code"])
		return list("code" = POST_LIBRARY_ERROR, "error" = details["error_code"])
	return list("code" = POST_OK, "status" = details["status_code"], "body" = details["body"])


/singleton/webhook/proc/Send(list/data)
	SHOULD_NOT_OVERRIDE(TRUE)
	if (!available)
		return
	var/headers = CreateHeaders(data)
	if (!headers && (webhook_flags & WEBHOOK_REQUIRES_HEADERS))
		log_debug({"Webhook "[config_key]": Failed creating headers."})
		return
	var/query = CreateQuery(data)
	if (!query && (webhook_flags & WEBHOOK_REQUIRES_QUERY))
		log_debug({"Webhook "[config_key]": Failed creating query."})
		return
	var/body = CreateBody(data)
	if (!body && (webhook_flags & WEBHOOK_REQUIRES_BODY))
		log_debug({"Webhook "[config_key]": Failed creating body."})
		return
	for (var/url in urls)
		if (!urls[url])
			continue
		var/target = url
		if (webhook_flags & WEBHOOK_REQUIRES_QUERY)
			target = "[target][query]"
		var/list/response = Post(target, headers, body)
		switch (response["code"])
			if (POST_INVALID_URL)
				log_debug({"Webhook "[config_key]": Invalid urls entry "[url]"."})
				urls[url] = FALSE
				continue
			if (POST_LIBRARY_MISSING)
				log_debug({"Webhook "[config_key]": Missing library."})
				available = FALSE
				return
			if (POST_DECODE_ERROR)
				log_debug({"Webhook "[config_key]": Missing library."})
				return
			if (POST_LIBRARY_ERROR)
				log_debug({"Webhook "[config_key]": Library error "[response["error"]]"."})
				available = FALSE
				return
		switch (response["status"])
			if (200 to 299)
				continue
			if (400 to 599)
				log_debug({"Webhook "[config_key]": HTTP error code from "[url]" - [response["status"]] "[response["body"]]"."})
			else
				log_debug({"Webhook "[config_key]": HTTP unknown code from "[url]" - [response["status"]] "[response["body"]]"."})


/singleton/webhook/proc/Configure(list/details)
	SHOULD_CALL_PARENT(TRUE)
	urls = details["urls"]
	if (istext(urls))
		urls = list(urls)
	if (!islist(urls) || !length(urls))
		log_debug({"Webhook "[config_key]": No/Invalid URLs specified."})
		available = FALSE
		return FALSE
	return TRUE


/singleton/webhook/proc/CreateHeaders()
	PROTECTED_PROC(TRUE)


/singleton/webhook/proc/CreateQuery()
	PROTECTED_PROC(TRUE)


/singleton/webhook/proc/CreateBody()
	PROTECTED_PROC(TRUE)
