/*******************************\
|      Option handling and      |
|      argument parsing.        |
\*******************************/

// global state to store options
#let __s_options = state("@options", (:))
// global state to store configuration
#let __s_config   = state("@config", (:))


// Option storage

// get the proper optoin key from name
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
	values.pairs().map(v => update(..v, ns:ns))
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
#let load( filename ) = {
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
#let add-option(
	name,
	type:     ("string", "content"),
	required: false,
	default:  none,
	choices:  none,
	store:    true,
	pipe:     none,
	code:     none
) = {
	__s_config.update(c => {
		c.insert(name, (
			_option:  "positional",
			type:     type,
			name:     name,
			required: required,
			default:  default,
			choices:  choices,
			store:    store,
			pipe:     pipe,
			code:     code
		))
		c
	})
}

#let add-argument(
	name,
	type:     ("string", "content"),
	required: false,
	default:  none,
	choices:  none,
	store:    true,
	pipe:     none,
	code:     none
) = {
	__s_config.update(c => {
		c.insert(name, (
			_option:  "named",
			type:     type,
			name:     name,
			required: required,
			default:  default,
			choices:  choices,
			store:    store,
			pipe:     pipe,
			code:     code
		))
		c
	})
}

#let getconfig( name, final:false ) = {
	locate(loc => {
		//let conf = __s_config.final(loc)
		let conf = __s_config.at(loc)
		if name in conf {
			conf.at(name)
		} else {
			none
		}
	})
}

#let parseconfig( _unknown:none, _opts:none, ..args ) = {
	// Run additional module configurations
	if _opts != none {
		assert(type(_opts) == "array")
		for _addopts in _opts {
			_addopts()
		}
	}

	locate(loc => {
		//let conf = __s_config.final(loc)
		let conf = __s_config.at(loc)
		let provided-pos = args.pos()
		let provided-named = args.named()
		let pos = 0

		for opt in conf.pairs() {
			let name = opt.at(0)
			let def  = opt.at(1)

			let value = none
			if def._option == "positional" {
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
				} else if "required" in def and def.required {
					assert(name in provided-named, message:"Ma,ed argument '" + name + "' not provided but is required.")
				} else if "default" in def {
					value = def.default
				}
			}

			// assert(
			// 	value == none or type(value) == def.type,
			// 	message: "Wrong type for option '" + name + "': got '" + type(value) + "', but expected '" + def.type + "'"
			// )
			let types = ("none", def.type).flatten()
			assert(
				types.any(v => type(value) == v),
				message: "Wrong type for option '" + name + "': got '" + type(value) + "', but expected one of '" + types.join(", ") + "'"
			)

			if "choices" in def and def.choices != none {
				let choices = (def.choices).flatten()
				assert(value in choices, message:"Value for option '" + name + "' not allowed: got '" + value + "' but expected one of '" + choices.join(", ") + "'")
			}

			if name in provided-named {
				if "code" in def and def.code != none {
					let func = def.code
					if type(func) == "function" {
						value = func(value)
					}
				}
			}

			conf.at(name).insert("value", value)
			if def.store {
				update(name, value)
			}

			// TODO: Handle with pipe option
			if name in provided-named {
				if type(def.pipe) == "array" {
					for oopt in def.pipe {
						if oopt.len() >= 2 {
							provided-named.insert(oopt.at(0), oopt.at(1))
						}
					}
				}
			}
		}

		__s_config.update(conf)

		if _unknown != none {
			for opt in provided-named.pairs() {
				if opt.at(0) not in conf {
					_unknown(opt.at(0), opt.at(1))
				}
			}
		}
	})
}

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
#let extract( var, _prefix:"", _positional:false, ..keys ) = {
	let vars = (:)
	for key in keys.named().pairs() {
		let k = _prefix + key.at(0)

		if k in var.named() {
			vars.insert(key.at(0), var.named().at(k))
		} else {
			vars.insert(key.at(0), key.at(1))
		}
	}
	if _positional { return vars.values() }
	else { return vars }
}
