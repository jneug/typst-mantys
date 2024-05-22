#import "@preview/mantys:0.1.4"

#let package = toml("/typst.toml").package

#let issue(num) = text(eastern, link(package.repository + "/issues/" + str(num))[hydra\##num])

#let issues = text(eastern, link(package.repository + "/issues/")[GitHub:typst-community/mantodea])

#let raw-bg = gray.lighten(50%)
#let bbox = box.with(inset: (x: 0.25em), outset: (y: 0.25em), radius: 0.25em)
