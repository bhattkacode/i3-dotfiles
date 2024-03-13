#!/usr/bin/env bash

output_chars=33
transformStr() {
  local input_string="$1"
  local n="$2"
  local string_length=${#input_string}

  if [ "$string_length" -gt "$n" ]; then
    expr "$input_string" : "\(.\{$n\}\)"
  else
    local padding_length=$((n - string_length))
    echo "   $input_string     "
  fi
}

todo=$(grep '-' ~/notes/todo.md | head -1)
transformStr "$todo" $output_chars

