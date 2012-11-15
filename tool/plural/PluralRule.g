

grammar PluralRule;

options {
	output=AST;
	language=Dart;
}

condition
	:     and_condition ('or' and_condition)*
	;

and_condition
	:     relation ('and' relation)*
	;

relation
	:     is_relation
	|     in_relation
	|     within_relation
	;

is_relation
	:     expr 'is' ('not')? value
	;

in_relation
	:     expr ('not')? 'in' range_list
	;

within_relation
	:     expr ('not')? 'within' range_list
	;

expr
	:     'n' ('mod' value)?
	;

range_list
	:     (range | value) (',' range_list)*
	;

value
	:     digit+
	;

digit
	:     '0'..'9'
	;

range
	:     value'..'value
	;
