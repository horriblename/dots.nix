; extends

(atx_h1_marker) @Header1

(atx_h2_marker) @Header2

(atx_h3_marker) @Header3

(atx_h4_marker) @Header4

(atx_h5_marker) @Header5

(atx_h6_marker) @Header6

; code blocks
; kind of a hack: idk how to correctly match closing fences
(fenced_code_block
  ((fenced_code_block_delimiter) @tag
    (#set! conceal "-")))

; (fenced_code_block
;   . (fenced_code_block_delimiter) @tag
;   (#set! conceal "▌"))
(fenced_code_block
  (info_string) @devicon
  (#as_devicon! @devicon))

; quote blocks
((block_quote_marker) @variable
	(#trim! @variable 0 0 0 1)
	(#set! conceal "│"))

((block_continuation) @variable
  (#set! conceal "│")
  (#lua-match? @variable "^>")
  (#trim! @variable 0 0 0 1))

; call-out blocks/admonition
; https://help.obsidian.md/How+to/Use+callouts
; https://learn.microsoft.com/en-us/contribute/markdown-reference#alerts-note-tip-important-caution-warning
(block_quote
  (block_quote_marker)
  (paragraph
    (inline)  @comment.note)
  (#eq? @comment.note "[!NOTE]"))

((block_quote_marker) @text.warning
  (block_quote_marker)
  (paragraph
    (inline) @comment.warning)
  (#eq? @comment.warning "[!WARNING]"))

; table
(pipe_table_header
  "|" @pipe
  (#set! conceal "│"))

(pipe_table_delimiter_row
  "|" @pipe
  (#set! conceal "│"))

(pipe_table_row
  "|" @pipe
  (#set! conceal "│"))

; (
;  (pipe_table_row
; 	. "|" @pipe1 (#set! conceal " ")
; 	"|" @pipe2 . (#set! conceal " ")
; 	))
; testing
;     (block_quote_marker) @conceal @marker
;     (#set! conceal "▏"))
;
; (block_quote
;     (block_continuation) @conceal @cont
;     (#set! conceal "▏"))
;
; (block_quote
;      (_ (block_continuation) @conceal @nestcont (#set! conceal "▏"))
; )
; tag
; ("#")
