/*! JsRender v1.0.0-beta: http://github.com/BorisMoore/jsrender and http://jsviews.com/jsviews */
/*
* Optimized version of jQuery Templates, for rendering to string.
* Does not require jQuery, or HTML DOM
* Integrates with JsViews (http://jsviews.com/jsviews)
* Copyright 2013, Boris Moore
* Released under the MIT License.
*/
// informal pre V1.0 commit counter: v1.0.0-beta (40)

(function(global, jQuery, undefined) {
	// global is the this object, which is window when running in the usual browser environment.
	"use strict";

	if (jQuery && jQuery.views || global.jsviews) { return; } // JsRender is already loaded

	//========================== Top-level vars ==========================

	var versionNumber = "v1.0.0-beta",

		$, jsvStoreName, rTag, rTmplString,// nodeJsModule,

//TODO	tmplFnsCache = {},
		delimOpenChar0 = "{", delimOpenChar1 = "{", delimCloseChar0 = "}", delimCloseChar1 = "}", linkChar = "^",

		rPath = /^(?:null|true|false|\d[\d.]*|([\w$]+|\.|~([\w$]+)|#(view|([\w$]+))?)([\w$.^]*?)(?:[.[^]([\w$]+)\]?)?)$/g,
		//                                     object     helper    view  viewProperty pathTokens      leafToken

		rParams = /(\()(?=\s*\()|(?:([([])\s*)?(?:(\^?)([#~]?[\w$.^]+)?\s*((\+\+|--)|\+|-|&&|\|\||===|!==|==|!=|<=|>=|[<>%*!:?\/]|(=))\s*|([#~]?[\w$.^]+)([([])?)|(,\s*)|(\(?)\\?(?:(')|("))|(?:\s*(([)\]])(?=\s*\.|\s*\^)|[)\]])([([]?))|(\s+)/g,
		//          lftPrn0        lftPrn        bound         path    operator err                                                eq          path2       prn    comma   lftPrn2   apos quot      rtPrn rtPrnDot                        prn2      space
		// (left paren? followed by (path? followed by operator) or (path followed by left paren?)) or comma or apos or quot or right paren or space

		rNewLine = /[ \t]*(\r\n|\n|\r)/g,
		rUnescapeQuotes = /\\(['"])/g,
		rEscapeQuotes = /['"\\]/g, // Escape quotes and \ character
		rBuildHash = /\x08(~)?([^\x08]+)\x08/g,
		rTestElseIf = /^if\s/,
		rFirstElem = /<(\w+)[>\s]/,
		rAttrEncode = /[\x00`><"'&]/g, // Includes > encoding since rConvertMarkers in JsViews does not skip > characters in attribute strings
		rHtmlEncode = rAttrEncode,
		autoTmplName = 0,
		viewId = 0,
		charEntities = {
			"&": "&amp;",
			"<": "&lt;",
			">": "&gt;",
			"\x00": "&#0;",
			"'": "&#39;",
			'"': "&#34;",
			"`": "&#96;"
		},
		tmplAttr = "data-jsv-tmpl",

		$render = {},
		jsvStores = {
			template: {
				compile: compileTmpl
			},
			tag: {
				compile: compileTag
			},
			helper: {},
			converter: {}
		},

		// jsviews object ($.views if jQuery is loaded)
		$views = {
			jsviews: versionNumber,
			render: $render,
			settings: {
				delimiters: $viewsDelimiters,
				debugMode: true,
				tryCatch: true
			},
			sub: {
				// subscription, e.g. JsViews integration
				View: View,
				Error: JsViewsError,
				tmplFn: tmplFn,
				parse: parseParams,
				extend: $extend,
				error: error,
				syntaxError: syntaxError
			},
			_cnvt: convertVal,
			_tag: renderTag,

			_err: function(e) {
				// Place a breakpoint here to intercept template rendering errors
				return $viewsSettings.debugMode ? ("Error: " + (e.message || e)) + ". " : '';
			}
		};

		function JsViewsError(message, object) {
			// Error exception type for JsViews/JsRender
			// Override of $.views.sub.Error is possible
			if (object && object.onError) {
				if (object.onError(message) === false) {
					return;
				}
			}
			this.name = "JsRender Error";
			this.message = message || "JsRender error";
		}

		function $extend(target, source) {
			var name;
			target = target || {};
			for (name in source) {
				target[name] = source[name];
			}
			return target;
		}

		(JsViewsError.prototype = new Error()).constructor = JsViewsError;

	//========================== Top-level functions ==========================

	//===================
	// jsviews.delimiters
	//===================
	function $viewsDelimiters(openChars, closeChars, link) {
		// Set the tag opening and closing delimiters and 'link' character. Default is "{{", "}}" and "^"
		// openChars, closeChars: opening and closing strings, each with two characters

		if (!$viewsSub.rTag || arguments.length) {
			delimOpenChar0 = openChars ? openChars.charAt(0) : delimOpenChar0; // Escape the characters - since they could be regex special characters
			delimOpenChar1 = openChars ? openChars.charAt(1) : delimOpenChar1;
			delimCloseChar0 = closeChars ? closeChars.charAt(0) : delimCloseChar0;
			delimCloseChar1 = closeChars ? closeChars.charAt(1) : delimCloseChar1;
			linkChar = link || linkChar;
			openChars = "\\" + delimOpenChar0 + "(\\" + linkChar + ")?\\" + delimOpenChar1;  // Default is "{^{"
			closeChars = "\\" + delimCloseChar0 + "\\" + delimCloseChar1;                   // Default is "}}"
			// Build regex with new delimiters
			//          tag    (followed by / space or })   or cvtr+colon or html or code
			rTag = "(?:(?:(\\w+(?=[\\/\\s\\" + delimCloseChar0 + "]))|(?:(\\w+)?(:)|(>)|!--((?:[^-]|-(?!-))*)--|(\\*)))"
				+ "\\s*((?:[^\\" + delimCloseChar0 + "]|\\" + delimCloseChar0 + "(?!\\" + delimCloseChar1 + "))*?)";

			// make rTag available to JsViews (or other components) for parsing binding expressions
			$viewsSub.rTag = rTag + ")";

			rTag = new RegExp(openChars + rTag + "(\\/)?|(?:\\/(\\w+)))" + closeChars, "g");

			// Default:    bind           tag       converter colon html     comment            code      params            slash   closeBlock
			//           /{(\^)?{(?:(?:(\w+(?=[\/\s}]))|(?:(\w+)?(:)|(>)|!--((?:[^-]|-(?!-))*)--|(\*)))\s*((?:[^}]|}(?!}))*?)(\/)?|(?:\/(\w+)))}}/g

			rTmplString = new RegExp("<.*>|([^\\\\]|^)[{}]|" + openChars + ".*" + closeChars);
			// rTmplString looks for html tags or { or } char not preceded by \\, or JsRender tags {{xxx}}. Each of these strings are considered
			// NOT to be jQuery selectors
		}
		return [delimOpenChar0, delimOpenChar1, delimCloseChar0, delimCloseChar1, linkChar];
	}

	//=========
	// View.get
	//=========

	function getView(inner, type) { //view.get(inner, type)
		if (!type) {
			// view.get(type)
			type = inner;
			inner = undefined;
		}

		var views, i, l, found,
			view = this,
			root = !type || type === "root";
			// If type is undefined, returns root view (view under top view).

		if (inner) {
			// Go through views - this one, and all nested ones, depth-first - and return first one with given type.
			found = view.type === type ? view : undefined;
			if (!found) {
				views = view.views;
				if (view._.useKey) {
					for (i in views) {
						if (found = views[i].get(inner, type)) {
							break;
						}
					}
				} else for (i = 0, l = views.length; !found && i < l; i++) {
					found = views[i].get(inner, type);
				}
			}
		} else if (root) {
			// Find root view. (view whose parent is top view)
			while (view.parent.parent) {
				found = view = view.parent;
			}
		} else while (view && !found) {
			// Go through views - this one, and all parent ones - and return first one with given type.
			found = view.type === type ? view : undefined;
			view = view.parent;
		}
		return found;
	}

	function getIndex() {
		var view = this.get("item");
		return view ? view.index : undefined;
	}

	getIndex.depends = function() {
		return [this.get("item"), "index"];
	};

	//==========
	// View.hlp
	//==========

	function getHelper(helper, context) {
		// Helper method called as view.hlp(key) from compiled template, for helper functions or template parameters ~foo
		var wrapped,
			view = this,
			res = context && context[helper] || (view.ctx || {})[helper];

		res = res === undefined ? view.getRsc("helpers", helper) : res;

		if (res) {
			if (typeof res === "function") {
				wrapped = function() {
					// If it is of type function, we will wrap it so it gets called with view as 'this' context.
					// If the helper ~foo() was in a data-link expression, the view will have a 'temporary' linkCtx property too.
					// However note that helper functions on deeper paths will not have access to view and tagCtx.
					// For example, ~util.foo() will have the ~util object as 'this' pointer
					return res.apply(view, arguments);
				};
				$extend(wrapped, res);
			}
		}
		return wrapped || res;
	}

	//==============
	// jsviews._cnvt
	//==============

	function convertVal(converter, view, tagCtx) {
		// self is template object or linkCtx object
		var tmplConverter, tag, value,
			boundTagCtx = +tagCtx === tagCtx && tagCtx, // if value is an integer, then it is the key for the boundTagCtx
			linkCtx = view.linkCtx;

		if (boundTagCtx) {
			// Call compiled function which returns the tagCtxs for current data
			tagCtx = (boundTagCtx = view.tmpl.bnds[boundTagCtx-1])(view.data, view, $views);
		}

		value = tagCtx.args[0];

		if (converter || boundTagCtx) {
			tag = linkCtx && linkCtx.tag || {
				_: {
					inline: !linkCtx
				},
				tagName: converter + ":",
				flow: true,
				_is: "tag"
			};

			tag._.bnd = boundTagCtx;

			if (linkCtx) {
				linkCtx.tag = tag;
				tagCtx.ctx = extendCtx(tagCtx.ctx, linkCtx.view.ctx);
			}
			tag.tagCtx = tagCtx;
			tagCtx.view = view;

			tag.ctx = tagCtx.ctx || {};
			delete tagCtx.ctx;
			// Provide this tag on view, for addBindingMarkers on bound tags to add the tag to view._.bnds, associated with the tag id,
			view._.tag = tag;

			converter = converter !== "true" && converter; // If there is a convertBack but no convert, converter will be "true"

			if (converter && ((tmplConverter = view.getRsc("converters", converter)) || error("Unknown converter: {{"+ converter + ":"))) {
				// A call to {{cnvt: ... }} or {^{cnvt: ... }} or data-link="{cnvt: ... }"
				tag.depends = tmplConverter.depends;
				value = tmplConverter.apply(tag, tagCtx.args);
			}
			// Call onRender (used by JsViews if present, to add binding annotations around rendered content)
			value = boundTagCtx && view._.onRender
				? view._.onRender(value, view, boundTagCtx)
				: value;
			view._.tag = undefined;
		}
		return value;
	}

	//=============
	// jsviews._tag
	//=============

	function getResource(resourceType, itemName) {
		var res,
			view = this,
			store = $views[resourceType];

		res = store && store[itemName];
		while ((res === undefined) && view) {
			store = view.tmpl[resourceType];
			res = store && store[itemName];
			view = view.parent;
		}
		return res;
	}

	function renderTag(tagName, parentView, tmpl, tagCtxs) {
		// Called from within compiled template function, to render a template tag
		// Returns the rendered tag

		var render, tag, tags, attr, parentTag, i, l, itemRet, tagCtx, tagCtxCtx, content, boundTagFn, tagDef, callInit,
			ret = "",
			boundTagKey = +tagCtxs === tagCtxs && tagCtxs, // if tagCtxs is an integer, then it is the boundTagKey
			linkCtx = parentView.linkCtx || 0,
			ctx = parentView.ctx,
			parentTmpl = tmpl || parentView.tmpl,
			parentView_ = parentView._;

		if (tagName._is === "tag") {
			tag = tagName;
			tagName = tag.tagName;
		}

		// Provide tagCtx, linkCtx and ctx access from tag
		if (boundTagKey) {
			// if tagCtxs is an integer, we are data binding
			// Call compiled function which returns the tagCtxs for current data
			tagCtxs = (boundTagFn = parentTmpl.bnds[boundTagKey-1])(parentView.data, parentView, $views);
		}

		l = tagCtxs.length;
		tag = tag || linkCtx.tag;
		for (i = 0; i < l; i++) {
			tagCtx = tagCtxs[i];

			// Set the tmpl property to the content of the block tag, unless set as an override property on the tag
			content = tagCtx.tmpl;
			content = tagCtx.content = content && parentTmpl.tmpls[content - 1];
			tmpl = tagCtx.props.tmpl;
			if (!i && (!tmpl || !tag)) {
				tagDef = parentView.getRsc("tags", tagName) || error("Unknown tag: {{"+ tagName + "}}");
			}
			tmpl = tmpl || (tag ? tag : tagDef).template || content;
			tmpl = "" + tmpl === tmpl // if a string
				? parentView.getRsc("templates", tmpl) || $templates(tmpl)
				: tmpl;

			$extend( tagCtx, {
				tmpl: tmpl,
				render: renderContent,
				index: i,
				view: parentView,
				ctx: extendCtx(tagCtx.ctx, ctx) // Extend parentView.ctx
			}); // Extend parentView.ctx

			if (!tag) {
				// This will only be hit for initial tagCtx (not for {{else}}) - if the tag instance does not exist yet
				// Instantiate tag if it does not yet exist
				if (tagDef._ctr) {
					// If the tag has not already been instantiated, we will create a new instance.
					// ~tag will access the tag, even within the rendering of the template content of this tag.
					// From child/descendant tags, can access using ~tag.parent, or ~parentTags.tagName
//	TODO provide error handling owned by the tag - using tag.onError
//				try {
					tag = new tagDef._ctr();
					callInit = !!tag.init;
//				}
//				catch(e) {
//					tagDef.onError(e);
//				}
					// Set attr on linkCtx to ensure outputting to the correct target attribute.
					tag.attr = tag.attr || tagDef.attr || undefined;
					// Setting either linkCtx.attr or this.attr in the init() allows per-instance choice of target attrib.
				} else {
					// This is a simple tag declared as a function, or with init set to false. We won't instantiate a specific tag constructor - just a standard instance object.
					tag = {
						// tag instance object if no init constructor
						render: tagDef.render
					};
				}
				tag._ = {
					inline: !linkCtx
				};
				if (linkCtx) {
					// Set attr on linkCtx to ensure outputting to the correct target attribute.
					linkCtx.attr = tag.attr = linkCtx.attr || tag.attr;
					linkCtx.tag = tag;
					tag.linkCtx = linkCtx;
				}
				if (tag._.bnd = boundTagFn || linkCtx) {
					// Bound if {^{tag...}} or data-link="{tag...}"
					tag._.arrVws = {};
				}
				tag.tagName = tagName;
				tag.parent = parentTag = ctx && ctx.tag;
				tag._is = "tag";
				tag._def = tagDef;
				// Provide this tag on view, for addBindingMarkers on bound tags to add the tag to view._.bnds, associated with the tag id,
			}
			parentView_.tag = tag;
			tagCtx.tag = tag;
			tag.tagCtxs = tagCtxs;
			if (!tag.flow) {
				tagCtxCtx = tagCtx.ctx = tagCtx.ctx || {};

				// tags hash: tag.ctx.tags, merged with parentView.ctx.tags,
				tags = tag.parents = tagCtxCtx.parentTags = ctx && extendCtx(tagCtxCtx.parentTags, ctx.parentTags) || {};
				if (parentTag) {
					tags[parentTag.tagName] = parentTag;
				}
				tagCtxCtx.tag = tag;
			}
		}
		tag.rendering = {}; // Provide object for state during render calls to tag and elses. (Used by {{if}} and {{for}}...)
		for (i = 0; i < l; i++) {
			tagCtx = tag.tagCtx = tagCtxs[i];
			tag.ctx = tagCtx.ctx;

			if (!i && callInit) {
				tag.init(tagCtx, linkCtx, tag.ctx);
				callInit = undefined;
			}

			if (render = tag.render) {
				itemRet = render.apply(tag, tagCtx.args);
			}
			ret += itemRet !== undefined
				? itemRet   // Return result of render function unless it is undefined, in which case return rendered template
				: tagCtx.tmpl
					// render template/content on the current data item
					? tagCtx.render()
					: ""; // No return value from render, and no template/content defined, so return ""
		}
		delete tag.rendering;

		tag.tagCtx = tag.tagCtxs[0];
		tag.ctx= tag.tagCtx.ctx;

		if (tag._.inline && (attr = tag.attr) && attr !== "html") {
			ret = attr === "text"
				? $converters.html(ret)
				: "";
		}
		return boundTagKey && parentView._.onRender
			// Call onRender (used by JsViews if present, to add binding annotations around rendered content)
			? parentView._.onRender(ret, parentView, boundTagKey)
			: ret;
	}

	//=================
	// View constructor
	//=================

	function View(context, type, parentView, data, template, key, contentTmpl, onRender) {
		// Constructor for view object in view hierarchy. (Augmented by JsViews if JsViews is loaded)
		var views, parentView_, tag,
			isArray = type === "array",
			self_ = {
				key: 0,
				useKey: isArray ? 0 : 1,
				id: "" + viewId++,
				onRender: onRender,
				bnds: {}
			},
			self = {
				data: data,
				tmpl: template,
				content: contentTmpl,
				views: isArray ? [] : {},
				parent: parentView,
				ctx: context,
				type: type,
				// If the data is an array, this is an 'array view' with a views array for each child 'item view'
				// If the data is not an array, this is an 'item view' with a views 'map' object for any child nested views
				// ._.useKey is non zero if is not an 'array view' (owning a data array). Uuse this as next key for adding to child views map
				get: getView,
				getIndex: getIndex,
				getRsc: getResource,
				hlp: getHelper,
				_: self_,
				_is: "view"
		};
		if (parentView) {
			views = parentView.views;
			parentView_ = parentView._;
			if (parentView_.useKey) {
				// Parent is an 'item view'. Add this view to its views object
				// self._key = is the key in the parent view map
				views[self_.key = "_" + parentView_.useKey++] = self;
				tag = parentView_.tag;
				self_.bnd = isArray && (!tag || !!tag._.bnd && tag); // For array views that are data bound for collection change events, set the
				// view._.bnd property to true for top-level link() or data-link="{for}", or to the tag instance for a data- bound tag, e.g. {^{for ...}}
			} else {
				// Parent is an 'array view'. Add this view to its views array
				views.splice(
					// self._.key = self.index - the index in the parent view array
					self_.key = self.index =
						key !== undefined
							? key
							: views.length,
				0, self);
			}
			// If no context was passed in, use parent context
			// If context was passed in, it should have been merged already with parent context
			self.ctx = context || parentView.ctx;
		}
		return self;
	}

	//=============
	// Registration
	//=============

	function compileChildResources(parentTmpl) {
		var storeName, resources, resourceName, settings, compile;
		for (storeName in jsvStores) {
			settings = jsvStores[storeName];
			if ((compile = settings.compile) && (resources = parentTmpl[storeName + "s"])) {
				for (resourceName in resources) {
					// compile child resource declarations (templates, tags, converters or helpers)
					resources[resourceName] = compile(resourceName, resources[resourceName], parentTmpl, storeName, settings);
				}
			}
		}
	}

	function compileTag(name, tagDef, parentTmpl) {
		var init, tmpl;
		if (typeof tagDef === "function") {
			// Simple tag declared as function. No presenter instantation.
			tagDef = {
				depends: tagDef.depends,
				render: tagDef
			};
		} else {
			// Tag declared as object, used as the prototype for tag instantiation (control/presenter)
			if (tmpl = tagDef.template) {
				tagDef.template = "" + tmpl === tmpl ? ($templates[tmpl] || $templates(tmpl)) : tmpl;
			}
			if (tagDef.init !== false) {
				init = tagDef._ctr = function(tagCtx) {};
				(init.prototype = tagDef).constructor = init;
			}
		}
		if (parentTmpl) {
			tagDef._parentTmpl = parentTmpl;
		}
//TODO	tagDef.onError = function(e) {
//			var error;
//			if (error = this.prototype.onError) {
//				error.call(this, e);
//			} else {
//				throw e;
//			}
//		}
		return tagDef;
	}

	function compileTmpl(name, tmpl, parentTmpl, storeName, storeSettings, options) {
		// tmpl is either a template object, a selector for a template script block, the name of a compiled template, or a template object

		//==== nested functions ====
		function tmplOrMarkupFromStr(value) {
			// If value is of type string - treat as selector, or name of compiled template
			// Return the template object, if already compiled, or the markup string

			if (("" + value === value) || value.nodeType > 0) {
				try {
					elem = value.nodeType > 0
					? value
					: !rTmplString.test(value)
					// If value is a string and does not contain HTML or tag content, then test as selector
						&& jQuery && jQuery(global.document).find(value)[0];
					// If selector is valid and returns at least one element, get first element
					// If invalid, jQuery will throw. We will stay with the original string.
				} catch (e) {}

				if (elem) {
					// Generally this is a script element.
					// However we allow it to be any element, so you can for example take the content of a div,
					// use it as a template, and replace it by the same content rendered against data.
					// e.g. for linking the content of a div to a container, and using the initial content as template:
					// $.link("#content", model, {tmpl: "#content"});

					value = elem.getAttribute(tmplAttr);
					name = name || value;
					value = $templates[value];
					if (!value) {
						// Not already compiled and cached, so compile and cache the name
						// Create a name for compiled template if none provided
						name = name || "_" + autoTmplName++;
						elem.setAttribute(tmplAttr, name);
						// Use tmpl as options
						value = $templates[name] = compileTmpl(name, elem.innerHTML, parentTmpl, storeName, storeSettings, options);
					}
				}
				return value;
			}
			// If value is not a string, return undefined
		}

		var tmplOrMarkup, elem;

		//==== Compile the template ====
		tmpl = tmpl || "";
		tmplOrMarkup = tmplOrMarkupFromStr(tmpl);

		// If options, then this was already compiled from a (script) element template declaration.
		// If not, then if tmpl is a template object, use it for options
		options = options || (tmpl.markup ? tmpl : {});
		options.tmplName = name;
		if (parentTmpl) {
			options._parentTmpl = parentTmpl;
		}
		// If tmpl is not a markup string or a selector string, then it must be a template object
		// In that case, get it from the markup property of the object
		if (!tmplOrMarkup && tmpl.markup && (tmplOrMarkup = tmplOrMarkupFromStr(tmpl.markup))) {
			if (tmplOrMarkup.fn && (tmplOrMarkup.debug !== tmpl.debug || tmplOrMarkup.allowCode !== tmpl.allowCode)) {
				// if the string references a compiled template object, but the debug or allowCode props are different, need to recompile
				tmplOrMarkup = tmplOrMarkup.markup;
			}
		}
		if (tmplOrMarkup !== undefined) {
			if (name && !parentTmpl) {
				$render[name] = function() {
					return tmpl.render.apply(tmpl, arguments);
				};
			}
			if (tmplOrMarkup.fn || tmpl.fn) {
				// tmpl is already compiled, so use it, or if different name is provided, clone it
				if (tmplOrMarkup.fn) {
					if (name && name !== tmplOrMarkup.tmplName) {
						tmpl = extendCtx(options, tmplOrMarkup);
					} else {
						tmpl = tmplOrMarkup;
					}
				}
			} else {
				// tmplOrMarkup is a markup string, not a compiled template
				// Create template object
				tmpl = TmplObject(tmplOrMarkup, options);
				// Compile to AST and then to compiled function
				tmplFn(tmplOrMarkup, tmpl);
			}
			compileChildResources(options);
			return tmpl;
		}
	}
	//==== /end of function compile ====

	function TmplObject(markup, options) {
		// Template object constructor
		var htmlTag,
			wrapMap = $viewsSettings.wrapMap || {},
			tmpl = $extend(
				{
					markup: markup,
					tmpls: [],
					links: {}, // Compiled functions for link expressions
					tags: {}, // Compiled functions for bound tag expressions
					bnds: [],
					_is: "template",
					render: renderContent
				},
				options
			);

		if (!options.htmlTag) {
			// Set tmpl.tag to the top-level HTML tag used in the template, if any...
			htmlTag = rFirstElem.exec(markup);
			tmpl.htmlTag = htmlTag ? htmlTag[1].toLowerCase() : "";
		}
		htmlTag = wrapMap[tmpl.htmlTag];
		if (htmlTag && htmlTag !== wrapMap.div) {
			// When using JsViews, we trim templates which are inserted into HTML contexts where text nodes are not rendered (i.e. not 'Phrasing Content').
			tmpl.markup = $.trim(tmpl.markup);
			tmpl._elCnt = true; // element content model (no rendered text nodes), not phrasing content model
		}

		return tmpl;
	}

	function registerStore(storeName, storeSettings) {

		function theStore(name, item, parentTmpl) {
			// The store is also the function used to add items to the store. e.g. $.templates, or $.views.tags

			// For store of name 'thing', Call as:
			//    $.views.things(items[, parentTmpl]),
			// or $.views.things(name, item[, parentTmpl])

			var onStore, compile, itemName, thisStore;

			if (name && "" + name !== name && !name.nodeType && !name.markup) {
				// Call to $.views.things(items[, parentTmpl]),

				// Adding items to the store
				// If name is a map, then item is parentTmpl. Iterate over map and call store for key.
				for (itemName in name) {
					theStore(itemName, name[itemName], item);
				}
				return $views;
			}
			// Adding a single unnamed item to the store
			if (item === undefined) {
				item = name;
				name = undefined;
			}
			if (name && "" + name !== name) { // name must be a string
				parentTmpl = item;
				item = name;
				name = undefined;
			}
			thisStore = parentTmpl ? parentTmpl[storeNames] = parentTmpl[storeNames] || {} : theStore;
			compile = storeSettings.compile;
			if (onStore = $viewsSub.onBeforeStoreItem) {
				// e.g. provide an external compiler or preprocess the item.
				compile = onStore(thisStore, name, item, compile) || compile;
			}
			if (!name) {
				item = compile(undefined, item);
			} else if (item === null) {
				// If item is null, delete this entry
				delete thisStore[name];
			} else {
				thisStore[name] = compile ? (item = compile(name, item, parentTmpl, storeName, storeSettings)) : item;
			}
			if (compile && item) {
				item._is = storeName; // Only do this for compiled objects (tags, templates...)
			}
			if (onStore = $viewsSub.onStoreItem) {
				// e.g. JsViews integration
				onStore(thisStore, name, item, compile);
			}
			return item;
		}

		var storeNames = storeName + "s";

		$views[storeNames] = theStore;
		jsvStores[storeName] = storeSettings;
	}

	//==============
	// renderContent
	//==============

	function renderContent(data, context, parentView, key, isLayout, onRender) {
		// Render template against data as a tree of subviews (nested rendered template instances), or as a string (top-level template).
		// If the data is the parent view, treat as layout template, re-render with the same data context.
		var i, l, dataItem, newView, childView, itemResult, swapContent, tagCtx, contentTmpl, tag_, outerOnRender, tmplName, tmpl,
			self = this,
			allowDataLink = !self.attr || self.attr === "html",
			result = "";

		if (key === true) {
			swapContent = true;
			key = 0;
		}
		if (self.tag) {
			// This is a call from renderTag or tagCtx.render()
			tagCtx = self;
			self = self.tag;
			tag_ = self._;
			tmplName = self.tagName;
			tmpl = tagCtx.tmpl;
			context = extendCtx(context, self.ctx);
			contentTmpl = tagCtx.content; // The wrapped content - to be added to views, below
			if ( tagCtx.props.link === false ) {
				// link=false setting on block tag
				// We will override inherited value of link by the explicit setting link=false taken from props
				// The child views of an unlinked view are also unlinked. So setting child back to true will not have any effect.
				context = context || {};
				context.link = false;
			}
			parentView = parentView || tagCtx.view;
			data = data === undefined ? parentView : data;
		} else {
			tmpl = self.jquery && (self[0] || error('Unknown template: "' + self.selector + '"')) // This is a call from $(selector).render
				|| self;
		}
		if (tmpl) {
			if (!parentView && data && data._is === "view") {
				parentView = data; // When passing in a view to render or link (and not passing in a parent view) use the passed in view as parentView
			}
			if (parentView) {
				contentTmpl = contentTmpl || parentView.content; // The wrapped content - to be added as #content property on views, below
				onRender = onRender || parentView._.onRender;
				if (data === parentView) {
					// Inherit the data from the parent view.
					// This may be the contents of an {{if}} block
					// Set isLayout = true so we don't iterate the if block if the data is an array.
					data = parentView.data;
					isLayout = true;
				}
				context = extendCtx(context, parentView.ctx);
			}
			if (!parentView || parentView.data === undefined) {
				(context = context || {}).root = data; // Provide ~root as shortcut to top-level data.
			}

			// Set additional context on views created here, (as modified context inherited from the parent, and to be inherited by child views)
			// Note: If no jQuery, $extend does not support chained copies - so limit extend() to two parameters

			if (!tmpl.fn) {
				tmpl = $templates[tmpl] || $templates(tmpl);
			}

			if (tmpl) {
				onRender = (context && context.link) !== false && allowDataLink && onRender;
				// If link===false, do not call onRender, so no data-linking marker nodes
				outerOnRender = onRender;
				if (onRender === true) {
					// Used by view.refresh(). Don't create a new wrapper view.
					outerOnRender = undefined;
					onRender = parentView._.onRender;
				}
				if ($.isArray(data) && !isLayout) {
					// Create a view for the array, whose child views correspond to each data item. (Note: if key and parentView are passed in
					// along with parent view, treat as insert -e.g. from view.addViews - so parentView is already the view item for array)
					newView = swapContent
						? parentView :
						(key !== undefined && parentView) || View(context, "array", parentView, data, tmpl, key, contentTmpl, onRender);
					for (i = 0, l = data.length; i < l; i++) {
						// Create a view for each data item.
						dataItem = data[i];
						childView = View(context, "item", newView, dataItem, tmpl, (key || 0) + i, contentTmpl, onRender);
						itemResult = tmpl.fn(dataItem, childView, $views);
						result += newView._.onRender ? newView._.onRender(itemResult, childView) : itemResult;
					}
				} else {
					// Create a view for singleton data object. The type of the view will be the tag name, e.g. "if" or "myTag" except for
					// "item", "array" and "data" views. A "data" view is from programatic render(object) against a 'singleton'.
					newView = swapContent ? parentView : View(context, tmplName||"data", parentView, data, tmpl, key, contentTmpl, onRender);
					if (tag_ && !self.flow) {
						newView.tag = self;
					}
					result += tmpl.fn(data, newView, $views);
				}
				return outerOnRender ? outerOnRender(result, newView) : result;
			}
		}
		return "";
	}

	//===========================
	// Build and compile template
	//===========================

	// Generate a reusable function that will serve to render a template against data
	// (Compile AST then build template function)

	function error(message) {
		throw new $views.sub.Error(message);
	}

	function syntaxError(message) {
		error("Syntax error\n" + message);
	}

	function tmplFn(markup, tmpl, isLinkExpr, convertBack) {
		// Compile markup to AST (abtract syntax tree) then build the template function code from the AST nodes
		// Used for compiling templates, and also by JsViews to build functions for data link expressions

		//==== nested functions ====
		function pushprecedingContent(shift) {
			shift -= loc;
			if (shift) {
				content.push(markup.substr(loc, shift).replace(rNewLine, "\\n"));
			}
		}

		function blockTagCheck(tagName) {
			tagName && syntaxError('Unmatched or missing tag: "{{/' + tagName + '}}" in template:\n' + markup);
		}

		function parseTag(all, bind, tagName, converter, colon, html, comment, codeTag, params, slash, closeBlock, index) {

			//    bind         tag        converter colon html     comment            code      params            slash   closeBlock
			// /{(\^)?{(?:(?:(\w+(?=[\/\s}]))|(?:(\w+)?(:)|(>)|!--((?:[^-]|-(?!-))*)--|(\*)))\s*((?:[^}]|}(?!}))*?)(\/)?|(?:\/(\w+)))}}/g
			// Build abstract syntax tree (AST): [ tagName, converter, params, content, hash, bindings, contentMarkup ]
			if (html) {
				colon = ":";
				converter = "html";
			}
			slash = slash || isLinkExpr;
			var noError, current0,
				pathBindings = bind && [],
				code = "",
				hash = "",
				passedCtx = "",
				// Block tag if not self-closing and not {{:}} or {{>}} (special case) and not a data-link expression
				block = !slash && !colon && !comment;

			//==== nested helper function ====
			tagName = tagName || colon;
			pushprecedingContent(index);
			loc = index + all.length; // location marker - parsed up to here
			if (codeTag) {
				if (allowCode) {
					content.push(["*", "\n" + params.replace(rUnescapeQuotes, "$1") + "\n"]);
				}
			} else if (tagName) {
				if (tagName === "else") {
					if (rTestElseIf.test(params)) {
						syntaxError('for "{{else if expr}}" use "{{else expr}}"');
					}
					pathBindings = current[6];
					current[7] = markup.substring(current[7], index); // contentMarkup for block tag
					current = stack.pop();
					content = current[3];
					block = true;
				}
				if (params) {
					// remove newlines from the params string, to avoid compiled code errors for unterminated strings
					params = params.replace(rNewLine, " ");
					code = parseParams(params, pathBindings, tmpl)
						.replace(rBuildHash, function(all, isCtx, keyValue) {
							if (isCtx) {
								passedCtx += keyValue + ",";
							} else {
								hash += keyValue + ",";
							}
							return "";
						});
				}
				hash = hash.slice(0, -1);
				code = code.slice(0, -1);
				noError = hash && (hash.indexOf("noerror:true") + 1) && hash || "";

				newNode = [
						tagName,
						converter || !!convertBack || "",
						code,
						block && [],
						'params:"' + params + '",props:{' + hash + "}"
							+ (passedCtx ? ",ctx:{" + passedCtx.slice(0, -1) + "}" : ""),
						noError,
						pathBindings || 0
					];
				content.push(newNode);
				if (block) {
					stack.push(current);
					current = newNode;
					current[7] = loc; // Store current location of open tag, to be able to add contentMarkup when we reach closing tag
				}
			} else if (closeBlock) {
				current0 = current[0];
				blockTagCheck(closeBlock !== current0 && current0 !== "else" && closeBlock);
				current[7] = markup.substring(current[7], index); // contentMarkup for block tag
				current = stack.pop();
			}
			blockTagCheck(!current && closeBlock);
			content = current[3];
		}
		//==== /end of nested functions ====

		var newNode,
			allowCode = tmpl && tmpl.allowCode,
			astTop = [],
			loc = 0,
			stack = [],
			content = astTop,
			current = [, , , astTop];

		markup = markup.replace(rEscapeQuotes, "\\$&");

//TODO	result = tmplFnsCache[markup]; // Only cache if template is not named and markup length < ...,
//and there are no bindings or subtemplates?? Consider standard optimization for data-link="a.b.c"
//		if (result) {
//			tmpl.fn = result;
//		} else {

//		result = markup;

		blockTagCheck(stack[0] && stack[0][3].pop()[0]);

		// Build the AST (abstract syntax tree) under astTop
		markup.replace(rTag, parseTag);

		pushprecedingContent(markup.length);

		if (loc = astTop[astTop.length - 1]) {
			blockTagCheck("" + loc !== loc && (+loc[7] === loc[7]) && loc[0]);
		}
//			result = tmplFnsCache[markup] = buildCode(astTop, tmpl);
//		}
		return buildCode(astTop, isLinkExpr ? markup : tmpl, isLinkExpr);
	}

	function buildCode(ast, tmpl, isLinkExpr) {
		// Build the template function code from the AST nodes, and set as property on the passed-in template object
		// Used for compiling templates, and also by JsViews to build functions for data link expressions
		var i, node, tagName, converter, params, hash, hasTag, hasEncoder, getsVal, hasCnvt, useCnvt, tmplBindings, pathBindings,
			nestedTmpls, tmplName, nestedTmpl, tagAndElses, content, markup, nextIsElse, oldCode, isElse, isGetVal, prm, tagCtxFn,
			tmplBindingKey = 0,
			code = "",
			noError = "",
			tmplOptions = {},
			l = ast.length;

		if ("" + tmpl === tmpl) {
			tmplName = isLinkExpr ? 'data-link="' + tmpl.replace(rNewLine, " ").slice(1, -1) + '"' : tmpl;
			tmpl = 0;
		} else {
			tmplName = tmpl.tmplName || "unnamed";
			if (tmpl.allowCode) {
				tmplOptions.allowCode = true;
			}
			if (tmpl.debug) {
				tmplOptions.debug = true;
			}
			tmplBindings = tmpl.bnds;
			nestedTmpls = tmpl.tmpls;
		}
		for (i = 0; i < l; i++) {
			// AST nodes: [ tagName, converter, params, content, hash, noError, pathBindings, contentMarkup, link ]
			node = ast[i];

			// Add newline for each callout to t() c() etc. and each markup string
			if ("" + node === node) {
				// a markup string to be inserted
				code += '\nret+="' + node + '";';
			} else {
				// a compiled tag expression to be inserted
				tagName = node[0];
				if (tagName === "*") {
					// Code tag: {{* }}
					code += "" + node[1];
				} else {
					converter = node[1];
					params = node[2];
					content = node[3];
					hash = node[4];
					noError = node[5];
					markup = node[7];

					if (!(isElse = tagName === "else")) {
						tmplBindingKey = 0;
						if (tmplBindings && (pathBindings = node[6])) { // Array of paths, or false if not data-bound
							tmplBindingKey = tmplBindings.push(pathBindings);
						}
					}
					if (isGetVal = tagName === ":") {
						if (converter) {
							tagName = converter === "html" ? ">" : converter + tagName;
						}
						if (noError) {
							// If the tag includes noerror=true, we will do a try catch around expressions for named or unnamed parameters
							// passed to the tag, and return the empty string for each expression if it throws during evaluation
							//TODO This does not work for general case - supporting noError on multiple expressions, e.g. tag args and properties.
							//Consider replacing with try<a.b.c(p,q) + a.d, xxx> and return the value of the expression a.b.c(p,q) + a.d, or, if it throws, return xxx||'' (rather than always the empty string)
							prm = "prm" + i;
							noError = "try{var " + prm + "=[" + params + "][0];}catch(e){" + prm + '="";}\n';
							params = prm;
						}
					} else {
						if (content) {
							// Create template object for nested template
							nestedTmpl = TmplObject(markup, tmplOptions);
							nestedTmpl.tmplName = tmplName + "/" + tagName;
							// Compile to AST and then to compiled function
							buildCode(content, nestedTmpl);
							nestedTmpls.push(nestedTmpl);
						}

						if (!isElse) {
							// This is not an else tag.
							tagAndElses = tagName;
							// Switch to a new code string for this bound tag (and its elses, if it has any) - for returning the tagCtxs array
							oldCode = code;
							code = "";
						}
						nextIsElse = ast[i + 1];
						nextIsElse = nextIsElse && nextIsElse[0] === "else";
					}

					hash += ",args:[" + params + "]}";

					if (isGetVal && pathBindings || converter && tagName !== ">") {
						// For convertVal we need a compiled function to return the new tagCtx(s)
						tagCtxFn = new Function("data,view,j,u", " // "
									+ tmplName + " " + tmplBindingKey + " " + tagName + "\n" + noError + "return {" + hash + ";");
						tagCtxFn.paths = pathBindings;
						tagCtxFn._ctxs = tagName;
						if (isLinkExpr) {
							return tagCtxFn;
						}
						useCnvt = 1;
					}

					code += (isGetVal
						? "\n" + (pathBindings ? "" : noError) + (isLinkExpr ? "return " : "ret+=") + (useCnvt // Call _cnvt if there is a converter: {{cnvt: ... }} or {^{cnvt: ... }}
							? (useCnvt = 0, hasCnvt = true, 'c("' + converter + '",view,' + (pathBindings
								? ((tmplBindings[tmplBindingKey - 1] = tagCtxFn), tmplBindingKey) // Store the compiled tagCtxFn in tmpl.bnds, and pass the key to convertVal()
								: "{" + hash) + ");")
							: tagName === ">"
								? (hasEncoder = true, "h(" + params + ");")
								: (getsVal = true, "(v=" + params + ")!=" + (isLinkExpr ? "=" : "") + 'u?v:"";') // Strict equality just for data-link="title{:expr}" so expr=null will remove title attribute 
						)
						: (hasTag = true, "{tmpl:" // Add this tagCtx to the compiled code for the tagCtxs to be passed to renderTag()
							+ (content ? nestedTmpls.length: "0") + "," // For block tags, pass in the key (nestedTmpls.length) to the nested content template
							+ hash + ","));

					if (tagAndElses && !nextIsElse) {
						code = "[" + code.slice(0, -1) + "]"; // This is a data-link expression or the last {{else}} of an inline bound tag. We complete the code for returning the tagCtxs array
						if (isLinkExpr || pathBindings) {
							// This is a bound tag (data-link expression or inline bound tag {^{tag ...}}) so we store a compiled tagCtxs function in tmp.bnds
							code = new Function("data,view,j,u", " // " + tmplName + " " + tmplBindingKey + " " + tagAndElses + "\nreturn " + code + ";");
							if (pathBindings) {
								(tmplBindings[tmplBindingKey - 1] = code).paths = pathBindings;
							}
							code._ctxs = tagName;
							if (isLinkExpr) {
								return code; // For a data-link expression we return the compiled tagCtxs function
							}
						}

						// This is the last {{else}} for an inline tag.
						// For a bound tag, pass the tagCtxs fn lookup key to renderTag.
						// For an unbound tag, include the code directly for evaluating tagCtxs array
						code = oldCode + '\nret+=t("' + tagAndElses + '",view,this,' + (tmplBindingKey || code) + ");";
						pathBindings = 0;
						tagAndElses = 0;
					}
				}
			}
		}
		// Include only the var references that are needed in the code
		code = "// " + tmplName
			+ "\nvar j=j||" + (jQuery ? "jQuery." : "js") + "views"
			+ (getsVal ? ",v" : "")                      // gets value
			+ (hasTag ? ",t=j._tag" : "")                // has tag
			+ (hasCnvt ? ",c=j._cnvt" : "")              // converter
			+ (hasEncoder ? ",h=j.converters.html" : "") // html converter
			+ (isLinkExpr ? ";\n" : ',ret="";\n')
			+ ($viewsSettings.tryCatch ? "try{\n" : "")
			+ (tmplOptions.debug ? "debugger;" : "")
			+ code + (isLinkExpr ? "\n" : "\nreturn ret;\n")
			+ ($viewsSettings.tryCatch ? "\n}catch(e){return j._err(e);}" : "");
		try {
			code = new Function("data,view,j,u", code);
		} catch (e) {
			syntaxError("Compiled template code:\n\n" + code, e);
		}
		if (tmpl) {
			tmpl.fn = code;
		}
		return code;
	}

	function parseParams(params, bindings, tmpl) {

		//function pushBindings() { // Consider structured path bindings
		//	if (bindings) {
		//		named ? bindings[named] = bindings.pop(): bindings.push(list = []);
		//	}
		//}

		function parseTokens(all, lftPrn0, lftPrn, bound, path, operator, err, eq, path2, prn, comma, lftPrn2, apos, quot, rtPrn, rtPrnDot, prn2, space, index, full) {
			// rParams = /(\()(?=\s*\()|(?:([([])\s*)?(?:([#~]?[\w$.^]+)?\s*((\+\+|--)|\+|-|&&|\|\||===|!==|==|!=|<=|>=|[<>%*!:?\/]|(=))\s*|([#~]?[\w$.^]+)([([])?)|(,\s*)|(\(?)\\?(?:(')|("))|(?:\s*((\))(?=\s*\.|\s*\^)|\)|\])([([]?))|(\s+)/g,
			//          lftPrn        lftPrn2                 path    operator err                                                eq          path2       prn    comma   lftPrn2   apos quot      rtPrn rtPrnDot           prn2   space
			// (left paren? followed by (path? followed by operator) or (path followed by paren?)) or comma or apos or quot or right paren or space
			var expr;
			operator = operator || "";
			lftPrn = lftPrn || lftPrn0 || lftPrn2;
			path = path || path2;
			prn = prn || prn2 || "";

			function parsePath(all, object, helper, view, viewProperty, pathTokens, leafToken) {
				// rPath = /^(?:null|true|false|\d[\d.]*|([\w$]+|~([\w$]+)|#(view|([\w$]+))?)([\w$.^]*?)(?:[.[^]([\w$]+)\]?)?)$/g,
				//                                        object   helper    view  viewProperty pathTokens       leafToken
				if (object) {
					if (bindings) {
						if (named === "linkTo") {
							bindto = bindings.to = bindings.to || [];
							bindto.push(path);
						}
						if (!named || boundName) {
							bindings.push(path); // Add path binding for paths on props and args,
//							list.push(path);
						}
					}
					if (object !== ".") {
						var ret = (helper
								? 'view.hlp("' + helper + '")'
								: view
									? "view"
									: "data")
							+ (leafToken
								? (viewProperty
									? "." + viewProperty
									: helper
										? ""
										: (view ? "" : "." + object)
									) + (pathTokens || "")
								: (leafToken = helper ? "" : view ? viewProperty || "" : object, ""));

						ret = ret + (leafToken ? "." + leafToken : "");

						return ret.slice(0, 9) === "view.data"
							? ret.slice(5) // convert #view.data... to data...
							: ret;
					}
				}
				return all;
			}

			if (err) {
				syntaxError(params);
			} else {
				if (bindings && rtPrnDot && !aposed && !quoted) {
					// This is a binding to a path in which an object is returned by a helper/data function/expression, e.g. foo()^x.y or (a?b:c)^x.y
					// We create a compiled function to get the object instance (which will be called when the dependent data of the subexpression changes, to return the new object, and trigger re-binding of the subsequent path)
					if (!named || boundName || bindto) {
						expr = pathStart[parenDepth];
						if (full.length - 2 > index - expr) { // We need to compile a subexpression
							expr = full.slice(expr, index + 1);
							rtPrnDot = delimOpenChar1 + ":" + expr + delimCloseChar0; // The parameter or function subexpression
							rtPrnDot = tmplLinks[rtPrnDot] = tmplLinks[rtPrnDot] || tmplFn(delimOpenChar0 + rtPrnDot + delimCloseChar1, tmpl, true); // Compile the expression (or use cached copy already in tmpl.links)
							if (!rtPrnDot.paths) {
								parseParams(expr, rtPrnDot.paths = [], tmpl);
							}
							(bindto || bindings).push({_jsvOb: rtPrnDot}); // Insert special object for in path bindings, to be used for binding the compiled sub expression ()
							//list.push({_jsvOb: rtPrnDot});
						}
					}
				}
				return (aposed
					// within single-quoted string
					? (aposed = !apos, (aposed ? all : '"'))
					: quoted
					// within double-quoted string
						? (quoted = !quot, (quoted ? all : '"'))
						:
					(
						(lftPrn
								? (parenDepth++, pathStart[parenDepth] = index++, lftPrn)
								: "")
						+ (space
							? (parenDepth
								? ""
								//: (pushBindings(), named
								//	: ",")
								: named
									? (named = boundName = bindto = false, "\b")
									: ","
							)
							: eq
					// named param
					// Insert backspace \b (\x08) as separator for named params, used subsequently by rBuildHash
								? (parenDepth && syntaxError(params), named = path, boundName = bound, /*pushBindings(),*/ '\b' + path + ':')
								: path
					// path
									? (path.split("^").join(".").replace(rPath, parsePath)
										+ (prn
											? (fnCall[++parenDepth] = true, path.charAt(0) !== "." && (pathStart[parenDepth] = index), prn)
											: operator)
									)
									: operator
										? operator
										: rtPrn
					// function
											? ((fnCall[parenDepth--] = false, rtPrn)
												+ (prn
													? (fnCall[++parenDepth] = true, prn)
													: "")
											)
											: comma
												? (fnCall[parenDepth] || syntaxError(params), ",") // We don't allow top-level literal arrays or objects
												: lftPrn0
													? ""
													: (aposed = apos, quoted = quot, '"')
					))
				);
			}
		}

		var named, bindto, boundName, // list,
			tmplLinks = tmpl.links,
			fnCall = {},
			pathStart = {0:-1},
			parenDepth = 0,
			quoted = false, // boolean for string content in double quotes
			aposed = false; // or in single quotes

		//pushBindings();

		return (params + " ").replace(rParams, parseTokens);
	}

	//==========
	// Utilities
	//==========

	// Merge objects, in particular contexts which inherit from parent contexts
	function extendCtx(context, parentContext) {
		// Return copy of parentContext, unless context is defined and is different, in which case return a new merged context
		// If neither context nor parentContext are undefined, return undefined
		return context && context !== parentContext
			? (parentContext
				? $extend($extend({}, parentContext), context)
				: context)
			: parentContext && $extend({}, parentContext);
	}

	// Get character entity for HTML and Attribute encoding
	function getCharEntity(ch) {
		return charEntities[ch] || (charEntities[ch] = "&#" + ch.charCodeAt(0) + ";");
	}

	//========================== Initialize ==========================

	for (jsvStoreName in jsvStores) {
		registerStore(jsvStoreName, jsvStores[jsvStoreName]);
	}

	var $templates = $views.templates,
		$converters = $views.converters,
		$helpers = $views.helpers,
		$tags = $views.tags,
		$viewsSub = $views.sub,
		$viewsSettings = $views.settings;

	if (jQuery) {
		////////////////////////////////////////////////////////////////////////////////////////////////
		// jQuery is loaded, so make $ the jQuery object
		$ = jQuery;
		$.fn.render = renderContent;

	} else {
		////////////////////////////////////////////////////////////////////////////////////////////////
		// jQuery is not loaded.

		$ = global.jsviews = {};

		$.isArray = Array && Array.isArray || function(obj) {
			return Object.prototype.toString.call(obj) === "[object Array]";
		};

	//	//========================== Future Node.js support ==========================
	//	if ((nodeJsModule = global.module) && nodeJsModule.exports) {
	//		nodeJsModule.exports = $;
	//	}
	}

	$.render = $render;
	$.views = $views;
	$.templates = $templates = $views.templates;

	//========================== Register tags ==========================

	$tags({
		"else": function() {}, // Does nothing but ensures {{else}} tags are recognized as valid
		"if": {
			render: function(val) {
				// This function is called once for {{if}} and once for each {{else}}.
				// We will use the tag.rendering object for carrying rendering state across the calls.
				// If not done (a previous block has not been rendered), look at expression for this block and render the block if expression is truthy
				// Otherwise return ""
				var self = this,
					ret = (self.rendering.done || !val && (arguments.length || !self.tagCtx.index))
						? ""
						: (self.rendering.done = true, self.selected = self.tagCtx.index,
							// Test is satisfied, so render content on current context. We call tagCtx.render() rather than return undefined
							// (which would also render the tmpl/content on the current context but would iterate if it is an array)
							self.tagCtx.render());
				return ret;
			},
			onUpdate: function(ev, eventArgs, tagCtxs) {
				var tci, prevArg, different;
				for (tci = 0; (prevArg = this.tagCtxs[tci]) && prevArg.args.length; tci++) {
					prevArg = prevArg.args[0];
					different = !prevArg !== !tagCtxs[tci].args[0];
					if (!!prevArg || different) {
						return different;
						// If newArg and prevArg are both truthy, return false to cancel update. (Even if values on later elses are different, we still don't want to update, since rendered output would be unchanged)
						// If newArg and prevArg are different, return true, to update
						// If newArg and prevArg are both falsey, move to the next {{else ...}}
					}
				}
				// Boolean value of all args are unchanged (falsey), so return false to cancel update
				return false;
			},
			flow: true
		},
		"for": {
			render: function(val) {
				// This function is called once for {{for}} and once for each {{else}}.
				// We will use the tag.rendering object for carrying rendering state across the calls.
				var self = this,
					tagCtx = self.tagCtx,
					noArg = !arguments.length,
					result = "",
					done = noArg || 0;

				if (!self.rendering.done) {
					if (noArg) {
						result = undefined;
					} else if (val !== undefined) {
						result += tagCtx.render(val);
						// {{for}} (or {{else}}) with no argument will render the block content
						done += $.isArray(val) ? val.length : 1;
					}
					if (self.rendering.done = done) {
						self.selected = tagCtx.index;
					}
					// If nothing was rendered we will look at the next {{else}}. Otherwise, we are done.
				}
				return result;
			},
			//onUpdate: function(ev, eventArgs, tagCtxs) {
				//Consider adding filtering for perf optimization. However the below prevents update on some scenarios which _should_ update - namely when there is another array on which for also depends.
				//var i, l, tci, prevArg;
				//for (tci = 0; (prevArg = this.tagCtxs[tci]) && prevArg.args.length; tci++) {
				//	if (prevArg.args[0] !== tagCtxs[tci].args[0]) {
				//		return true;
				//	}
				//}
				//return false;
			//},
			onArrayChange: function(ev, eventArgs) {
				var arrayView,
					self = this,
					change = eventArgs.change;
				if (this.tagCtxs[1] && ( // There is an {{else}}
						   change === "insert" && ev.target.length === eventArgs.items.length // inserting, and new length is same as inserted length, so going from 0 to n
						|| change === "remove" && !ev.target.length // removing , and new length 0, so going from n to 0
						|| change === "refresh" && !eventArgs.oldItems.length !== !ev.target.length // refreshing, and length is going from 0 to n or from n to 0
					)) {
					this.refresh();
				} else {
					for (arrayView in self._.arrVws) {
						arrayView = self._.arrVws[arrayView];
						if (arrayView.data === ev.target) {
							arrayView._.onArrayChange.apply(arrayView, arguments);
						}
					}
				}
				ev.done = true;
			},
			flow: true
		},
		include: {
			flow: true
		},
		"*": {
			// {{* code... }} - Ignored if template.allowCode is false. Otherwise include code in compiled template
			render: function(value) {
				return value; // Include the code.
			},
			flow: true
		}
	});

	//========================== Register converters ==========================

	$converters({
		html: function(text) {
			// HTML encode: Replace < > & and ' and " by corresponding entities.
			return text != undefined ? String(text).replace(rHtmlEncode, getCharEntity) : ""; // null and undefined return ""
		},
		attr: function(text) {
			// Attribute encode: Replace < > & ' and " by corresponding entities.
			return text != undefined ? String(text).replace(rAttrEncode, getCharEntity) : text === null ? null : ""; // null returns null, e.g. to remove attribute. undefined returns ""
		},
		url: function(text) {
			// URL encoding helper.
			return text != undefined ? encodeURI(String(text)) : text === null ? null : ""; // null returns null, e.g. to remove attribute. undefined returns ""
		}
	});

	//========================== Define default delimiters ==========================
	$viewsDelimiters();

})(this, this.jQuery);
/*! JsObservable v1.0.0-alpha: http://github.com/BorisMoore/jsviews and http://jsviews.com/jsviews */
/*
 * Subcomponent of JsViews
 * Data change events for data-linking
 *
 * Copyright 2013, Boris Moore
 * Released under the MIT License.
 */
// informal pre beta commit counter: v1.0.0-alpha (40) (Beta Candidate)

(function(global, $, undefined) {
	// global is the this object, which is window when running in the usual browser environment.
	// $ is the global var jQuery or jsviews
	"use strict";

	if (!$) {
		throw "requires jQuery or JsRender";
	}
	if ($.observable) { return; } // JsObservable is already loaded

	//========================== Top-level vars ==========================

	var versionNumber = "v1.0.0-alpha",

		cbBindings, cbBindingsId, oldLength, _data,
		$eventSpecial = $.event.special,
		$viewsSub = $.views ? $.views.sub: {},
		cbBindingKey = 1,
		splice = [].splice,
		concat = [].concat,
		$isArray = $.isArray,
		$expando = $.expando,
		OBJECT = "object",
		propertyChangeStr = $viewsSub.propChng = $viewsSub.propChng || "propertyChange",// These two settings can be overridden on settings after loading
		arrayChangeStr = $viewsSub.arrChng = $viewsSub.arrChng || "arrayChange",        // jsRender, and prior to loading jquery.observable.js and/or JsViews
		cbBindingsStore = $viewsSub._cbBnds = $viewsSub._cbBnds || {},
		observeStr = propertyChangeStr + ".observe",
		$isFunction = $.isFunction,
		observeObjKey = 1,
		observeCbKey = 1,
		$hasData = $.hasData;

	//========================== Top-level functions ==========================

	function $observable(data) {
		return $isArray(data)
			? new ArrayObservable(data)
			: new ObjectObservable(data);
	}

	function ObjectObservable(data) {
		this._data = data;
		return this;
	}

	function ArrayObservable(data) {
		this._data = data;
		return this;
	}

	function wrapArray(data) {
		return $isArray(data)
			? [data]
			: data;
	}

	function validateIndex(index) {
		if (typeof index !== "number") {
			throw "Invalid index.";
		}
	}

	function resolvePathObjects(paths, root) {
		paths = $isArray(paths) ? paths : [paths];

		var i, path,
			object = root,
			nextObj = object,
			l = paths.length,
			out = [];

		for (i = 0; i < l; i++) {
			path = paths[i];
			if ($isFunction(path)) {
				splice.apply(out, [out.length,1].concat(resolvePathObjects(path.call(root, root), root)));
				continue;
			} else if ("" + path !== path) {
				root = nextObj = path;
				if (nextObj !== object) {
					out.push(object = nextObj);
				}
				continue;
			}
			if (nextObj !== object) {
				out.push(object = nextObj);
			}
			out.push(path);
		}
		return out;
	}

	function removeCbBindings(cbBindings, cbBindingsId) {
		// If the cbBindings collection is empty we will remove it from the cbBindingsStore
		var cb, found;

		for(cb in cbBindings) {
			found = true;
			break;
		}
		if (!found) {
			delete cbBindingsStore[cbBindingsId];
		}
	}

	function onObservableChange(ev, eventArgs) {
		if (!(ev.data && ev.data.off)) {
			// Skip if !!ev.data.off: - a handler that has already been removed (maybe was on handler collection at call time - then removed by another handler)
			var value = eventArgs.oldValue,
				ctx = ev.data;
			if (ev.type === arrayChangeStr) {
				ctx.cb.array(ev, eventArgs);
			} else if (ctx.prop === "*" || ctx.prop === eventArgs.path) {
				if (typeof value === OBJECT) {
					$unobserve(wrapArray(value), ctx.path, ctx.cb);
				}
				if (typeof (value = eventArgs.value) === OBJECT) {
					$observe(wrapArray(value), ctx.path, ctx.cb); // If value is an array, observe wrapped array, so that observe() doesn't flatten out this argument
				}
				ctx.cb(ev, eventArgs);
			}
		}
	}

	function $observe() {
		// $.observable.observe(root, [1 or more objects, path or path Array params...], callback[, contextCallback][, unobserveOrOrigRoot)
		function observeOnOff(namespace, pathStr, isArrayBinding, off) {
			var obIdExpando = $hasData(object),
				boundObOrArr = wrapArray(object);
			cbBindings = 0;
			if (unobserve || off) {
				if (obIdExpando) {
					$(boundObOrArr).off(namespace, onObservableChange);
					// jQuery off event does not provide the event data, with the callback and we need to remove this object from the corresponding bindings hash, cbBindingsStore[cb._bnd].
					// So we have registered a jQuery special 'remove' event, which stored the cbBindingsStore[cb._bnd] bindings hash in the cbBindings var,
					// so we can immediately remove this object from that bindings hash.
					if (cbBindings) {
						delete cbBindings[$.data(object, "obId")];
					}
				}
			} else {
				if (events = obIdExpando && $._data(object)) {
					events = events && events.events;
					events = events && events[isArrayBinding ? arrayChangeStr : propertyChangeStr];
					el = events && events.length;

					while (el--) {
						if ((data = events[el].data) && data.cb === callback) {
							if (isArrayBinding) {
								// Duplicate exists, so skip. (This can happen e.g. with {^{for people ~foo=people}})
								return;
							} else if (pathStr === "*" && data.prop !== pathStr) {
								$(object).off(namespace + "." + data.prop, onObservableChange);
									// We remove this object from bindings hash (see above).
								if (cbBindings) {
									delete cbBindings[$.data(object, "obId")];
								}
							}
						}
					}
				}
				$(boundObOrArr).on(namespace, null, isArrayBinding ? { cb: callback } : { path: pathStr, prop: prop, cb: callback }, onObservableChange);
				if (bindings) {
					// Add object to bindings, and add the counter to the jQuery data on the object
					bindings[$.data(object, "obId") || $.data(object, "obId", observeObjKey++)] = object;
				}
			}
		}

		function onUpdatedExpression(exprOb, paths, unobserve) {
			// Use the contextCb callback to execute the compiled exprOb template in the context of the view/data etc. to get the returned value, typically an object or array.
			// If it is an array, register array binding
			exprOb._ob = contextCb(exprOb, origRoot);
			var origRt = origRoot;
			return function() {
				var obj = exprOb._ob,
					len = paths.length;
				if (typeof obj === OBJECT) {
					bindArray(obj, true);
					if (len) {
						$unobserve(wrapArray(obj), paths, callback, contextCb);
					}
				}
				obj = exprOb._ob = contextCb(exprOb, origRt);
				// Put the updated object instance onto the exprOb in the paths array, so subsequent string paths are relative to this object
				if (typeof obj === OBJECT) {
					bindArray(obj);
					if (len) {
						$observe(wrapArray(obj), paths, callback, contextCb, origRt);
					}
				}
			}
		}

		function bindArray(arr, unbind) {
			if (callback && callback.array && $isArray(arr)) {
				// This is a data-bound tag which has an onArrayChange handler, e.g. {^{for}}, and the leaf object is an array
				// - so we add the arrayChange binding
				var prevObj = object;
				object = arr;
				observeOnOff(arrayChangeStr + ".observe.obs" + callback._bnd, undefined, true, unbind);
				object = prevObj;
			}
		}

		var i, parts, prop, path, dep, object, unobserve, callback, cbId, el, data, events, contextCb, items, bindings, depth, innerCb,
			topLevel = 1,
			ns = observeStr,
			paths = concat.apply([], arguments),	// flatten the arguments
			lastArg = paths.pop(),
			origRoot = paths[0],
			root = "" + origRoot !== origRoot ? paths.shift() : undefined,	// First parameter is the root object, unless a string
			l = paths.length;

		origRoot = root;

		if ($isFunction(lastArg)) {
			callback = lastArg;
		} else {
			if (lastArg === true) {
				unobserve = lastArg;
			} else if (lastArg) {
				origRoot = lastArg;
				topLevel = 0;
			}
			lastArg = paths[l-1];
			if (l && lastArg === undefined || $isFunction(lastArg)) {
				callback = paths.pop(); // If preceding is callback this will be contextCb param - which may be undefined
				l--;
			}
		}
		if ($isFunction(paths[l-1])) {
			contextCb = callback;
			callback = paths.pop();
			l--;
		}

		// Use a unique namespace (e.g. obs7) associated with each observe() callback to allow unobserve to
		// remove onObservableChange handlers that wrap that callback
		ns += unobserve
			? (callback ? ".obs" + callback._bnd: "")
			: ".obs" + (cbId = callback._bnd = callback._bnd || observeCbKey++);

		if (unobserve && l === 0 && root) {
			$(root).off(observeStr, onObservableChange);
		}
		if (!unobserve) {
			bindings = cbBindingsStore[cbId] = cbBindingsStore[cbId] || {};
		}
		depth = 0;
		for (i = 0; i < l; i++) {
			path = paths[i];
			bindArray(object, unobserve);
			object = root;
			if ("" + path === path) {
				//path = path || "*"; // This ensures that foo(person) will depend on any changes in foo
				// - equivalent to foo(person.*) - were it legal, or to adding foo.depends = []
				parts = path.split("^");
				if (parts[1]) {
					// We bind the leaf, plus additional nodes based on depth.
					// "a.b.c^d.e" is depth 2, so listens to changes of e, plus changes of d and of c
					depth = parts[0].split(".").length;
					path = parts.join(".");
					depth = path.split(".").length - depth;
						// if more than one ^ in the path, the first one determines depth
				}
				if (contextCb && (items = contextCb(path, root))) {
					// If contextCb returns an array of objects and paths, we will insert them
					// into the sequence, replacing the current item (path)
					l += items.length - 1;
					splice.apply(paths, [i--, 1].concat(items));
					continue;
				}
				parts = path.split(".");
			} else {
				if (topLevel && !$isFunction(path)) {
					if (path._jsvOb) {
						if (!unobserve) {
							// This is a compiled function for binding to an object returned by a helper/data function.
							path._cb = innerCb = onUpdatedExpression(path, paths.slice(i+1));
							path._rt = origRoot;
							innerCb._bnd = callback._bnd; // Set the same cbBindingsStore key as for callback, so when callback is disposed, disposal of innerCb happens too. 
						}
						$observe(path._rt, paths.slice(0, i), path._cb, contextCb, unobserve);
						path = path._ob;
					}
					object = path; // For top-level calls, objects in the paths array become the origRoot for subsequent paths.
				}
				root = path;
				parts = [root];
			}
			while (object && typeof object === "object" && (prop = parts.shift()) !== undefined) {
				if ("" + prop === prop) {
					if (prop === "") {
						continue;
					}
					if ((parts.length < depth + 1) && !object.nodeType) {
						// Add observer for each token in path starting at depth, and on to the leaf
						if (!unobserve && (events = $hasData(object) && $._data(object))) {
							events = events.events;
							events = events && events.propertyChange;
							el = events && events.length;
							while (el--) { // Skip duplicates
								data = events[el].data;
								if (data && data.cb === callback && ((data.prop === prop && data.path === parts.join(".")) || data.prop === "*")) {
									break;
								}
							}
							if (el > -1) {
								// Duplicate binding found, so move on
								object = object[prop];
								continue;
							}
						}
						if (prop === "*") {
							if ($isFunction(object)) {
								if (dep = object.depends) {
									$observe(dep, callback, unobserve||origRoot);
								}
							} else {
								observeOnOff(ns, prop);
							}
							break;
						} else if (prop && !($isFunction(dep = object[prop]) && dep.depends)) {
							// If leaf is a computed observable (function with declared dependencies) we do not
							// currently observe 'swapping' of the observable - only changes in its dependencies.
							observeOnOff(ns + "." + prop, parts.join("."));
						}
					}
					prop = prop ? object[prop] : object;
				}
				if ($isFunction(prop)) {
					if (dep = prop.depends) {
						// This is a computed observable. We will observe any declared dependencies
						$observe(object, resolvePathObjects(dep, object), callback, contextCb, unobserve||wrapArray(origRoot));
					}
					break;
				}
				object = prop;
			}
		}
		bindArray(object, unobserve);
		if (cbId) {
			removeCbBindings(bindings, cbId);
		}

		// Return the bindings to the top-level caller, along with the cbId
		return { cbId: cbId, bnd: bindings, leaf: object };
	}

	function $unobserve() {
		[].push.call(arguments, true); // Add true as additional final argument
		return $observe.apply(this, arguments);
	}

	//========================== Initialize ==========================

	$.observable = $observable;
	$observable.Object = ObjectObservable;
	$observable.Array = ArrayObservable;
	$observable.observe = $observe;
	$observable.unobserve = $unobserve;

	ObjectObservable.prototype = {
		_data: null,

		data: function() {
			return this._data;
		},

		observe: function(paths, callback) {
			return $observe(this._data, paths, callback);
		},

		unobserve: function(paths, callback) {
			return $unobserve(this._data, paths, callback);
		},

		setProperty: function(path, value, nonStrict) {
			var leaf, key, pair, parts,
				self = this,
				object = self._data;

			path = path || "";
			if (object) {
				if ($isArray(path)) {
					// This is the array format generated by serializeArray. However, this has the problem that it coerces types to string,
					// and does not provide simple support of convertTo and convertFrom functions.
					key = path.length;
					while (key--) {
						pair = path[key];
						self.setProperty(pair.name, pair.value, nonStrict === undefined || nonStrict) //If nonStrict not specified, default to true;
					}
				} else if ("" + path !== path) {
					// Object representation where property name is path and property value is value.
					for (key in path) {
						self.setProperty(key, path[key], value);
					}
				} else if (path.indexOf($expando) < 0) {
					// Simple single property case.
					parts = path.split(".");
					while (object && parts.length > 1) {
						object = object[parts.shift()];
					}
					self._setProperty(object, parts.join("."), value, nonStrict);
				}
			}
			return self;
		},

		_setProperty: function(leaf, path, value, nonStrict) {
			var setter, getter,
				property = path ? leaf[path] : leaf;

			if ($isFunction(property)) {
				if (property.set) {
					// Case of property setter/getter - with convention that property is getter and property.set is setter
					getter = property;
					setter = property.set === true ? property : property.set;
					property = property.call(leaf); //get
				}
			}

			if (property !== value || nonStrict && property != value) { // Optional non-strict equality, since serializeArray, and form-based editors can map numbers to strings, etc.
				// Date objects don't support != comparison. Treat as special case.
				if (!(property instanceof Date) || property > value || property < value) {
					if (setter) {
						setter.call(leaf, value);	//set
						value = getter.call(leaf);	//get updated value
					} else {
						leaf[path] = value;
					}
					this._trigger(leaf, {path: path, value: value, oldValue: property});
				}
			}
		},

		_trigger: function(target, eventArgs) {
			$(target).triggerHandler(propertyChangeStr, eventArgs);
		}
	};

	ArrayObservable.prototype = {
		_data: null,

		data: function() {
			return this._data;
		},

		insert: function(index, data) {
			validateIndex(index);

			if (arguments.length > 1) {
				data = $isArray(data) ? data : [data];
				// data can be a single item (including a null/undefined value) or an array of items.
				// Note the provided items are inserted without being cloned, as direct feferences to the provided objects

				if (data.length) {
					this._insert(index, data);
				}
			}
			return this;
		},

		_insert: function(index, data) {
			_data = this._data;
			oldLength = _data.length;
			splice.apply(_data, [index, 0].concat(data));
			this._trigger({change: "insert", index: index, items: data});
		},

		remove: function(index, numToRemove) {
			validateIndex(index);

			numToRemove = (numToRemove === undefined || numToRemove === null) ? 1 : numToRemove;
			if (numToRemove && index > -1) {
				var items = this._data.slice(index, index + numToRemove);
				numToRemove = items.length;
				if (numToRemove) {
					this._remove(index, numToRemove, items);
				}
			}
			return this;
		},

		_remove: function(index, numToRemove, items) {
			_data = this._data;
			oldLength = _data.length;
			_data.splice(index, numToRemove);
			this._trigger({change: "remove", index: index, items: items});
		},

		move: function(oldIndex, newIndex, numToMove) {
			validateIndex(oldIndex);
			validateIndex(newIndex);

			numToMove = (numToMove === undefined || numToMove === null) ? 1 : numToMove;
			if (numToMove) {
				var items = this._data.slice(oldIndex, oldIndex + numToMove);
				this._move(oldIndex, newIndex, numToMove, items);
			}
			return this;
		},

		_move: function(oldIndex, newIndex, numToMove, items) {
			_data = this._data;
			oldLength = _data.length;
			_data.splice( oldIndex, numToMove );
			_data.splice.apply( _data, [ newIndex, 0 ].concat( items ) );
			this._trigger({change: "move", oldIndex: oldIndex, index: newIndex, items: items});
		},

		refresh: function(newItems) {
			var oldItems = this._data.slice(0);
			this._refresh(oldItems, newItems);
			return this;
		},

		_refresh: function(oldItems, newItems) {
			_data = this._data;
			oldLength = _data.length;
			splice.apply(_data, [0, _data.length].concat(newItems));
			this._trigger({change: "refresh", oldItems: oldItems});
		},

		_trigger: function(eventArgs) {
			var length = _data.length,
				$data = $([_data]);
			$data.triggerHandler(arrayChangeStr, eventArgs);
			if (length !== oldLength) {
				$data.triggerHandler(propertyChangeStr, {path: "length", value: length, oldValue: oldLength});
			}
		}
	};

	$eventSpecial[propertyChangeStr] = $eventSpecial[arrayChangeStr] = {
		// The jQuery 'off' method does not provide the event data from the event(s) that are being unbound, so we register
		// a jQuery special 'remove' event, and get the data.cb._bnd from the event here and provide the corresponding cbBindings hash via the
		// cbBindings var to the unobserve handler, so we can immediately remove this object from that bindings hash, after 'unobserving'.
		remove: function(evData) {
			if ((evData = evData.data) && (evData.off = 1, evData = evData.cb)) { //Set off=1 as marker for disposed event
				// Get the cb._bnd from ev.data.cb._bnd
				cbBindings = cbBindingsStore[cbBindingsId = evData._bnd];
			}
		},
		teardown: function(namespaces) {
			if (cbBindings) {
				delete cbBindings[$.data(this, "obId")];
				removeCbBindings(cbBindings, cbBindingsId);
			}
		}
	};
})(this, this.jQuery || this.jsviews);
/*! JsViews v1.0.0-alpha: http://github.com/BorisMoore/jsviews and http://jsviews.com/jsviews */
/*
* Interactive data-driven views using templates and data-linking.
* Requires jQuery, and jsrender.js (next-generation jQuery Templates, optimized for pure string-based rendering)
*    See JsRender at  http://github.com/BorisMoore/jsrender and http://jsviews.com/jsrender
*
* Copyright 2013, Boris Moore
* Released under the MIT License.
*/
// informal pre beta commit counter: v1.0.0-alpha (41) (Beta Candidate)

(function(global, $, undefined) {
	// global is the this object, which is window when running in the usual browser environment.
	// $ is the global var jQuery
	"use strict";

	if (!$) {
		// jQuery is not loaded.
		throw "requires jQuery"; // for Beta (at least) we require jQuery
	}

	if (!$.views) {
		// JsRender is not loaded.
		throw "requires JsRender"; // JsRender must be loaded before JsViews
	}

	if (!$.observable) {
		// JsRender is not loaded.
		throw "requires jquery.observable"; // jquery.observable.js must be loaded before JsViews
	}

	if ($.link) { return; } // JsViews is already loaded

	//========================== Top-level vars ==========================

	var versionNumber = "v1.0.0-alpha",

		LinkedView, activeBody, $view, rTag, delimOpenChar0, delimOpenChar1, delimCloseChar0, delimCloseChar1, linkChar, validate,
		document = global.document,
		$views = $.views,
		$viewsSub = $views.sub,
		$viewsSettings = $views.settings,
		$extend = $viewsSub.extend,
		topView = $viewsSub.View(undefined, "top"), // Top-level view
		$isFunction = $.isFunction,
		$templates = $views.templates,
		$observable = $.observable,
		$observe = $observable.observe,
		jsvAttrStr = "data-jsv",
		$viewsLinkAttr = $viewsSettings.linkAttr || "data-link",  // Allows override on settings prior to loading jquery.views.js

		// These two settings can be overridden on settings after loading jsRender, and prior to loading jquery.observable.js and/or JsViews
		propertyChangeStr = $viewsSettings.propChng = $viewsSettings.propChng || "propertyChange",
		arrayChangeStr = $viewsSub.arrChng = $viewsSub.arrChng || "arrayChange",

		cbBindingsStore = $viewsSub._cbBnds = $viewsSub._cbBnds || {},
		elementChangeStr = "change.jsv",
		onBeforeChangeStr = "onBeforeChange",
		onAfterChangeStr = "onAfterChange",
		onAfterCreateStr = "onAfterCreate",
		closeScript = '"></script>',
		openScript = '<script type="jsv',
		bindElsSel = "script,[" + jsvAttrStr + "]",
		linkViewsSel = bindElsSel + ",[" + $viewsLinkAttr + "]",
		fnSetters = {
			value: "val",
			input: "val",
			html: "html",
			text: "text"
		},
		valueBinding = { from: { fromAttr: "value" }, to: { toAttr: "value"} },
		oldCleanData = $.cleanData,
		oldJsvDelimiters = $viewsSettings.delimiters,
		error = $viewsSub.error,
		syntaxError = $viewsSub.syntaxError,
		// rFirstElem = /<(?!script)(\w+)([>]*\s+on\w+\s*=)?[>\s]/, // This was without the DomLevel0 test.
		rFirstElem = /<(?!script)(\w+)(?:[^>]*(on\w+)\s*=)?[^>]*>/,
		safeFragment = document.createDocumentFragment(),
		qsa = document.querySelector,

		// elContent maps tagNames which have only element content, so may not support script nodes.
		elContent = { ol: 1, ul: 1, table: 1, tbody: 1, thead: 1, tfoot: 1, tr: 1, colgroup: 1, dl: 1, select: 1, optgroup: 1 },
		badParent = {tr: "table"},
		// wrapMap provide appropriate wrappers for inserting innerHTML, used in insertBefore
		wrapMap = $viewsSettings.wrapMap = {
			option: [ 1, "<select multiple='multiple'>", "</select>" ],
			legend: [ 1, "<fieldset>", "</fieldset>" ],
			thead: [ 1, "<table>", "</table>" ],
			tr: [ 2, "<table><tbody>", "</tbody></table>" ],
			td: [ 3, "<table><tbody><tr>", "</tr></tbody></table>" ],
			col: [ 2, "<table><tbody></tbody><colgroup>", "</colgroup></table>" ],
			area: [ 1, "<map>", "</map>" ],
			svg: [1, "<svg>", "</svg>"],
			div: [1, "x<div>", "</div>"] // Needed in IE7 to serialize link tags correctly, insert comments correctly, etc.
		},
		voidElems = {br: 1, img: 1, input: 1, hr: 1, area: 1, base: 1, col: 1, link: 1, meta: 1,
			command: 1, embed: 1, keygen: 1, param: 1, source: 1, track: 1, wbr: 1},
		displayStyles = {},
		viewStore = { 0: topView },
		bindingStore = {},
		bindingKey = 1,
		rViewPath = /^#(view\.?)?/,
		rConvertMarkers = /(^|(\/>)|(<\/\w+>)|>|)(\s*)([#\/]\d+[_^])`(\s*)(<\w+(?=[\s\/>]))?|\s*(?:(<\w+(?=[\s\/>]))|(<\/\w+>)(\s*)|(\/>)\s*)/g,
		rOpenViewMarkers = /(#)()(\d+)(_)/g,
		rOpenMarkers = /(#)()(\d+)([_^])/g,
		rViewMarkers = /(?:(#)|(\/))(\d+)(_)/g,
		rOpenTagMarkers = /(#)()(\d+)(\^)/g,
		rMarkerTokens = /(?:(#)|(\/))(\d+)([_^])([-+@\d]+)?/g;

	wrapMap.optgroup = wrapMap.option;
	wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead;
	wrapMap.th = wrapMap.td;

	//========================== Top-level functions ==========================

	//===============
	// Event handlers
	//===============

	function elemChangeHandler(ev) {
		var setter, cancel, fromAttr, linkCtx, sourceValue, cvtBack, cnvtName, target, $source, view, binding, bindings, l, oldLinkCtx, onBeforeChange, onAfterChange, tag,
			source = ev.target,
			to = source._jsvBnd;

		// _jsvBnd is a string with the syntax: "&bindingId1&bindingId2"
		if (to) {
			bindings = to.slice(1).split("&");
			l = bindings.length;
			while (l--) {
				if (binding = bindingStore[bindings[l]]) {
					if (to = binding.to) {
						// The binding has a 'to' field, which is of the form [[targetObject, toPath], cvtBack]
						linkCtx = binding.linkCtx;
						view = linkCtx.view;
						tag = linkCtx.tag;
						$source = $(source);
						onBeforeChange = view.hlp(onBeforeChangeStr, linkCtx.ctx);
						onAfterChange = view.hlp(onAfterChangeStr, linkCtx.ctx);
						fromAttr = defaultAttr(source);
						setter = fnSetters[fromAttr];
						sourceValue = $isFunction(fromAttr) ? fromAttr(source) : setter ? $source[setter]() : $source.attr(fromAttr);
						cnvtName = to[1];
						to = to[0]; // [object, path]
						if (cnvtName) {
							if ($isFunction(cnvtName)) {
								cvtBack = cnvtName;
							} else {
								cvtBack = view.tmpl.converters;
								cvtBack = cvtBack && cvtBack[cnvtName] || $views.converters[cnvtName];
							}
						}
						if (cvtBack) {
							sourceValue = cvtBack.call(tag, sourceValue);
						}

						// Set linkCtx on view, dynamically, just during this handler call
						oldLinkCtx = view.linkCtx;
						view.linkCtx = linkCtx;
						if ((!onBeforeChange || !(cancel = onBeforeChange.call(view, ev, sourceValue) === false)) &&
								(!tag || !tag.onBeforeChange || !(cancel = tag.onBeforeChange(ev, sourceValue) === false)) &&
								sourceValue !== undefined) {
							if (tag && tag.onChange) {
								sourceValue = tag.onChange(sourceValue);
							}
							target = to[0]; // [object, path]
							if (sourceValue !== undefined && target) {
								target = target._jsvOb ? target._ob : target;
								if (tag) {
									tag._.chging = true; // marker to prevent tag change event triggering its own refresh
								}
								$observable(target).setProperty(to[2] || to[1], sourceValue);
								if (tag) {
									delete tag._.chging; // clear the marker
								}
								if (onAfterChange) {
									onAfterChange.call(linkCtx, ev);
								}
							}
						}
						view.linkCtx = oldLinkCtx;
						if (cancel) {
							ev.stopImmediatePropagation();
						}
					}
				}
			}
		}
	}

	function propertyChangeHandler(ev, eventArgs, linkFn) {
		var attr, setter, changed, sourceValue, css, tag, prevNode, nextNode, inlineTag,
			linkCtx = this,
			source = linkCtx.data,
			target = linkCtx.elem,
			cvt = linkCtx.convert,
			attrOrProp = "attr",
			parentElem = target.parentNode,
			targetElem = parentElem,
			$target = $(target),
			view = linkCtx.view,
			oldCtx = view.ctx,
			oldLinkCtx = view.linkCtx,
			onEvent = view.hlp(onBeforeChangeStr);

		// Set linkCtx and ctx on view, dynamically, just during this handler call
		view.linkCtx = linkCtx;
		view.ctx = linkCtx.ctx;

		if (parentElem && (!onEvent || !(eventArgs && onEvent.call(linkCtx, ev, eventArgs) === false))
				// If data changed, the ev.data is set to be the path. Use that to filter the handler action...
				&& !(eventArgs && ev.data.prop !== "*" && ev.data.prop !== eventArgs.path)) {

			if (eventArgs) {
				linkCtx.eventArgs = eventArgs;
			}
			if (!ev || eventArgs || linkCtx._initVal) {
				delete linkCtx._initVal;
				sourceValue = linkFn.call(view.tmpl, source, view, $views);
				// Compiled link expression for linkTag: return tagCtx or tagCtxs

				attr = linkCtx.attr || defaultAttr(target, true, cvt !== undefined);
				if (tag = linkCtx.tag) {
					// Existing tag instance
					if (tag._.chging || eventArgs && tag.onUpdate && tag.onUpdate(ev, eventArgs, sourceValue) === false || attr === "none") {
						// onUpdate returned false, or attr === "none",or this is an update coming from the tags own change event
						// - so don't refresh the tag: we just need to bind, and we are done
						observeAndBind(linkCtx, source, target);
						view.linkCtx = oldLinkCtx;
						return;
					}
					sourceValue = tag.tagName.slice(-1) === ":" // Call convertVal if it is a {{cvt:...}} - otherwise call renderTag
						? $views._cnvt(tag.tagName.slice(0, -1), view, sourceValue)
						: $views._tag(tag, view, view.tmpl, sourceValue);
				} else if (linkFn._ctxs) {
					// For {{: ...}} without a convert or convertBack, we already have the sourceValue, and we are done
					// For {{: ...}} with either cvt or cvtBack we call convertVal to get the sourceValue and instantiate the tag
					// If cvt is undefined then this is a tag, and we call renderTag to get the rendered content and instantiate the tag
					cvt = cvt === "" ? "true" : cvt; // If there is a cvtBack but no cvt, set cvt to "true"
					sourceValue = cvt // Call convertVal if it is a {{cvt:...}} - otherwise call renderTag
						? $views._cnvt(cvt, view, sourceValue) // convertVal
						: $views._tag(linkFn._ctxs, view, view.tmpl, sourceValue); // renderTag
					tag = view._.tag; // In both convertVal and renderTag we have instantiated a tag
					attr = linkCtx.attr || attr; // linkCtx.attr may have been set to tag.attr during tag instantiation in renderTag
				}
				if (tag) {
					// Initialize the tag with element references
					tag.parentElem = (linkCtx.expr || tag._elCnt) ? target : target.parentNode;
					prevNode = tag._prv;
					nextNode = tag._nxt;
					attr = tag.attr || attr;
					tag.refresh = refreshTag;
				}

				if ($isFunction(sourceValue)) {
					error(linkCtx.expr + ": missing parens");
				}

				if (attr === "visible") {
					attr = "css-display";
					sourceValue = sourceValue
					// Make sure we set the correct display style for showing this particular element ("block", "inline" etc.)
						? getElementDefaultDisplay(target)
						: "none";
				}
				if (css = attr.lastIndexOf("css-", 0) === 0 && attr.substr(4)) {
// Possible optimization for perf on integer values
//					prev = $.style(target, css);
//					if (+sourceValue === sourceValue) {
//						// support using integer data values, e.g. 100 for width:"100px"
//						prev = parseInt(prev);
//					}
//					if (changed = prev !== sourceValue) {
//						$.style(target, css, sourceValue);
//					}
					if (changed = $.style(target, css) !== sourceValue) {
						$.style(target, css, sourceValue);
					}
				} else if (attr !== "link") { // attr === "link" is for tag controls which do data binding but have no rendered output or target
					if (attr === "value") {
						if (target.type === "checkbox") {
							sourceValue = sourceValue && sourceValue !== "false";
							// The string value "false" can occur with data-link="checked{attr:expr}" - as a result of attr, and hence using convertVal()
							attrOrProp = "prop";
							attr = "checked";
							// We will set the "checked" property
							// We will compare this with the current value
						}
					} else if (attr === "radio") {
						// This is a special binding attribute for radio buttons, which corresponds to the default 'to' binding.
						// This allows binding both to value (for each input) and to the default checked radio button (for each input in named group,
						// e.g. binding to parent data).
						// Place value binding first: <input type="radio" data-link="value{:name} {:#get('data').data.currency:} " .../>
						// or (allowing any order for the binding expressions):
						// <input type="radio" value="{{:name}}" data-link="{:#get('data').data.currency:} value^{:name}" .../>

						if (target.value === ("" + sourceValue)) {
							// If the data value corresponds to the value attribute of this radio button input, set the checked property to true
							sourceValue = true;
							attrOrProp = "prop";
							attr = "checked";
						} else {
							// Otherwise, go straight to observeAndBind, without updating.
							// (The browser will remove the 'checked' attribute, when another radio button in the group is checked).
							observeAndBind(linkCtx, source, target);
							view.linkCtx = oldLinkCtx;
							return;
						}
					} else if (attr === "selected" || attr === "disabled" || attr === "multiple" || attr === "readlonly") {
						sourceValue = (sourceValue && sourceValue !== "false") ? attr : null;
						// Use attr, not prop, so when the options (for example) are changed dynamically, but include the previously selected value,
						// they will still be selected after the change
					}

					setter = fnSetters[attr];

					if (setter) {
						if (changed = tag || $target[setter]() !== sourceValue) {
							if (attr === "html") {
								if (tag) {
									inlineTag = tag._.inline;
									tag.refresh(sourceValue);
									if (!inlineTag && tag._.inline) {
										// data-linked tag: data-link="{tagname ...}" has been converted to inline
										// We will skip the observeAndBind call below, since the inserted tag binding above replaces that binding
										view.linkCtx = oldLinkCtx;
										return;
									}
								} else {
									// data-linked value: data-link="expr" or data-link="{:expr}" or data-link="{:expr:}" (with no convert or convertBack)
									$target.empty();
									targetElem = target;
									view.link(source, targetElem, prevNode, nextNode, sourceValue, tag && {tag: tag._tgId});
								}
							} else if (attr === "text" && !target.children[0]) {
								// This code is faster then $target,text()
								if (target.textContent !== undefined) {
									target.textContent = sourceValue;
								} else {
									target.innerText = sourceValue === null ? "" : sourceValue;
								}
							} else {
								$target[setter](sourceValue);
							}
// Removing this for now, to avoid side-effects when you programmatically set the value, and want the focus to stay on the text box
//							if (target.nodeName.toLowerCase() === "input") {
//								$target.blur(); // Issue with IE. This ensures HTML rendering is updated.
//							}
						}
					} else if (changed = $target[attrOrProp](attr) != sourceValue) {
						// Setting an attribute to undefined should remove the attribute
						$target[attrOrProp](attr, sourceValue === undefined && attrOrProp === "attr" ? null : sourceValue);
					}
				}

				if (eventArgs && changed && (onEvent = view.hlp(onAfterChangeStr))) {
					onEvent.call(linkCtx, ev, eventArgs);
				}
			}
			observeAndBind(linkCtx, source, target);

			// Remove dynamically added linkCtx and ctx from view
			view.linkCtx = oldLinkCtx;
			view.ctx = oldCtx;
		}
	}

	function arrayChangeHandler(ev, eventArgs) {
		var self = this,
			onBeforeChange = self.hlp(onBeforeChangeStr),
			onAfterChange = self.hlp(onAfterChangeStr);

		if (!onBeforeChange || onBeforeChange.call(ev, eventArgs) !== false) {
			if (eventArgs) {
				// This is an observable action (not a trigger/handler call from pushValues, or similar, for which eventArgs will be null)
				var action = eventArgs.change,
					index = eventArgs.index,
					items = eventArgs.items;

				switch (action) {
					case "insert":
						self.addViews(index, items);
						break;
					case "remove":
						self.removeViews(index, items.length);
						break;
					case "move":
						self.refresh(); // Could optimize this
						break;
					case "refresh":
						self.refresh();
						break;
						// Othercases: (e.g.undefined, for setProperty on observable object) etc. do nothing
				}
			}
			if (onAfterChange) {
				onAfterChange.call(this, ev, eventArgs);
			}
		}
	}

	//=============================
	// Utilities for event handlers
	//=============================

	function getElementDefaultDisplay(elem) {
		// Get the 'visible' display style for the element
		var testElem, nodeName,
			getComputedStyle = global.getComputedStyle,
			cStyle = (elem.currentStyle || getComputedStyle.call(global, elem, "")).display;

		if (cStyle === "none" && !(cStyle = displayStyles[nodeName = elem.nodeName])) {
			// Currently display: none, and the 'visible' style has not been cached.
			// We create an element to find the correct visible display style for this nodeName
			testElem = document.createElement(nodeName);
			document.body.appendChild(testElem);
			cStyle = (getComputedStyle ? getComputedStyle.call(global, testElem, "") : testElem.currentStyle).display;
			// Cache the result as a hash against nodeName
			displayStyles[nodeName] = cStyle;
			document.body.removeChild(testElem);
		}
		return cStyle;
	}

	function setArrayChangeLink(view) {
		// Add/remove arrayChange handler on view
		var handler, arrayBinding,
			data = view.data, // undefined if view is being removed
			bound = view._.bnd; // true for top-level link() or data-link="{for}", or the for tag instance for {^{for}} (or for any custom tag that has an onArrayChange handler)

		if (!view._.useKey && bound) {
			// This is an array view. (view._.useKey not defined => data is array), and is data-bound to collection change events

			if (arrayBinding = view._.bndArr) {
				// First remove the current handler if there is one
				$([arrayBinding[1]]).off(arrayChangeStr, arrayBinding[0]);
				view._.bndArr = undefined;
			}
			if (bound !== !!bound && bound._.inline) {
				// bound is not a boolean, so it is the data-linked tag that 'owns' this array binding - e.g. {^{for...}}
				if (data) {
					bound._.arrVws[view._.id] = view;
				} else {
					delete bound._.arrVws[view._.id]; // if view.data is undefined, view is being removed
				}
			} else if (data) {
				// If this view is not being removed, but the data array has been replaced, then bind to the new data array
				handler = function(ev) {
					if (!(ev.data && ev.data.off)) {
						// Skip if !!ev.data.off: - a handler that has already been removed (maybe was on handler collection at call time - then removed by another handler)
						// If view.data is undefined, do nothing. (Corresponds to case where there is another handler on the same data whose
						// effect was to remove this view, and which happened to precede this event in the trigger sequence. So although this
						// event has been removed now, it is still called since already on the trigger sequence)
						arrayChangeHandler.apply(view, arguments);
					}
				};
				$([data]).on(arrayChangeStr, handler);
				view._.bndArr = [handler, data];
			}
		}
	}

	function defaultAttr(elem, to, linkGetVal) {
		// to: true - default attribute for setting data value on HTML element; false: default attribute for getting value from HTML element
		// Merge in the default attribute bindings for this target element
		var nodeName = elem.nodeName.toLowerCase(),
			attr = $viewsSettings.merge[nodeName];
		return attr
			? (to
				? ((nodeName === "input" && elem.type === "radio") // For radio buttons, bind from value, but bind to 'radio' - special value.
					? "radio"
					: attr.to.toAttr)
				: attr.from.fromAttr)
			: to
				? linkGetVal ? "text" : "html" // Default innerText for data-link="a.b.c" or data-link="{:a.b.c}" - otherwise innerHTML
				: ""; // Default is not to bind from
	}

	//==============================
	// Rendering and DOM insertion
	//==============================

	function renderAndLink(view, index, tmpl, views, data, context, refresh) {
		var html, linkToNode, prevView, nodesToRemove, bindId,
			parentNode = view.parentElem,
			prevNode = view._prv,
			nextNode = view._nxt,
			elCnt = view._elCnt;

		if (prevNode && prevNode.parentNode !== parentNode) {
			error("Missing parentNode");
			// Abandon, since node has already been removed, or wrapper element has been inserted between prevNode and parentNode
		}

		if (refresh) {
			nodesToRemove = view.nodes();
			if (elCnt && prevNode && prevNode !== nextNode) {
				// This prevNode will be removed from the DOM, so transfer the view tokens on prevNode to nextNode of this 'viewToRefresh'
				transferViewTokens(prevNode, nextNode, parentNode, view._.id, "_", true);
			}

			// Remove child views
			view.removeViews(undefined, undefined, true);
			linkToNode = nextNode;

			if (elCnt) {
				prevNode = prevNode
					? prevNode.previousSibling
					: nextNode
						? nextNode.previousSibling
						: parentNode.lastChild;
			}

			// Remove HTML nodes
			$(nodesToRemove).remove();

			for (bindId in view._.bnds) {
				// The view bindings may have already been removed above in: $(nodesToRemove).remove();
				// If not, remove them here:
				removeViewBinding(bindId);
			}
		} else {
			// addViews. Only called if view is of type "array"
			if (index) {
				// index is a number, so indexed view in view array
				prevView = views[index - 1];
				if (!prevView) {
					return false; // If subview for provided index does not exist, do nothing
				}
				prevNode = prevView._nxt;
			}
			if (elCnt) {
				linkToNode = prevNode;
				prevNode = linkToNode
					? linkToNode.previousSibling         // There is a linkToNode, so insert after previousSibling, or at the beginning
					: parentNode.lastChild;              // If no prevView and no prevNode, index is 0 and there are the container is empty,
					// so prevNode = linkToNode = null. But if prevNode._nxt is null then we set prevNode to parentNode.lastChild
					// (which must be before the prevView) so we insert after that node - and only link the inserted nodes
			} else {
				linkToNode = prevNode.nextSibling;
			}
		}
		html = tmpl.render(data, context, view, refresh || index, view._.useKey && refresh, true);
		// Pass in self._.useKey as test for layout template (which corresponds to when self._.useKey > 0 and self.data is an array)

		// Link the new HTML nodes to the data
		view.link(data, parentNode, prevNode, linkToNode, html, prevView);
//}, 0);
	}

	//=====================
	// addBindingMarkers
	//=====================

	function addBindingMarkers(value, view, tmplBindingKey) {
		// Insert binding markers into the rendered template output, which will get converted to appropriate
		// data-jsv attributes (element-only content) or script marker nodes (phrasing or flow content), in convertMarkers,
		// within view.link, prior to inserting into the DOM. Linking will then bind based on these markers in the DOM.
		var id, tag, end;
		if (tmplBindingKey) {
			// This is a binding marker for a data-linked tag {^{...}}
			end = "^`";
			tag = view._.tag // This is {^{>...}} or {^{tag ...}} or {{cvt:...} - so tag was defined in convertVal or renderTag
				|| {         // This is {^{:...}} so tag is not yet defined
					_: {
						inline: true,
						bnd: tmplBindingKey
					},
					tagCtx: {
						view:view
					},
					flow: true
				};
			id = tag._tgId;
			tag.refresh = refreshTag;
			if (!id) {
				bindingStore[id = bindingKey++] = tag; // Store the tag temporarily, ready for databinding.
				// During linking, in addDataBinding, the tag will be attached to the linkCtx,
				// and then in observeAndBind, bindingStore[bindId] will be replaced by binding info.
				tag._tgId = "" + id;
			}
		} else {
			// This is a binding marker for a view
			// Add the view to the store of current linked views
			end = "_`";
			viewStore[id = view._.id] = view;
		}
		// Example: "_#23`TheValue_/23`"
		return "#" + id + end
			+ (value === undefined ? "" : value) // For {^{:name}} this gives the equivalent semantics to compiled (v=data.name)!=u?v:""; used in {{:name}} or data-link="name"
			+ "/" + id + end;
	}

	//==============================
	// Data-linking and data binding
	//==============================

	//---------------
	// observeAndBind
	//---------------

	function observeAndBind(linkCtx, source, target) { //TODO? linkFnArgs) {;
		var binding, l,
			linkedElem = linkCtx.linkedElem,
			cvtBk = linkCtx.convertBack,
			tag = linkCtx.tag,
			depends = [],
			bindId = linkCtx._bndId || "" + bindingKey++,
			handler = linkCtx._hdlr;

		delete linkCtx._bndId;

		if (tag) {
			// Use the 'depends' paths set on linkCtx.tag - which may have been set on declaration
			// or in events: init, render, onBeforeLink, onAfterLink etc.
			depends = tag.depends || depends;
			depends = $isFunction(depends) ? tag.depends(tag) : depends;
		}
		if (!linkCtx._depends || ("" + linkCtx._depends !== "" + depends)) {
			// Only bind the first time, or if the new depends (toString) has changed from when last bound
			if (linkCtx._depends) {
				// Unobserve previous binding
				$observe(source, linkCtx._depends, handler, true);
			}
			binding = $observe($.isArray(source) ? [source] : source , linkCtx.fn.paths || linkCtx.fn, depends, handler, linkCtx._ctxCb);
			// The binding returned by $observe has a bnd array with the source objects of the individual bindings.
			binding.elem = target; // The target of all the individual bindings
			binding.linkCtx = linkCtx;
			binding._tgId = bindId;
			// Add to the _jsvBnd on the target the view id and binding id - for unbinding when the target element is removed
			target._jsvBnd = target._jsvBnd || "";
			target._jsvBnd += "&" + bindId;
			if (linkedElem) {
				binding.to = [[], cvtBk];
				l = linkedElem.length;
				while (l--) {
					linkedElem[l]._jsvBnd = target._jsvBnd;
				}
			}
			linkCtx._depends = depends;
			// Store the binding key on the view, for disposal when the view is removed
			linkCtx.view._.bnds[bindId] = bindId;
			// Store the binding.
			bindingStore[bindId] = binding; // Note: If this corresponds to a data-linked tag, we are replacing the
			// temporarily stored tag by the stored binding. The tag will now be at binding.linkCtx.tag
			if (linkedElem || cvtBk !== undefined) {
				bindTo(binding, cvtBk);
			}
		}
	}

	//-------
	// $.link
	//-------

	function tmplLink(to, from, context, parentView, prevNode, nextNode) {
		return $link(this, to, from, context, parentView, prevNode, nextNode);
	}

	function $link(tmplOrLinkTag, to, from, context, parentView, prevNode, nextNode) {
		if (tmplOrLinkTag && to) {
			to = to.jquery ? to : $(to); // to is a jquery object or an element or selector

			if (!activeBody) {
				activeBody = document.body;
				$(activeBody).on(elementChangeStr, elemChangeHandler);
			}

			var i, k, html, vwInfos, view, placeholderParent, targetEl, oldCtx, oldData,
				onRender = addBindingMarkers,
				replaceMode = context && context.target === "replace",
				l = to.length;

			while (l--) {
				targetEl = to[l];

				if ("" + tmplOrLinkTag === tmplOrLinkTag) {
					// tmplOrLinkTag is a string: treat as data-link expression.

					view = $view(targetEl);
					oldCtx = view.ctx;
					view.ctx = context;
					addDataBinding(tmplOrLinkTag, targetEl, $view(targetEl), from);
					view.ctx = oldCtx;
				} else {
					parentView = parentView || $view(targetEl);

					if (tmplOrLinkTag.markup !== undefined) {
						// This is a call to template.link()
						if (parentView.link === false) {
							context = context || {};
							context.link = onRender = false; // If link=false, don't allow nested context to switch on linking
						}
						// Set link=false, explicitly, to disable linking within a template nested within a linked template
						if (replaceMode) {
							placeholderParent = targetEl.parentNode;
						}

						html = tmplOrLinkTag.render(from, context, parentView, undefined, undefined, onRender);
						// TODO Consider finding a way to bind data (link) within template without html being different for each view, the HTML can
						// be evaluated once outside the while (l--), and pushed into a document fragment, then cloned and inserted at each target.

						if (placeholderParent) {
							// This is target="replace" mode
							prevNode = targetEl.previousSibling;
							nextNode = targetEl.nextSibling;
							$.cleanData([targetEl], true);
							placeholderParent.removeChild(targetEl);

							targetEl = placeholderParent;
						} else {
							prevNode = nextNode = undefined; // When linking from a template, prevNode and nextNode parameters are ignored
							$(targetEl).empty();
						}
					} else if (tmplOrLinkTag !== true) {
						break;
					}

// TODO Consider deferred linking API feature on per-template basis - {@{ instead of {^{ which allows the user to see the rendered content
// before that content is linked, with better perceived perf. Have view.link return a deferred, and pass that to onAfterLink...
// or something along those lines.
// setTimeout(function() {

					if (targetEl._dfr && !nextNode) {
						// We are inserting new content and the target element has some deferred binding annotations,and there is no nextNode.
						// Those views may be stale views (that will be recreated in this new linking action) so we will first remove them
						// (if not already removed).
						vwInfos = viewInfos(targetEl._dfr, true, rOpenViewMarkers);

						for (i = 0, k = vwInfos.length; i < k; i++) {
							view = vwInfos[i];
							if ((view = viewStore[view.id]) && view.data !== undefined) {
								// If this is the _prv (prevNode) for a view, remove the view
								// - unless view.data is undefined, in which case it is already being removed
								view.parent.removeViews(view._.key, undefined, true);
							}
						}
						targetEl._dfr = "";
					}

					// Link the content of the element, since this is a call to template.link(), or to $(el).link(true, ...),
					oldData = parentView.data;
					oldCtx = parentView.ctx;
					parentView.data = from;
					parentView.ctx = context;
					parentView.link(from, targetEl, prevNode, nextNode, html);
					parentView.data = oldData;
					parentView.ctx = oldCtx;
//}, 0);
				}
			}
		}
		return to; // Allow chaining, to attach event handlers, etc.
	}

	//----------
	// view.link
	//----------

	function viewLink(outerData, parentNode, prevNode, nextNode, html, refresh) {
		// Optionally insert HTML into DOM using documentFragments (and wrapping HTML appropriately).
		// Data-link existing contents of parentNode, or the inserted HTML, if provided

		// Depending on the content model for the HTML elements, the standard data-linking markers inserted in the HTML by addBindingMarkers during
		// template rendering will be converted either to script marker nodes or, for element-only content sections, by data-jsv element annotations.

		// Data-linking will then add _prv and _nxt to views, where:
		//     _prv: References the previous node (script element of type "jsv123"), or (for elCnt=true), the first element node in the view
		//     _nxt: References the last node (script element of type "jsv/123"), or (for elCnt=true), the next element node after the view.

		//==== nested functions ====
		function convertMarkers(all, preceding, selfClose, closeTag, spaceBefore, id, spaceAfter, tag1, tag2, closeTag2, spaceAfterClose, selfClose2) {
			//rConvertMarkers = /(^|(\/>)|(<\/\w+>)|>|)(\s*)_([#\/]\d+_)`(\s*)(<\w+(?=[\s\/>]))?|\s*(?:(<\w+(?=[\s\/>]))|(<\/\w+>)(\s*)|(\/>)\s*)/g,
			//                 prec, slfCl, clTag,  spaceBefore, id,    spaceAfter, tag1,                  tag2,             clTag2,  sac   slfCl2,
			// Convert the markers that were included by addBindingMarkers in template output, to appropriate DOM annotations:
			// data-jsv attributes (for element-only content) or script marker nodes (within phrasing or flow content).

// TODO consider detecting 'quoted' contexts (attribute strings) so that attribute encoding does not need to encode >
// Currently rAttrEncode = /[><"'&]/g includes '>' encoding in order to avoid erroneous parsing of <span title="&lt;a/>">

			var endOfElCnt = "";
			tag = tag1 || tag2 || "";
			closeTag = closeTag || selfClose || closeTag2 || selfClose2;
			if (closeTag) {
				if (validate && (selfClose || selfClose2) && !voidElems[parentTag]) {
					syntaxError("'<" + parentTag + "... />' in:\n" + html);
				}
				prevElCnt = elCnt;
				parentTag = tagStack.shift();
				elCnt = elContent[parentTag];
				if (prevElCnt) {
					// If there are ids (markers since the last tag), move them to the defer string
					defer += ids;
					ids = "";
					if (!elCnt) {
						endOfElCnt = (closeTag2 || "") + openScript + "@" + defer + closeScript + (spaceAfterClose || "");
						defer = deferStack.shift();
					} else {
						defer += "-"; // Will be used for stepping back through deferred tokens
					}
				}
			}
			if (elCnt) {
				// elContent maps tagNames which have only element content, so may not support script nodes.
				// We are in element-only content, can remove white space, and use data-jsv attributes on elements as markers
				// Example: <tr data-jsv="/2_#6_"> - close marker for view 2 and open marker for view 6

				if (id) {
					// append marker for this id, to ids string
					ids += id;
				} else {
					preceding = (closeTag2 || selfClose2 || "");
				}
				if (tag) {
					preceding += tag;
					if (ids) {
						preceding += ' ' + jsvAttrStr + '="' + ids + '"';
						ids = "";
					}
				}
			} else {
				// We are in phrasing or flow content, so use script marker nodes
				// Example: <script type="jsv3/"></script> - data-linked tag, close marker
				preceding = id
					? (preceding + endOfElCnt + spaceBefore + openScript + id + closeScript + spaceAfter + tag)
					: endOfElCnt || all;
			}
			if (tag) {
				// If there are ids (markers since the last tag), move them to the defer string
				tagStack.unshift(parentTag);
				parentTag = tag.slice(1);
				if (tagStack[0] === badParent[parentTag]) {
					// TODO: move this to design-time validation check
					error('"' + parentTag + '" has incorrect parent tag');
				}
				if ((elCnt = elContent[parentTag]) && !prevElCnt) {
					deferStack.unshift(defer);
					defer = "";
				}
				prevElCnt = elCnt;
//TODO Consider providing validation which throws if you place <span> as child of <tr>, etc. - since if not caught,
//this can cause errors subsequently which are difficult to debug.
//				if (elContent[tagStack[0]]>2 && !elCnt) {
//					error(parentTag + " in " + tagStack[0]);
//				}
				if (defer && elCnt) {
					defer += "+"; // Will be used for stepping back through deferred tokens
				}
			}
			return preceding;
		}

		function processViewInfos(vwInfos, targetParent) {
			// If targetParent, we are processing viewInfos (which may include navigation through '+-' paths) and hooking up to the right parentElem etc.
			// (and elem may also be defined - the next node)
			// If no targetParent, then we are processing viewInfos on newly inserted content
			var deferPath, deferChar, bindChar, parentElem, id, onAftCr, deep,
				addedBindEls = [];

			// In elCnt context (element-only content model), prevNode is the first node after the open, nextNode is the first node after the close.
			// If both are null/undefined, then open and close are at end of parent content, so the view is empty, and its placeholder is the
			// 'lastChild' of the parentNode. If there is a prevNode, then it is either the first node in the view, or the view is empty and
			// its placeholder is the 'previousSibling' of the prevNode, which is also the nextNode.
			if (vwInfos) {
				//targetParent = targetParent || targetElem && targetElem.previousSibling;
				//targetParent = targetElem ? targetElem.previousSibling : targetParent;
				len = vwInfos.length;
				if (vwInfos.tokens.charAt(0) === "@") {
					// This is a special script element that was created in convertMarkers() to process deferred bindings, and inserted following the
					// target parent element - because no element tags were encountered to carry those binding tokens.
					targetParent = elem.previousSibling;
					elem.parentNode.removeChild(elem);
					elem = null;
				}
				len = vwInfos.length;
				while (len--) {
					vwInfo = vwInfos[len];
					//if (prevIds.indexOf(vwInfo.token) < 0) { // This token is a newly created view or tag binding
						bindChar = vwInfo.ch;
						if (deferPath = vwInfo.path) {
							// We have a 'deferred path'
							j = deferPath.length - 1;
							while (deferChar = deferPath.charAt(j--)) {
								// Use the "+" and"-" characters to navigate the path back to the original parent node where the deferred bindings ocurred
								if (deferChar === "+") {
									if (deferPath.charAt(j) === "-") {
										j--;
										targetParent = targetParent.previousSibling;
									} else {
										targetParent = targetParent.parentNode;
									}
								} else {
									targetParent = targetParent.lastChild;
								}
								// Note: Can use previousSibling and lastChild, not previousElementSibling and lastElementChild,
								// since we have removed white space within elCnt. Hence support IE < 9
							}
						}
						if (bindChar === "^") {
							if (tag = bindingStore[id = vwInfo.id]) {
								// The binding may have been deleted, for example in a different handler to an array collectionChange event
								// This is a tag binding
								deep = targetParent && (!elem || elem.parentNode !== targetParent);
								if (!elem || deep) {
									tag.parentElem = targetParent;
								}
								if (vwInfo.elCnt) {
									if (vwInfo.open) {
										if (targetParent) {
											// This is an 'open view' node (preceding script marker node,
											// or if elCnt, the first element in the view, with a data-jsv annotation) for binding
											targetParent._dfr = "#" + id + bindChar + (targetParent._dfr || "");
										}
									} else if (deep) {
										// There is no ._nxt so add token to _dfr. It is deferred.
										targetParent._dfr = "/" + id + bindChar + (targetParent._dfr || "");
									}
								}
								// This is an open or close marker for a data-linked tag {^{...}}. Add it to bindEls.
								addedBindEls.push([deep ? null : elem, vwInfo]);
							}
						} else if (view = viewStore[id = vwInfo.id]) {
							// The view may have been deleted, for example in a different handler to an array collectionChange event
							if (!view.link) {
								// If view is not already extended for JsViews, extend and initialize the view object created in JsRender, as a JsViews view
								view.parentElem = targetParent || elem && elem.parentNode || parentNode;
								$extend(view, LinkedView);
								view._.onRender = addBindingMarkers;
								view._.onArrayChange = arrayChangeHandler;
								setArrayChangeLink(view);
							}
							parentElem = view.parentElem;
							if (vwInfo.open) {
								// This is an 'open view' node (preceding script marker node,
								// or if elCnt, the first element in the view, with a data-jsv annotation) for binding
								view._elCnt = vwInfo.elCnt;
								if (targetParent) {
									targetParent._dfr = "#" + id + bindChar + (targetParent._dfr || "");
								} else {
									// No targetParent, so there is a ._nxt elem (and this is processing tokens on the elem)
									if (!view._prv) {
										parentElem._dfr = removeSubStr(parentElem._dfr, "#" + id + bindChar);
									}
									view._prv = elem;
								}
							} else {
								// This is a 'close view' marker node for binding
								if (targetParent && (!elem || elem.parentNode !== targetParent)) {
									// There is no ._nxt so add token to _dfr. It is deferred.
									targetParent._dfr = "/" + id + bindChar + (targetParent._dfr || "");
									view._nxt = undefined;
								} else if (elem) {
									// This view did not have a ._nxt, but has one now, so token may be in _dfr, and must be removed. (No longer deferred)
									if (!view._nxt) {
										parentElem._dfr = removeSubStr(parentElem._dfr, "/" + id + bindChar);
									}
									view._nxt = elem;
								}
								linkCtx = view.linkCtx;
								if (onAftCr = onAfterCreate || (view.ctx && view.ctx.onAfterCreate)) {
									onAftCr.call(linkCtx, view);
								}
							}
						//}
					}
				}
				len = addedBindEls.length;
				while (len--) {
					// These were added in reverse order to addedBindEls. We push them in BindEls in the correct order.
					bindEls.push(addedBindEls[len]);
				}
			}
			return !vwInfos || vwInfos.elCnt;
		}

		function getViewInfos(vwInfos) {
			// Used by view.childTags() and tag.childTags()
			// Similar to processViewInfos in how it steps through bindings to find tags. Only finds data-linked tags.
			var level, parentTag;

			if (len = vwInfos && vwInfos.length) {
				for (j = 0; j < len; j++) {
					vwInfo = vwInfos[j];
					if (get.id) {
						get.id = get.id !== vwInfo.id && get.id;
					} else {
						// This is an open marker for a data-linked tag {^{...}}, within the content of the tag whose id is get.id. Add it to bindEls.
						parentTag = tag = bindingStore[vwInfo.id].linkCtx.tag;
						if (!tag.flow) {
							if (!deep) {
								level = 1;
								while (parentTag = parentTag.parent) {
									level++;
								}
								tagDepth = tagDepth || level; // The level of the first tag encountered.
							}
							if ((deep || level === tagDepth) && (!tagName || tag.tagName === tagName)) {
								// Filter on top-level or tagName as appropriate
								tags.push(tag);
							}
						}
					}
				}
			}
		}

		function dataLink() {
			//================ Data-link and fixup of data-jsv annotations ================
			elems = qsa ? parentNode.querySelectorAll(linkViewsSel) : $(linkViewsSel, parentNode).get();
			l = elems.length;

			// The prevNode will be in the returned query, since we called markPrevOrNextNode() on it.
			// But it may have contained nodes that satisfy the selector also.
			if (prevNode) {
				// Find the last contained node of prevNode, to use as the prevNode - so we only link subsequent elems in the query
				prevNodes = qsa ? prevNode.querySelectorAll(linkViewsSel) : $(linkViewsSel, prevNode).get();
				prevNode = prevNodes.length ? prevNodes[prevNodes.length - 1] : prevNode;
			}
			tagDepth = 0;
			for (i = 0; i < l; i++) {
				elem = elems[i];
				if (prevNode && !found) {
					// If prevNode is set, not false, skip linking. If this element is the prevNode, set to false so subsequent elements will link.
					found = (elem === prevNode);
				} else if (nextNode && elem === nextNode) {
					// If nextNode is set then break when we get to nextNode
					break;
				} else if (elem.parentNode
					// elem has not been removed from DOM
						&& processInfos(viewInfos(elem, undefined, tags && rOpenTagMarkers))
						// If a link() call, processViewInfos() adds bindings to bindEls, and returns true for non-script nodes, for adding data-link bindings
						// If a childTags() call getViewInfos adds tag bindings to tags array.
							&& elem.getAttribute($viewsLinkAttr)) {
								bindEls.push([elem]);
							}
			}

			// Remove temporary marker script nodes they were added by markPrevOrNextNode
			unmarkPrevOrNextNode(prevNode, elCnt);
			unmarkPrevOrNextNode(nextNode, elCnt);

			if (get) {
				lazyLink && lazyLink.resolve();
				return;
			}

			if (elCnt && defer + ids) {
				// There are some views with elCnt, for which the open or close did not precede any HTML tag - so they have not been processed yet
				elem = nextNode;
				if (defer) {
					if (nextNode) {
						processViewInfos(viewInfos(defer + "+", true), nextNode);
					} else {
						processViewInfos(viewInfos(defer, true), parentNode);
					}
				}
				processViewInfos(viewInfos(ids, true), parentNode);
				// If there were any tokens on nextNode which have now been associated with inserted HTML tags, remove them from nextNode
				if (nextNode) {
					tokens = nextNode.getAttribute(jsvAttrStr);
					if (l = tokens.indexOf(prevIds) + 1) {
						tokens = tokens.slice(l + prevIds.length - 1);
					}
					nextNode.setAttribute(jsvAttrStr, ids + tokens);
				}
			}

			//================ Bind the data-linked elements and tags ================
			l = bindEls.length;
			for (i = 0; i < l; i++) {
				elem = bindEls[i];
				linkInfo = elem[1];
				elem = elem[0];
				if (linkInfo) {
					tag = bindingStore[linkInfo.id];
					linkCtx = tag.linkCtx;
					tag = linkCtx ? linkCtx.tag : tag;
					// The tag may have been stored temporarily on the bindingStore - or may have already been replaced by the actual binding
					if (linkInfo.open) {
						// This is an 'open linked tag' binding annotation for a data-linked tag {^{...}}
						if (elem) {
							tag.parentElem = elem.parentNode;
							tag._prv = elem;
						}
						tag._elCnt = linkInfo.elCnt;
						if (tag && (!tag.onBeforeLink || tag.onBeforeLink() !== false) && !tag._.bound) {
							// By default we data-link depth-first ("on the way in"), which is better for perf. But if a tag needs nested tags to be linked (refreshed)
							// first, before linking its content, then make onBeforeLink() return false. In that case we data-link depth-first, so nested tags will have already refreshed.
							tag._.bound = true;
							view = tag.tagCtx.view;
							addDataBinding(undefined, tag._prv, view, view.data||outerData, linkInfo.id);
						}

						tag._.linking = true;
					} else {
						tag._nxt = elem;
						if (tag._.linking) {
							// This is a 'close linked tag' binding annotation
							// Add data binding
							tagCtx = tag.tagCtx;
							view = tagCtx.view;
							tag.contents = getContents;
							tag.nodes = getNodes;
							tag.childTags = getChildTags;

							delete tag._.linking;
							callAfterLink(tag, tagCtx);
							if (!tag._.bound) {
								tag._.bound = true;
								addDataBinding(undefined, tag._prv, view, view.data||outerData, linkInfo.id);
							}
						}
					}
				} else {
					view = $view(elem);
					// Add data binding for a data-linked element (with data-link attribute)
					addDataBinding(elem.getAttribute($viewsLinkAttr), elem, view, view.data||outerData);
				}
			}
			lazyLink && lazyLink.resolve();
		}
		//==== /end of nested functions ====

		var linkCtx, tag, i, l, j, len, elems, elem, view, vwInfos, vwInfo, linkInfo, prevNodes, token, prevView, nextView, node, tags, deep, tagName, tagCtx, cvt,
			tagDepth, get, depth, fragment, copiedNode, firstTag, parentTag, wrapper, div, tokens, elCnt, prevElCnt, htmlTag, ids, prevIds, found, lazyLink, linkedElem,
			noDomLevel0 = $viewsSettings.noDomLevel0,
			self = this,
			thisId = self._.id + "_",
			defer = "",
			// The marker ids for which no tag was encountered (empty views or final closing markers) which we carry over to container tag
			bindEls = [],
			tagStack = [],
			deferStack = [],
			onAfterCreate = self.hlp(onAfterCreateStr),
			processInfos = processViewInfos;

		if (refresh) {
			lazyLink = refresh.lazyLink && $.Deferred();
			if (refresh.tmpl) {
				// refresh is the prevView, passed in from addViews()
				prevView = "/" + refresh._.id + "_";
			} else {
				get = refresh.get;
				if (refresh.tag) {
					thisId = refresh.tag + "^";
					refresh = true;
				}
			}
			refresh = refresh === true;
		}

		if (get) {
			processInfos = getViewInfos;
			tags = get.tags;
			deep = get.deep;
			tagName = get.name;
		}

		parentNode = parentNode
			? ("" + parentNode === parentNode
				? $(parentNode)[0]  // It is a string, so treat as selector
				: parentNode.jquery
					? parentNode[0] // A jQuery object - take first element.
					: parentNode)
			: (self.parentElem      // view.link()
				|| document.body);  // link(null, data) to link the whole document

		parentTag = parentNode.tagName.toLowerCase();
		elCnt = !!elContent[parentTag];

		prevNode = prevNode && markPrevOrNextNode(prevNode, elCnt);
		nextNode = nextNode && markPrevOrNextNode(nextNode, elCnt) || null;

		if (html !== undefined) {
			//================ Insert html into DOM using documentFragments (and wrapping HTML appropriately). ================
			// Also convert markers to DOM annotations, based on content model.
			// Corresponds to nextNode ? $(nextNode).before(html) : $(parentNode).html(html);
			// but allows insertion to wrap correctly even with inserted script nodes. jQuery version will fail e.g. under tbody or select.
			// This version should also be slightly faster
			div = document.createElement("div");
			wrapper = div;
			prevIds = ids = "";
			htmlTag = parentNode.namespaceURI === "http://www.w3.org/2000/svg" ? "svg" : (firstTag = rFirstElem.exec(html)) && firstTag[1] || "";
			if (noDomLevel0 && firstTag && firstTag[2]) {
				error("Unsupported: " + firstTag[2]); // For security reasons, don't allow insertion of elements with onFoo attributes.
			}
			if (elCnt) {
				// Now look for following view, and find its tokens, or if not found, get the parentNode._dfr tokens
				node = nextNode;
				while (node && !(nextView = viewInfos(node))) {
					node = node.nextSibling;
				}
				if (tokens = nextView ? nextView.tokens : parentNode._dfr) {
					token = prevView || "";
					if (refresh || !prevView) {
						token += "#" + thisId;
					}
					j = tokens.indexOf(token);
					if (j + 1) {
						j += token.length;
						// Transfer the initial tokens to inserted nodes, by setting them as the ids variable, picked up in convertMarkers
						prevIds = ids = tokens.slice(0, j);
						tokens = tokens.slice(j);
						if (nextView) {
							node.setAttribute(jsvAttrStr, tokens);
						} else {
							parentNode._dfr = tokens;
						}
					}
				}
			}

			//================ Convert the markers to DOM annotations, based on content model. ================
//			oldElCnt = elCnt;
			html = ("" + html).replace(rConvertMarkers, convertMarkers);
//			if (!!oldElCnt !== !!elCnt) {
//				error("Parse: " + html); // Parse error. Content not well-formed?
//			}
			// Append wrapper element to doc fragment
			safeFragment.appendChild(div);

			// Go to html and back, then peel off extra wrappers
			// Corresponds to jQuery $(nextNode).before(html) or $(parentNode).html(html);
			// but supports svg elements, and other features missing from jQuery version (and this version should also be slightly faster)
			htmlTag = wrapMap[htmlTag] || wrapMap.div;
			depth = htmlTag[0];
			wrapper.innerHTML = htmlTag[1] + html + htmlTag[2];
			while (depth--) {
				wrapper = wrapper.lastChild;
			}
			safeFragment.removeChild(div);
			fragment = document.createDocumentFragment();
			while (copiedNode = wrapper.firstChild) {
				fragment.appendChild(copiedNode);
			}
			// Insert into the DOM
			parentNode.insertBefore(fragment, nextNode);
		}

		if (lazyLink) {
			setTimeout(dataLink, 0);
		} else {
			dataLink();
		}

		return lazyLink && lazyLink.promise();
	}

	function addDataBinding(linkMarkup, node, currentView, data, boundTagId) {
		// Add data binding for data-linked elements or {^{...}} data-linked tags
		var tmpl, tokens, attr, convertBack, params, trimLen, tagExpr, linkFn, linkCtx, tag, rTagIndex;

		if (boundTagId) {
			// {^{...}} data-linked tag. So only one linkTag in linkMarkup
			tag = bindingStore[boundTagId];
			tag = tag.linkCtx ? tag.linkCtx.tag : tag;

			linkCtx = tag.linkCtx || {
				data: data,             // source
				elem: tag._elCnt ? tag.parentElem : node,             // target
				view: currentView,
				ctx: currentView.ctx,
				attr: "html", // Script marker nodes are associated with {^{ and always target HTML.
				fn: tag._.bnd,
				tag: tag,
				// Pass the boundTagId in the linkCtx, so that it can be picked up in observeAndBind
				_bndId: boundTagId
			};
			bindDataLinkTarget(linkCtx, linkCtx.fn);
		} else if (linkMarkup && node) {
			// Compiled linkFn expressions could be stored in the tmpl.links array of the template
			// TODO - consider also caching globally so that if {{:foo}} or data-link="foo" occurs in different places,
			// the compiled template for this is cached and only compiled once...
			//links = currentView.links || currentView.tmpl.links;

			tmpl = currentView.tmpl;

//			if (!(linkTags = links[linkMarkup])) {
			// This is the first time this view template has been linked, so we compile the data-link expressions, and store them on the template.

				linkMarkup = normalizeLinkTag(linkMarkup, node);
				rTag.lastIndex = 0;
				while (tokens = rTag.exec(linkMarkup)) { // TODO require } to be followed by whitespace or $, and remove the \}(!\}) option.
					// Iterate over the data-link expressions, for different target attrs,
					// (only one if there is a boundTagId - the case of data-linked tag {^{...}})
					// e.g. <input data-link="{:firstName:} title{>~description(firstName, lastName)}"
					// tokens: [all, attr, bindOnly, tagExpr, tagName, converter, colon, html, comment, code, params]
					rTagIndex = rTag.lastIndex;
					attr = boundTagId ? "html" : tokens[1]; // Script marker nodes are associated with {^{ and always target HTML.
					tagExpr = tokens[3];
					params = tokens[10];
					convertBack = undefined;

					linkCtx = {
						data: data,             // source
						elem: tag && tag._elCnt ? tag.parentElem : node,             // target
						view: currentView,
						ctx: currentView.ctx,
						attr: attr,
						_initVal: !tokens[2]
					};

					if (tokens[6]) {
						// TODO include this in the original rTag regex
						// Only for {:} link"

						if (!attr && (convertBack = /:([\w$]*)$/.exec(params))) {
							// two-way binding
							convertBack = convertBack[1];
							if (convertBack !== undefined) {
								// There is a convertBack function
								trimLen = - convertBack.length -1;
								tagExpr = tagExpr.slice(0, trimLen - 1) + delimCloseChar0; // Remove the convertBack string from expression.
								params = params.slice(0, trimLen);
							}
						}
						if (convertBack === null) {
							convertBack = undefined;
						}
						linkCtx.convert = tokens[5] || "";
					}
					// Compile the linkFn expression which evaluates and binds a data-link expression
					// TODO - optimize for the case of simple data path with no conversion, helpers, etc.:
					//     i.e. data-link="a.b.c". Avoid creating new instances of Function every time. Can use a default function for all of these...

					linkCtx.expr = attr + tagExpr;
					linkFn = tmpl.links[tagExpr];
					if (!linkFn) {
						tmpl.links[tagExpr] = linkFn = $viewsSub.tmplFn(delimOpenChar0 + tagExpr + delimCloseChar1, tmpl, true, convertBack);
						$viewsSub.parse(params, linkFn.paths = [], tmpl); // TODO optimize - since parse(params) was already called within tmplFn()
					}
					linkCtx.fn = linkFn;
					if (!attr && convertBack !== undefined) {
						// Default target, so allow 2 way binding
						linkCtx.convertBack = convertBack;
					}

					bindDataLinkTarget(linkCtx, linkFn);
					// We store rTagIndex in local scope, since this addDataBinding method can sometimes be called recursively,
					// and each is using the same rTag instance.
					rTag.lastIndex = rTagIndex;
				}
	//		}
		}
	}

	function bindDataLinkTarget(linkCtx, linkFn) {
		// Add data link bindings for a link expression in data-link attribute markup
		function handler(ev, eventArgs) {
			propertyChangeHandler.call(linkCtx, ev, eventArgs, linkFn);
			// If the link expression uses a custom tag, the propertyChangeHandler call will call renderTag, which will set tagCtx on linkCtx
		}

// Consider for issue https://github.com/BorisMoore/jsviews/issues/158 arrayChange support on data-link etc.
		//handler.array = function() {
		//	...
		//}

		linkCtx._ctxCb = getContextCb(linkCtx.view); // _ctxCb is for filtering/appending to dependency paths: function(path, object) { return [(object|path)*]}
		linkCtx._hdlr = handler;
		if (linkCtx.tag && linkCtx.tag.onArrayChange) {
			handler.array = function(ev, eventArgs) {
				linkCtx.tag.onArrayChange(ev, eventArgs);
			};
		}
		handler(true);
	}

	//=====================
	// Data-linking helpers
	//=====================

	function removeSubStr(str, substr) {
		var k;
		return str
			? (k = str.indexOf(substr),
				(k + 1
					? str.slice(0, k) + str.slice(k + substr.length)
					: str))
			: "";
	}

	function markerNodeInfo(node) {
		return node &&
			("" + node === node
				? node
				: node.tagName === "SCRIPT"
					? node.type.slice(3)
					: node.nodeType === 1 && node.getAttribute(jsvAttrStr) || "");
	}

	function viewInfos(node, isVal, rBinding) {
		// Test whether node is a script marker nodes, and if so, return metadata
		function getInfos(all, open, close, id, ch, elPath) {
			infos.push({
				elCnt: elCnt,
				id: id,
				ch: ch,
				open: open,
				close: close,
				path: elPath,
				token: all
			});
		}
		var elCnt, tokens,
			infos = [];
		if (tokens = isVal ? node : markerNodeInfo(node)) {
			infos.elCnt = !node.type;
			elCnt = tokens.charAt(0) === "@" || !node.type;
			infos.tokens = tokens;
			// rMarkerTokens = /(?:(#)|(\/))(\d+)([_^])([-+@\d]+)?/g;
			tokens.replace(rBinding || rMarkerTokens, getInfos);
			return infos;
		}
	}

	function unmarkPrevOrNextNode(node, elCnt) {
		if (node) {
			if (node.type === "jsv") {
				node.parentNode.removeChild(node);
			} else if (elCnt && node.getAttribute($viewsLinkAttr) === "") {
				node.removeAttribute($viewsLinkAttr);
			}
		}
	}

	function markPrevOrNextNode(node, elCnt) {
		var marker = node;
		while (elCnt && marker && marker.nodeType !== 1) {
			marker = marker.previousSibling;
		}
		if (marker) {
			if (marker.nodeType !== 1) {
				// For text nodes, we will add a script node before
				marker = document.createElement("SCRIPT");
				marker.type = "jsv";
				node.parentNode.insertBefore(marker, node);
			} else if (!markerNodeInfo(marker) && !marker.getAttribute($viewsLinkAttr)) {
				// For element nodes, we will add a data-link attribute (unless there is already one)
				// so that this node gets included in the node linking process.
				marker.setAttribute($viewsLinkAttr, "");
			}
		}
		return marker;
	}

	function normalizeLinkTag(linkMarkup, node) {
		linkMarkup = $.trim(linkMarkup);
		return linkMarkup.slice(-1) !== delimCloseChar0
		// If simplified syntax is used: data-link="expression", convert to data-link="{:expression}",
		// or for inputs, data-link="{:expression:}" for (default) two-way binding
			? linkMarkup = delimOpenChar1 + ":" + linkMarkup + (defaultAttr(node) ? ":" : "") + delimCloseChar0
			: linkMarkup;
	}

	//===========================
	// Methods for views and tags
	//===========================

	function getContents(select, deep) {
		// For a view or a tag, return jQuery object with the content nodes,
		var filtered,
			nodes = $(this.nodes());
		if (nodes[0]) {
			filtered = select ? nodes.filter(select) : nodes;
			nodes = deep && select ? filtered.add(nodes.find(select)) : filtered;
		}
		return nodes;
	}

	function getNodes(withMarkers, prevNode, nextNode) {
		// For a view or a tag, return top-level nodes
		// Do not return any script marker nodes, unless withMarkers is true
		// Optionally limit range, by passing in prevNode or nextNode parameters

		var node,
			self = this,
			elCnt = self._elCnt,
			prevIsFirstNode = !prevNode && elCnt,
			nodes = [];

		prevNode = prevNode || self._prv;
		nextNode = nextNode || self._nxt;

		node = prevIsFirstNode
			? (prevNode === self._nxt
				? self.parentElem.lastSibling
				: prevNode)
			: (self._.inline === false
				? prevNode || self.linkCtx.elem.firstChild
				: prevNode && prevNode.nextSibling);

		while (node && (!nextNode || node !== nextNode)) {
			if (withMarkers || elCnt || !markerNodeInfo(node)) {
				// All the top-level nodes in the view
				// (except script marker nodes, unless withMarkers = true)
				// (Note: If a script marker node, viewInfo.elCnt undefined)
				nodes.push(node);
			}
			node = node.nextSibling;
		}
		return nodes;
	}

	function getChildTags(deep, tagName) {
		// For a view or a tag, return child tags - at any depth, or as immediate children only.
		if (deep !== !!deep) {
			// deep not boolean, so this is childTags(tagName) - which looks for top-level tags of given tagName
			tagName = deep;
			deep = undefined;
		}

		var self = this,
			view = self.link ? self : self.tagCtx.view, // this may be a view or a tag. If a tag, get the view from tag.view.tagCtx
			prevNode = self._prv,
			elCnt = self._elCnt,
			tags = [];

		if (prevNode) {
			view.link(
				undefined,
				self.parentElem,
				elCnt ? prevNode.previousSibling : prevNode,
				self._nxt,
				undefined,
				{get:{tags:tags, deep: deep, name: tagName, id: elCnt && self._tgId}}
			);
		}
		return tags;
	}

	function callAfterLink(tag, tagCtx) {
		var cvt, linkedElem, elem, isRadio, val, bindings, binding, i, l,
			linkCtx = tag.linkCtx = tag.linkCtx || {
				tag: tag,
				data: tagCtx.view.data
			};

		if (tag.onAfterLink) {
			tag.onAfterLink(tagCtx, linkCtx);
		}

		if ((linkedElem = linkCtx.linkedElem) && (elem = linkedElem[0])) {
			isRadio = elem.type === "radio";
			cvt = linkCtx.convert;
			val = cvt
				? ($isFunction(cvt)
					? cvt(tagCtx.args[0])
					: $views._cnvt(cvt, tagCtx.view, tagCtx))
				: tagCtx.args[0];

			if (elem !== linkCtx.elem) {
				l = linkedElem.length;
				while (l--) {
					elem = linkedElem[l];
					elem._jsvLnkdEl = true;
					if (tag._.inline) {
						// For data-linked tags, identify the linkedElem with the tag, for "to" binding
						// For data-linked elements, if not yet bound, we identify when the linkCtx.elem is bound
						elem._jsvBnd = linkCtx.elem ? linkCtx.elem._jsvBnd : tag._prv._jsvBnd;
						bindings = elem._jsvBnd.slice(1).split("&");
						i = bindings.length;
						while (i--) {
							bindTo(bindingStore[bindings[i]], linkCtx.convertBack);
						}
					}
					if (isRadio) {
						// For radio button, set to checked if val === value. For others set val() to val, below
						elem.checked = val === elem.value;
					}
				}
			}
			if (!isRadio) {
				if (elem.type === "checkbox") {
					elem.checked = val && val !== "false";
				} else {
					linkedElem.val(val);
				}
			}
		}
	}
	function bindTo(binding, cvtBk) {
		// Two-way binding.
		// We set the binding.to[1] to be the cvtBack, and  binding.to[0] to be either the path to the target, or [object, path] where the target is the path on the provided object.
		// So for a path with an object call: a.b.getObject().d.e, then we set to[0] to be [returnedObject, "d.e"], and we bind to the path on the returned object as target
		// Otherwise our target is the first path, paths[0], which we will convert with contextCb() for paths like ~a.b.c or #x.y.z
//TODO add support for two-way binding with bound named props and no bindto expression. <input data-link="{:a ^foo=b:}"
//- currently will not bind to the correct target - but bindto does gives workaround
		var bindto, pathIndex, lastPath, bindtoOb,
			lct =  binding.linkCtx,
			source = lct.data,
			paths = lct.fn.paths;
		if (binding) {
			if (bindto = paths.to) {
				paths = bindto;
			}
			pathIndex = paths.length;
			while (pathIndex && "" + (lastPath = paths[--pathIndex]) !== lastPath) {}; // If the lastPath is an object (e.g. with _jsvOb property), take preceding one
			if (lastPath) {
				lastPath = paths[pathIndex] = lastPath.split("^").join("."); // We don't need the "^" since binding has happened. For to binding, require just "."s
				binding.to = (lastPath.charAt(0) === "."
					? [[bindtoOb = paths[pathIndex-1], lastPath.slice(1)], cvtBk] // someexpr().lastpath - so need to get the bindtoOb object returned from the expression
					: [lct._ctxCb(paths[0]) || [source, paths[0]], cvtBk]);
				if (bindto && bindtoOb) {
					// This is a bindto binding {:expr bindto=someob().some.path:}
					// If it returned an object, we need to call the callback to get the object instance, so we bind to the final path (.some.path) starting from that object
					// TODO add unit tests for this scenario
					binding.to[0][0] = lct._ctxCb(bindtoOb, source);
				}
			} else {
				binding.to = [[], cvtBk];
			}
		}
	}

	function refreshTag(sourceValue) {
		var skipBinding, nodesToRemove, promise, cvt,
			tag = this,
			target = tag.parentElem,
			tagCtx = tag.tagCtx,
			view = tagCtx.view,
			prevNode = tag._prv,
			nextNode = tag._nxt,
			elCnt = tag._elCnt,
			inline = tag._.inline,
			props = tagCtx.props;

		if (tag.disposed) { error("Removed tag"); }
		if (sourceValue === undefined) {
			sourceValue = tag._.bnd.call(view.tmpl, view.data, view, $views); // get tagCtxs
			if (inline) {
				sourceValue = $views._tag(tag, view, view.tmpl, sourceValue); // get rendered HTML for tag
			}
		}
		if (!tag.flow && !tag.render && !tag.tagCtx.tmpl) {
			// We allow a data-linked tag control which does not render to set content on the data-linked element during init, onBeforeLink and onAfterLink
		} else if (inline) {
			nodesToRemove = tag.nodes(true);

			if (elCnt) {
				if (prevNode && prevNode !== nextNode) {
					// This prevNode will be removed from the DOM, so transfer the view tokens on prevNode to nextNode of this 'viewToRefresh'
					transferViewTokens(prevNode, nextNode, target, tag._tgId, "^", true);
				}
				prevNode = prevNode
					? prevNode.previousSibling
					: nextNode
						? nextNode.previousSibling
						: target.lastChild;
			}
			// Remove HTML nodes
			$(nodesToRemove).remove();
		} else {
			// data-linked value using converter(s): data-link="{cvt: ... :cvtBack}" or tag: data-link="{tagname ...}"
			if (!tag.flow && props.inline) {
				// data-link="{tagname ...}"
				view._.tag = tag;
				sourceValue = addBindingMarkers(sourceValue, view, true);
				view._.tag = undefined;
				skipBinding = tag._.inline = true;
			}

			$(target).empty();
		}
		// Data link the new contents of the target node
		if (!skipBinding && tag.onBeforeLink) {
			tag.onBeforeLink();
		}
		promise = view.link(view.data, target, prevNode, nextNode, sourceValue, tag && {tag: tag._tgId, lazyLink: props.lazyLink});
		if (!skipBinding && (tag.onAfterLink || tag.onLinkedInit)) {
			if (promise) {
				promise.then(function() {
					callAfterLink(tag, tagCtx);
				});
			} else {
				callAfterLink(tag, tagCtx);
			}
		}
		return promise || tag;
	}

	//=========
	// Disposal
	//=========

	function clean(elems) {
		// Remove data-link bindings, or contained views
		var j, l, l2, elem, vwInfos, vwItem, bindings,
			elemArray = [],
			len = elems.length,
			i = len;
		while (i--) {
			// Copy into an array, so that deletion of nodes from DOM will not cause our 'i' counter to get shifted
			// (Note: This seems as fast or faster than elemArray = [].slice.call(elems); ...)
			elemArray.push(elems[i]);
		}
		i = len;
		while (i--) {
			elem = elemArray[i];
			if (elem.parentNode) {
				// Has not already been removed from the DOM
				if ((bindings = elem._jsvBnd) &&  !elem._jsvLnkdEl) {
					// Get propertyChange bindings for this element
					// This may be an element with data-link, or the opening script marker node for a data-linked tag {^{...}}
					// bindings is a string with the syntax: "(&bindingId)*"
					bindings = bindings.slice(1).split("&");
					elem._jsvBnd = "";
					l = bindings.length;
					while (l--) {
						// Remove associated bindings
						removeViewBinding(bindings[l]); // unbind bindings with this bindingId on this view
					}
				}
				if (vwInfos = viewInfos(markerNodeInfo(elem) + (elem._dfr || ""), true, rOpenMarkers)) {
					for (j = 0, l2 = vwInfos.length; j < l2; j++) {
						vwItem = vwInfos[j];
						if (vwItem.ch === "_") {
							if ((vwItem = viewStore[vwItem.id]) && vwItem.data !== undefined) {
								// If this is the _prv (prevNode) for a view, remove the view
								// - unless view.data is undefined, in which case it is already being removed
								vwItem.parent.removeViews(vwItem._.key, undefined, true);
							}
						} else {
							removeViewBinding(vwItem.id); // unbind bindings with this bindingId on this view
						}
					}
				}
			}
		}
	}

	function removeViewBinding(bindId) {
		// Unbind
		var objId, linkCtx, tag, object, obsId,
			binding = bindingStore[bindId];
		if (binding) {
			for (objId in binding.bnd) {
				object = binding.bnd[objId];
				obsId = ".obs" + binding.cbId;
				if ($.isArray(object)) {
					$([object]).off(arrayChangeStr + obsId).off(propertyChangeStr + obsId); // There may be either or both of arrayChange and propertyChange
				} else {
					$(object).off(propertyChangeStr + obsId);
				}
				delete binding.bnd[objId];
			}

			linkCtx = binding.linkCtx;
			if (tag = linkCtx.tag) {
				if (tag.onDispose) {
					tag.onDispose();
				}
				if (!tag._elCnt) {
					tag._prv && tag._prv.parentNode.removeChild(tag._prv);
					tag._nxt && tag._nxt.parentNode.removeChild(tag._nxt);
				}
				tag.disposed = true;
			}
			delete linkCtx.view._.bnds[bindId];
			delete bindingStore[bindId];
			delete $viewsSub._cbBnds[binding.cbId];
		}
	}

	function $unlink(tmplOrLinkTag, to) {
		if (!arguments.length) {
			// Call to $.unlink() is equivalent to $.unlink(true, "body")
			if (activeBody) {
				$(activeBody).off(elementChangeStr, elemChangeHandler);
				activeBody = undefined;
			}
			tmplOrLinkTag = true;
			topView.removeViews();
			clean(document.body.getElementsByTagName("*"));
		} else if (to) {
			to = to.jquery ? to : $(to); // to is a jquery object or an element or selector
			if (tmplOrLinkTag === true) {
				// Call to $(el).unlink(true) - unlink content of element, but don't remove bindings on element itself
				$.each(to, function() {
					var innerView;
//TODO fix this for better perf. Rather that calling inner view multiple times which does querySelectorAll each time, consider a single querySelectorAll
// or simply call view.removeViews() on the top-level views under the target 'to' node, then clean(...)
					while ((innerView = $view(this, true)) && innerView.parent) {
						innerView.parent.removeViews(innerView._.key, undefined, true);
					}
					clean(this.getElementsByTagName("*"));
				});
			} else if (tmplOrLinkTag === undefined) {
				// Call to $(el).unlink()
				clean(to);
//TODO provide this unlink API
//			} else if ("" + tmplOrLinkTag === tmplOrLinkTag) {
//				// Call to $(el).unlink(tmplOrLinkTag ...)
//				$.each(to, function() {
//					...
//				});
			}
//TODO - unlink the content and the arrayChange, but not any other bindings on the element (if container rather than "replace")
		}
		return to; // Allow chaining, to attach event handlers, etc.
	}

	function tmplUnlink(to, from) {
		return $unlink(this, to, from);
	}

	//========
	// Helpers
	//========

	function getContextCb(view) {
		// TODO Consider exposing or allowing override, as public API
		view = view || $.view();
		return function(path, object) {
			// TODO consider only calling the contextCb on the initial token in path '~a.b.c' and not calling again on
			// the individual tokens, 'a', 'b', 'c'...  Currently it is called multiple times
			var tokens, tag,
				items = [object];
			if (view && path) {
				if (path._jsvOb){
					return path._jsvOb.call(view.tmpl, object, view, $views);
				}
				if (path.charAt(0) === "~") {
					// We return new items to insert into the sequence, replacing the "~a.b.c" string:
					// [helperObject 'a', "a.b.c" currentDataItem] so currentDataItem becomes the object for subsequent paths.
					if (path.slice(0, 4) === "~tag") {
						tag = view.ctx;
						if (path.charAt(4) === ".") {
							// "~tag.xxx"
							tokens = path.slice(5).split(".");
							tag = tag.tag;
						}
						if (tokens) {
							return tag ? [tag, tokens.join("."), object] : [];
						}
					}
					path = path.slice(1).split(".");
					if (object = view.hlp(path.shift())) {
						if (path.length) {
							items.unshift(path.join("."));
						}
						items.unshift(object);
					}
					return object ? items: [];
				}
				if (path.charAt(0) === "#") {
					// We return new items to insert into the sequence, replacing the "#a.b.c" string: [view, "a.b.c" currentDataItem]
					// so currentDataItem becomes the object for subsequent paths. The 'true' flag makes the paths bind only to leaf changes.
					return path === "#data" ? [] :[view, path.replace(rViewPath, ""), object];
				}
			}
		};
	}

	function inputAttrib(elem) {
		return elem.type === "checkbox" ? elem.checked : elem.value;
	}

	//========================== Initialize ==========================

	//=====================
	// JsRender integration
	//=====================

	$viewsSub.onStoreItem = function(store, name, item) {
		if (item && store === $templates) {
			item.link = tmplLink;
			item.unlink = tmplUnlink;
			if (name) {
				$.link[name] = function() {
					return tmplLink.apply(item, arguments);
				};
				$.unlink[name] = function() {
					return tmplUnlink.apply(item, arguments);
				};
			}
		}
	};

	// Initialize default delimiters
	($viewsSettings.delimiters = function() {
		var delimChars = oldJsvDelimiters.apply($views, arguments);
		delimOpenChar0 = delimChars[0];
		delimOpenChar1 = delimChars[1];
		delimCloseChar0 = delimChars[2];
		delimCloseChar1 = delimChars[3];
		linkChar = delimChars[4];
		rTag = new RegExp("(?:^|\\s*)([\\w-]*)(\\" + linkChar + ")?(\\" + delimOpenChar1 + $viewsSub.rTag + "\\" + delimCloseChar0 + ")", "g");

		// Default rTag:      attr  bind tagExpr   tag         converter colon html     comment            code      params
		//          (?:^|\s*)([\w-]*)(\^)?({(?:(?:(\w+(?=[\/\s}]))|(?:(\w+)?(:)|(>)|!--((?:[^-]|-(?!-))*)--|(\*)))\s*((?:[^}]|}(?!}))*?))})
		return this;
	})();

	//===============
	// Public helpers
	//===============

	$viewsSub.viewInfos = viewInfos;
	// Expose viewInfos() as public helper method

	//====================================
	// Additional members for linked views
	//====================================

	function transferViewTokens(prevNode, nextNode, parentElem, id, viewOrTagChar, refresh) {
		// Transfer tokens on prevNode of viewToRemove/viewToRefresh to nextNode or parentElem._dfr
		var i, l, vwInfos, vwInfo, viewOrTag, viewId, tokens,
			precedingLength = 0,
			emptyView = prevNode === nextNode;

		if (prevNode) {
			// prevNode is either the first node in the viewOrTag, or has been replaced by the vwInfos tokens string
			vwInfos = viewInfos(prevNode) || [];
			for (i = 0, l = vwInfos.length; i < l; i++) {
				// Step through views or tags on the prevNode
				vwInfo = vwInfos[i];
				viewId = vwInfo.id;
				if (viewId === id && vwInfo.ch === viewOrTagChar) {
					if (refresh) {
						// This is viewOrTagToRefresh, this is the last viewOrTag to process...
						l = 0;
					} else {
						// This is viewOrTagToRemove, so we are done...
						break;
					}
				}
				if (!emptyView) {
					viewOrTag = vwInfo.ch === "_"
						? viewStore[viewId]
						: bindingStore[viewId].linkCtx.tag;
					if (vwInfo.open) {
						// A "#m" token
						viewOrTag._prv = nextNode;
					} else if (vwInfo.close) {
						// A "/m" token
						viewOrTag._nxt = nextNode;
					}
				}
				precedingLength += viewId.length + 2;
			}

			if (precedingLength) {
				prevNode.setAttribute(jsvAttrStr, prevNode.getAttribute(jsvAttrStr).slice(precedingLength));
			}
			tokens = nextNode ? nextNode.getAttribute(jsvAttrStr) : parentElem._dfr;
			if (l = tokens.indexOf("/" + id + viewOrTagChar) + 1) {
				tokens = vwInfos.tokens.slice(0, precedingLength) + tokens.slice(l + (refresh ? -1 : id.length + 1));
			}
			if (tokens) {
				if (nextNode) {
					// If viewOrTagToRemove was an empty viewOrTag, we will remove both #n and /n
					// (and any intervening tokens) from the nextNode (=== prevNode)
					// If viewOrTagToRemove was not empty, we will take tokens preceding #n from prevNode,
					// and concatenate with tokens following /n on nextNode
					nextNode.setAttribute(jsvAttrStr, tokens);
				} else {
					parentElem._dfr = tokens;
				}
			}
		} else {
			// !prevNode, so there may be a deferred nodes token on the parentElem. Remove it.
			parentElem._dfr = removeSubStr(parentElem._dfr, "#" + id + viewOrTagChar);
			if (!refresh && !nextNode) {
				// If this viewOrTag is being removed, and there was no .nxt, remove closing token from deferred tokens
				parentElem._dfr = removeSubStr(parentElem._dfr, "/" + id + viewOrTagChar);
			}
		}
	}

	LinkedView = {
		// Note: a linked view will also, after linking have nodes[], _prv (prevNode), _nxt (nextNode) ...
		addViews: function(index, dataItems, tmpl) {
			// if view is not an array view, do nothing
			var i, viewsCount,
				self = this,
				itemsCount = dataItems.length,
				views = self.views;

			if (!self._.useKey && itemsCount && (tmpl = self.tmpl)) {
				// view is of type "array"
				// Use passed-in template if provided, since self added view may use a different template than the original one used to render the array.
				viewsCount = views.length + itemsCount;

				if (renderAndLink(self, index, tmpl, views, dataItems, self.ctx) !== false) {
					for (i = index + itemsCount; i < viewsCount; i++) {
						$observable(views[i]).setProperty("index", i);
						//This is fixing up index, but not key, and not index on child views. From child views, use view.get("item").index.
					}
				}
			}
			return self;
		},

		removeViews: function(index, itemsCount, keepNodes) {
			// view.removeViews() removes all the child views
			// view.removeViews( index ) removes the child view with specified index or key
			// view.removeViews( index, count ) removes the specified nummber of child views, starting with the specified index
			function removeView(index) {
				var id, bindId, parentElem, prevNode, nextNode, nodesToRemove,
					viewToRemove = views[index];

				if (viewToRemove && viewToRemove.link) {
					id = viewToRemove._.id;
					if (!keepNodes) {
						// Remove the HTML nodes from the DOM, unless they have already been removed, including nodes of child views
						nodesToRemove = viewToRemove.nodes();
					}

					// Remove child views, without removing nodes
					viewToRemove.removeViews(undefined, undefined, true);

					viewToRemove.data = undefined; // Set data to undefined: used as a flag that this view is being removed
					prevNode = viewToRemove._prv;
					nextNode = viewToRemove._nxt;
					parentElem = viewToRemove.parentElem;
					// If prevNode and nextNode are the same, the view is empty
					if (!keepNodes) {
						// Remove the HTML nodes from the DOM, unless they have already been removed, including nodes of child views
						if (viewToRemove._elCnt) {
							// if keepNodes is false (and transferring of tokens has not already been done at a higher level)
							// then transfer tokens from prevNode which is being removed, to nextNode.
							transferViewTokens(prevNode, nextNode, parentElem, id, "_");
						}
						$(nodesToRemove).remove();
					}
					if (!viewToRemove._elCnt) {
						prevNode.parentNode && parentElem.removeChild(prevNode);
						nextNode.parentNode && parentElem.removeChild(nextNode);
					}
					setArrayChangeLink(viewToRemove);
					for (bindId in viewToRemove._.bnds) {
						removeViewBinding(bindId);
					}
					delete viewStore[id];
				}
			}

			var current, view, viewsCount,
				self = this,
				isArray = !self._.useKey,
				views = self.views;

			if (isArray) {
				viewsCount = views.length;
			}
			if (index === undefined) {
				// Remove all child views
				if (isArray) {
					// views and data are arrays
					current = viewsCount;
					while (current--) {
						removeView(current);
					}
					self.views = [];
				} else {
					// views and data are objects
					for (view in views) {
						// Remove by key
						removeView(view);
					}
					self.views = {};
				}
			} else {
				if (itemsCount === undefined) {
					if (isArray) {
						// The parentView is data array view.
						// Set itemsCount to 1, to remove this item
						itemsCount = 1;
					} else {
						// Remove child view with key 'index'
						removeView(index);
						delete views[index];
					}
				}
				if (isArray && itemsCount) {
					current = index + itemsCount;
					// Remove indexed items (parentView is data array view);
					while (current-- > index) {
						removeView(current);
					}
					views.splice(index, itemsCount);
					if (viewsCount = views.length) {
						// Fixup index on following view items...
						while (index < viewsCount) {
							$observable(views[index]).setProperty("index", index++);
						}
					}
				}
			}
			return this;
		},

		refresh: function(context) {
			var self = this,
				parent = self.parent;

			if (parent) {
				renderAndLink(self, self.index, self.tmpl, parent.views, self.data, context, true);
				setArrayChangeLink(self);
			}
			return self;
		},

		nodes: getNodes,
		contents: getContents,
		childTags: getChildTags,
		link: viewLink
	};

	//=========================
	// Extend $.views.settings
	//=========================

	$viewsSettings.merge = {
		input: {
			from: { fromAttr: inputAttrib }, to: { toAttr: "value" }
		},
		textarea: valueBinding,
		select: valueBinding,
		optgroup: {
			from: { fromAttr: "label" }, to: { toAttr: "label" }
		}
	};

	if ($viewsSettings.debugMode) {
		// In debug mode create global for accessing views, etc
		validate = !$viewsSettings.noValidate;
		global._jsv = {
			views: viewStore,
			bindings: bindingStore
		};
	}

	//========================
	// Extend jQuery namespace
	//========================

	$extend($, {

		//=======================
		// jQuery $.view() plugin
		//=======================

		view: $views.view = $view = function(node, inner, type) {
			// $.view() returns top view
			// $.view(node) returns view that contains node
			// $.view(selector) returns view that contains first selected element
			// $.view(nodeOrSelector, type) returns nearest containing view of given type
			// $.view(nodeOrSelector, "root") returns root containing view (child of top view)
			// $.view(nodeOrSelector, true, type) returns nearest inner (contained) view of given type

			if (inner !== !!inner) {
				// inner not boolean, so this is view(nodeOrSelector, type)
				type = inner;
				inner = undefined;
			}
			var view, vwInfos, i, j, k, l, elem, elems,
				level = 0,
				body = document.body;

			if (node && node !== body && topView._.useKey > 1) {
				// Perf optimization for common cases

				node = "" + node === node
					? $(node)[0]
					: node.jquery
						? node[0]
						: node;

				if (node) {
					if (inner) {
						// Treat supplied node as a container element and return the first view encountered.
						elems = qsa ? node.querySelectorAll(bindElsSel) : $(bindElsSel, node).get();
						l = elems.length;
						for (i = 0; i < l; i++) {
							elem = elems[i];
							vwInfos = viewInfos(elem, undefined, rOpenViewMarkers);

							for (j = 0, k = vwInfos.length; j < k; j++) {
								view = vwInfos[j];
								if (view = viewStore[view.id]) {
									view = view && type ? view.get(true, type) : view;
									if (view) {
										return view;
									}
								}
							}
						}
					} else {
						while (node) {
							// Move back through siblings and up through parents to find preceding node which is a _prv (prevNode)
							// script marker node for a non-element-content view, or a _prv (first node) for an elCnt view
							if (vwInfos = viewInfos(node, undefined, rViewMarkers)) {
								l = vwInfos.length;
								while (l--) {
									view = vwInfos[l];
									if (view.open) {
										if (level < 1) {
											view = viewStore[view.id];
											return view && type ? view.get(type) : view || topView;
										}
										level--;
									} else {
										// level starts at zero. If we hit a view.close, then we move level to 1, and we don't return a view until
										// we are back at level zero (or a parent view with level < 0)
										level++;
									}
								}
							}
							node = node.previousSibling || node.parentNode;
						}
					}
				}
			}
			return inner ? undefined : topView;
		},

		link: $views.link = $link,
		unlink: $views.unlink = $unlink,

		//=====================
		// override $.cleanData
		//=====================
		cleanData: function(elems) {
			if (elems.length) {
				// Remove JsViews bindings. Also, remove from the DOM any corresponding script marker nodes
				clean(elems);
				// (elems HTMLCollection no longer includes removed script marker nodes)
				oldCleanData.call($, elems);
			}
		}
	});

	//===============================
	// Extend jQuery instance plugins
	//===============================

	$extend($.fn, {
		link: function(expr, from, context, parentView, prevNode, nextNode) {
			return $link(expr, this, from, context, parentView, prevNode, nextNode);
		},
		unlink: function(expr) {
			return $unlink(expr, this);
		},
		view: function(type) {
			return $view(this[0], type);
		}
	});

	//===============
	// Extend topView
	//===============

	$extend(topView, { tmpl: { links: {}, tags: {} }});
	$extend(topView, LinkedView);
	topView._.onRender = addBindingMarkers;

})(this, this.jQuery);
