// Import default theme as fallback and overwrite with selected theme
#import "themes/default.typ": *

// Import theme provided by --input theme name
#let _theme-name = sys.inputs.at("theme", default: "default")
#import "themes/" + _theme-name + ".typ": *
