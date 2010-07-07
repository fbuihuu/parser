#! /bin/bash


calc () {
	./calc --parser=${PARSER:=opp}  2>/dev/null
}

test_expect_success () {
	r=$(calc <<<$1) || {
		echo >&2 "'$PARSER' parser failed to parse '$1' expression"
		exit 1
	}
	[ $r = $2 ] || {
		echo >&2 "'$PARSER' produced incorrect result with expr: '$1'"
		echo >&2 "expecting '$2', but got '$r'"
		exit 2
	}
}

test_expect_failure () {
	calc <<<$1 && {
		echo >&2 "'$PARSER' should have failed to parse '$1'"
		exit 3
	}
}


test_expect_success "1" 1
test_expect_success "1+2" 3
test_expect_success "2*3" 6
test_expect_failure "1+"
test_expect_failure "2 3"
test_expect_success "(((100)))" 100
test_expect_success "1 + 2 * 3 + 4" 11
test_expect_success "(2+3)*4" 20
test_expect_success "(2+3) * (1+3)" 20
test_expect_success "(1 + (2 + (3 + (4 + 5))))" 15
test_expect_failure "(1 + (2 + (3 + (4 + 5))"

echo "All tests passed."
exit 0
