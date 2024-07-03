#import "typst.typ"

#let str(value) = typst.type(value) == typst.type("")
#let dict(value) = typst.type(value) == typst.type((:))
#let arr(value) = typst.type(value) == typst.type(())
#let type(value) = typst.type(value) == typst.type
#let content(value) = typst.type(value) == typst.content

#let _none(value) = value == none
#let _auto(value) = value == auto


#let barg(it) = {
  it.func() == metadata and it.value.kind == "barg"
}
#let sarg(it) = {
  return repr(it.func()) == "sequence" and it.children.first() == [..]
}
