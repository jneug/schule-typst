// Import defualt theme as fallback and overwrite with selected theme
#import "themes/default.typ": *

#let _theme-name = sys.inputs.at("theme", default: "default")
#import "themes/" + _theme-name + ".typ": *
