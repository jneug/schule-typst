#import "../../src/schule.typ": ab, info
#import ab: *
#import info: docs

#show: arbeitsblatt(
  titel: "CS documentations test",
  fontsize: 13pt,
)

#page(flipped: true, columns: 2)[
  #docs.display("databaseconnector")
  #docs.display("queryresult")
]
