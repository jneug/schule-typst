#let _ab_highlight_doku = false

#let doc-data = yaml("./docs.yaml")

#let __content( string ) = {
	if type(string) == "string" {
		return eval("[" + string + "]")
	} else {
		return string
	}
}

#let __d_classheader( name, generic-type:none ) = {
	if generic-type != none [
		=== Die generische Klasse #name
	] else [
		=== Die Klasse #name
	]
}

#let __d_methodheader( name, generic-type:none, partial:false ) = {
	let prefix = "Dokumentation der Klasse"
	if partial {
		prefix = "Ausschnitt aus der " + prefix
	}
	if generic-type != none [
		==== #prefix #name<#generic-type>
	] else [
		==== #prefix #name
	]
}

#let method( signature, body ) = {
	if signature.func() == raw {
		signature = signature.text
	}

	block(
		width:100%,
		fill:luma(85%),
		breakable:false,
		inset:4pt,
		below: 4pt
	)[
		#set text(size:0.85em)
		#if not _ab_highlight_doku [*#signature*]
		else [#raw(signature, block:false, lang:"java")]
	]
	body
}

#let class( name, generic-type:none, descr:none, partial:false, methods ) = {
	if descr != none {
		__d_classheader(name, generic-type:generic-type)
		__content(descr)
	}

	__d_methodheader(name, generic-type:generic-type, partial:partial)
	for m in methods {
		method[#m.signature][
			#__content(m.descr)
		]
	}
}

#let display( key, descr:true ) = {
	if key not in doc-data {
		panic("No docs for name " + name)
	}

	let scheme = doc-data.at(key)
	class(
		scheme.name,
		generic-type:if scheme.generic {
				scheme.generic-type
			} else {
				none
			},
		descr: if descr and "descr" in scheme {
				scheme.descr
			} else {
				none
			},
		scheme.methods
	)
}
