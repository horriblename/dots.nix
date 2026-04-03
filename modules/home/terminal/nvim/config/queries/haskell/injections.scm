; extends

(quasiquote
  quoter: (quoter (variable) @quoter)
  (#eq? @quoter "julius")
  body: (quasiquote_body) @injection.content
  (#set! injection.language "javascript"))
