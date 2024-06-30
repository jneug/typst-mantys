#import "../util/typing.typ" as t
#import "schema.typ"

/// Creates a document by parsing the supplied arguments agains the document schema.
#let create(..args) = t.parse(args.named(), schema.document)

/// Saves the document in an internal state.
#let save(doc) = state("mantys:document").update(doc)

#let update(func) = state("mantys:document").update(func)

#let update-value(key, func) = update(doc => {
  doc.insert(key, doc.at(key, default: default))
  doc
})

/// Retrieves the document from the internally saved state.
/// #poperty(context: true)
#let get() = state("mantys:document").get()

/// Retrieves the document from the internally saved state.
/// #poperty(context: true)
#let final() = state("mantys:document").final()

/// Gets a value from the internally saved document.
/// #poperty(context: true)
#let get-value(key, default: none) = get().at(value, default: default)

/// Retrieves the document from the internally saved state.
/// #poperty(context: true)
#let use(func) = context func(get())

/// Gets a value from the internally saved document.
/// #poperty(context: true)
#let use-value(key, func, default: none) = context func(get().at(key, default: default))
