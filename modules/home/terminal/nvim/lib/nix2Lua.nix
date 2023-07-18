with builtins; let
  convertToLua = x: typeConvertors.${typeOf x} x;

  typeConvertors = rec {
    int = toString;
    bool = toString;
    string = x: ''"${replaceStrings ["\"" "\\"] [''\"'' ''\\''] x}"'';
    path = x: string (toString x);
    null = x: "nil";
    set = x: "{ ${
      concatStringsSep ", " (attrValues (mapAttrs attrItemToLua x))
    } }";
    list = x: "{ ${concatStringsSep ", " (map convertToLua x)} }";
    lambda = x: assert typeOf x != "lambda"; null;
    float = toString;
  };

  attrItemToLua = key: value: "${keyToLua key} = ${convertToLua value}";

  isLuaIdent = val:
    (let firstChar = substring 0 1 val; in matches "[[:alpha:]_]" firstChar)
    && (matches "[[:alpha:]_[:digit:]]+" val)
    && (!matches (concatStringsSep "|" luaKeywords) val);

  luaKeywords = [
    "and"
    "break"
    "do"
    "else"
    "elseif"
    "end"
    "false"
    "for"
    "function"
    "if"
    "in"
    "local"
    "nil"
    "not"
    "or"
    "repeat"
    "return"
    "then"
    "true"
    "until"
    "while"
  ];

  matches = pattern: s: !isNull (match pattern s);

  keyToLua = key:
    assert typeOf key == "string";
      if isLuaIdent key
      then key
      else "[${convertToLua key}]";
in
  convertToLua
