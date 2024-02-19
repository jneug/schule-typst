/*******************************\
|      Option handling and      |
|      argument parsing.        |
\*******************************/
#import "./states.typ"

#let __s_options_name = "@typopts-options"
#let __s_config_name = "@typopts-config"

// global state to store options
#let __s_options = state(__s_options_name, (:))
// global state to store configuration
#let __s_config  = state(__s_config_name, (:))


// Option storage

// get the proper option key from name
// and namespace values
#let __ns(name, ns) = {
	if ns != none {
		"ns:" + ns + "," + name
	} else {
		let dot = name.position(".")
		if dot != none {
			ns = name.slice(0,dot)
			name = name.slice(dot + 1)

			"ns:" + ns + "," + name
		} else {
			name
		}
	}
}

// Utilitiy function to get a local option
#let __get-local( name, loc, default ) = {
	assert(type(loc) == "location", message: "loc needs to be a valid location")
	return __s_options.at(loc).at(name, default:default)
}

// Utilitiy function to get a final option
#let __get-final( name, loc, default ) = {
	assert(type(loc) == "location", message: "loc needs to be a valid location")
	return __s_options.final(loc).at(name, default:default)
}

// Utilitiy function to get an option
#let __get( name, func, default, final, loc ) = {
	let v = none

	if final { v = __get-final(name, loc, default) }
	else { v = __get-local(name, loc, default) }

	if func != none { return func(v) }
	else { return v }
}

// Retrieve an option from the store if present,
// a default value otherwise.
#let get( name, func, default:none, final:false, loc:none, ns:none ) = {
	if loc == none {
		locate(l => {
			__get(__ns(name, ns), func, default, final, l)
		})
	} else {
		__get(__ns(name, ns), func, default, final, loc)
	}
}

// Update an option in the store to a new value.
#let update( name, value, ns:none ) = {
	__s_options.update(o => {
		o.insert(__ns(name, ns), value)
		o
	})
}

// Updates all options in the given dict to a new value.
#let update-all( values, ns:none ) = {
	__s_options.update(o => {
		for (name, value) in values {
			o.insert(__ns(name, ns), value)
		}
		o
	})
}

// Remove an option from the store.
#let remove( name, ns:none ) = {
	__s_options.update(o => {
		o.remove(__ns(name, ns))
		o
	})
}

// Display an option value with a format function.
#let display( name, format: value => value, default:none, final:false, ns:none ) = get(__ns(name, ns), format, default:default, final:final)

// File loading
#let load( filename, argparser:none ) = {
	let m = filename.match(regex("\.([^.]+)$"))
	if m != none {
		let loaders = (
			yml: yaml,
			yaml: yaml,
			toml: toml,
			json: json
		)
		let ext = m.captures.at(0)
		if ext in loaders {
			let data = loaders.at(ext)(filename)
			for (k,v) in data {
				if type(v) == "dict" {
					update-all(v, ns:k)
				} else {
					update(k, v)
				}
			}
		}
	}
}

// Argument parsing
#let argparser( unknown:none, ..args ) = {
	let arguments = (:)
	for arg in args.pos() {
		arguments.insert(arg.name, arg)
	}
	return (arguments: arguments, unknown: unknown)
}

#let saveparser( name, unknown:none, ..args ) = {
	let config = argparser(unknown:unknown, ..args)
	__s_config.update(o => {
		o.insert(name, config)
		o
	})
}

#let extendparser( name, ..args ) = {
	let config = argparser(..args)
	__s_config.update(o => {
		if not name in o {
			o.insert(name, config)
		} else {
			let old-config = o.at(name)
			old-config.arguments += config.arguments
			o.at(name) = old-config
		}
		o
	})
}

#let init-module( module ) = {
	if not module.ends-with(".typ") {
		module = module + ".typ"
	}
	import module: __init-options
	__init-options()
}

#let addarg( config, ..args ) = {
	for arg in args.pos() {
		config.arguments.insert(arg.name, arg)
	}
	return config
}

#let arg(
	name,
	kind:     "named",
	types:    ("string", "content"),
	ns:       none,
	store:    true,
	required: false,
	default:  none,
	choices:  none,
	pipe:     none,
	code:     none
) = {(
	option-type: kind,
	types:     types,
	name:     name,
	ns:       ns,
	store-option: store,
	required: required,
	default:  default,
	choices:  choices,
	pipe:     pipe,
	code:     code
)}
#let pos = arg.with(kind: "positional")

#let parsevalues( provided-pos, provided-named, config ) = {
	let pos = 0
	let values = (:)

	for (name, def) in config.arguments {
		let value = none
		if def.option-type == "positional" {
			if pos < provided-pos.len() {
				value = provided-pos.at(pos)
				pos += 1
			} else if "required" in def and def.required {
				assert(pos < provided-pos, message:"Positional argument '" + name + "' not provided but is required.")
			} else {
				value = def.default
			}
		} else {
			if name in provided-named {
				value = provided-named.at(name)
			} else if def.required {
				assert(name in provided-named, message:"Named argument '" + name + "' not provided but is required.")
			} else {
				value = def.default
			}
		}

		let types = ("none", def.types).flatten()
		assert(
			types.any(v => type(value) == v),
			message: "Wrong type for option '" + name + "': got '" + type(value) + "', but expected one of '" + types.join(", ", last:" or ") + "'"
		)

		if def.choices != none {
			let choices = (def.choices).flatten()
			assert(value in choices, message:"Value for option '" + name + "' not allowed: got '" + value + "' but expected one of '" + choices.join(", ", last:" or ") + "'")
		}

		if def.code != none {
			let func = def.code
			value = func(value)
		}

		values.insert(name, value)
		// config.at(name).insert("value", value)

		if type(def.pipe) == "array" {
			for oopt in def.pipe {
				if oopt.len() >= 2 {
					provided-named.insert(oopt.at(0), oopt.at(1))
				}
			}
		}
	}

	if config.unknown != none {
		for opt in provided-named.pairs() {
			if opt.at(0) not in config {
				config.unknown(opt.at(0), opt.at(1))
			}
		}
	}

	//config
	return values
}
#let parseargs( args, config ) = parsevalues(args.pos(), args.named(), config)
#let parseopts( args, config ) = locate(loc => {
	let conf = config
	if type(config) == "string" {
		//config = __s_config.get(loc)
		let o = __s_config.final(loc)
		if config in o {
			conf = o.at(config)
		} else {
			panic()
		}
	}
	let values = parsevalues(args.pos(), args.named(), conf)
	update-all(values)
})

#let ignore = none
#let store(k, v) = update(k, v)
#let fail(k, v) = {
	assert(false, message:"Unexpected option '" + k + "'")
}


// #let arg( var, key, default ) = {
// 	if key in var.named() { var.named().at(key) }
// 	else if key in var.pos() { var.pos().at(key) }
// 	else { default }
// }
#let extract( args, _prefix:"", _positional:false, ..keys ) = {
	let vars = (:)
	for key in keys.named().pairs() {
		let k = _prefix + key.at(0)

		if k in args.named() {
			vars.insert(key.at(0), args.named().at(k))
		} else {
			vars.insert(key.at(0), key.at(1))
		}
	}
	if _positional { return vars.values() }
	else { return vars }
}
