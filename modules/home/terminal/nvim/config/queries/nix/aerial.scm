(let_expression
  (binding_set
    binding: (binding
      attrpath: _ @name
      expression: (function_expression
        (#set! "kind" "Function"))) @symbol))

; generic pattern for modules (matches only sometimes lol)
(source_code
  expression: (function_expression
    body: (let_expression
      "in" @name
      body: (attrset_expression
        (#set! "kind" "Struct")) @symbol)))

(attrset_expression
  (binding_set
    binding: (binding
      attrpath: _ @name
      expression: _ @symbol
      (#set! "kind" "Struct"))))
