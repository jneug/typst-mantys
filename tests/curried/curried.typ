/// My base function.
/// - foo (content): Something.
/// - bar (boolean): A boolean.
/// -> content
#let myfunc(prefix, foo, bar: false) = strong(foo)

/// My curried function.
/// - foo (content): Something.
/// - bar (boolean): A boolean.
/// -> content
#let curried = myfunc.with("cmd:", bar: true)
