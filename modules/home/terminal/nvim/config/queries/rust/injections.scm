; extends
((line_comment) @markdown_inline
					 (#match? @markdown_inline "^///")
					 (#offset! @markdown_inline 0 3 0 0))
