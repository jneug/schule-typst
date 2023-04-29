#let ___s_options = state("@options", (
	__version: "0.0.1"
))

#let __getlocal( name, loc ) = {
	assert(type(loc) == "location", message: "loc needs to be a valid location")
	let dict = ___s_options.at(loc)
	if name in dict {
		dict.at(name)
	} else {
		none
	}
}

#let __getfinal( name, loc ) = {
	assert(type(loc) == "location", message: "loc needs to be a valid location")
	let dict = ___s_options.final(loc)
	if name in dict {
		dict.at(name)
	} else {
		none
	}
}

#let __get( name, func, default, final, loc ) = {
	let v = none
	if final {
		v = __getfinal(name, loc)
	} else {
		v = __getlocal(name, loc)
	}
	if v == none {
		v = default
	}
	if func != none {
		func(v)
	} else {
		v
	}
}

#let get( name, func, default:none, final:false, loc:none ) = {
	if loc == none {
		locate(l => {
			__get(name, func, default, final, l)
		})
	} else {
		__get(name, func, default, final, loc)
	}
}

#let update( name, value ) = {
	___s_options.update(o => {
		o.insert(name, value)
		o
	})
}

#let remove( name ) = {
	___s_options.update(o => {
		o.remove(name)
		o
	})
}

#let display( name, format: value => value, default:none, final:false ) = get(name, format, default:default, final:final)



// CONFIG
#let __s_config = state("@config", (:))

#let addconfig(
	name,
	type:     "string",
	required: false,
	default:  none,
	valid:    none,
	store:    true,
	pipe:     none,
	code:     none
) = {
	__s_config.update(c => {
		c.insert(name, (
			option:   "option",
			type:     type,
			name:     name,
			required: required,
			default:  default,
			valid:    valid,
			store:    store,
			pipe:     pipe,
			code:     code
		))
		c
	})
}

#let getconfig( name, final:false ) = {
	locate(loc => {
		let conf = __s_config.final(loc)
		if name in conf {
			conf.at(name)
		} else {
			none
		}
	})
}

#let parseconfig( unknown:none, ..args ) = {
	// Positional arguments
	// Not supported for now
	locate(loc => {
		let conf = __s_config.final(loc)
		let provided = args.named()

		for opt in conf.pairs() {
			let name = opt.at(0)
			let def  = opt.at(1)

			let value = none
			if name in provided {
				value = provided.at(name)
			} else if "required" in def and def.required {
				assert(name in provided, message:"Option '" + name + "' not provided but is required.")
			} else if "default" in def {
				value = def.default
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

			if "valid" in def and def.valid != none {
				let valid = (def.valid).flatten()
				assert(value in valid, message:"Value for option '" + name + "' not allowed: got '" + value + "' but expected one of '" + valid.join(", ") + "'")
			}

			if name in provided {
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
			if name in provided {
				if type(def.pipe) == "array" {
					for opt in def.pipe {
						if opt.len() >= 2 {
							provided.insert(opt.at(0), opt.at(1))
						}
					}
				}
			}
		}

		__s_config.update(conf)

		if unknown != none {
			for opt in provided.pairs() {
				if opt.at(0) not in conf {
					unknown(opt.at(0), opt.at(1))
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


#let arg( var, key, default ) = {
	if key in var.named() { var.named().at(key) }
	else if key in var.pos() { var.pos().at(key) }
	else { default }
}
#let extract( var, prefix:"", ..keys ) = {
	let vars = (:)
	for key in keys.named().pairs() {
		let k = prefix + key.at(0)

		if k in var.named() {
			vars.insert(key.at(0), var.named().at(k))
		} else {
			vars.insert(key.at(0), key.at(1))
		}
	}
	vars
}
