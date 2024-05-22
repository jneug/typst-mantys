#import "@preview/mantodea:0.1.0": mantodea

#show: mantodea(
  title: [Title],
  subtitle: [Subtitle],
  authors: "John Doe <john@doe.com>",
  date: datetime.today(),
  version: version(0, 1, 0),
  abstract: lorem(100),
  license: "MIT",
)
