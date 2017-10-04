## Lookaround
http://www.regular-expressions.info/lookaround.html

### Positive lookahead
`q(?=u)` matches a "q" that is followed by a "u"

### Negative lookahead
`q(?!u)`  matches a "q" not followed by a "u"

### Positive lookbehind
`(?<=a)b` matches a "b" that is preceded by an "a"

### Negative lookbehind
`(?<!a)b` matches a "b" that is not preceded by an "a"

## Word Boundaries
https://www.regular-expressions.info/wordboundaries.html

`\b` allows you to perform a "whole words only" search using a regular expression in the form of `\bword\b`. A "word character" is a character that can be used to form words. All characters that are not "word characters" are "non-word characters".
