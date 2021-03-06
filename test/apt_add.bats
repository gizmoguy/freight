# vim: noet:ts=4:sw=4:ft=sh

load freight_helpers

setup() {
	freight_init
}

@test "freight-add adds package to distro main component" {
	run freight_add ${FIXTURES}/test_1.0_all.deb apt/example
	assert_success
	assert_output "# [freight] added ${FIXTURES}/test_1.0_all.deb to apt/example"
	test -e ${FREIGHT_LIB}/apt/example/test_1.0_all.deb
}

@test "freight-add adds package to a component" {
	freight_add ${FIXTURES}/test_1.0_all.deb apt/example/comp
	test -e ${FREIGHT_LIB}/apt/example/comp/test_1.0_all.deb
}

@test "freight-add adds package and hard link to multiple components" {
	freight_add ${FIXTURES}/test_1.0_all.deb apt/example/comp apt/example/another
	test -e ${FREIGHT_LIB}/apt/example/comp/test_1.0_all.deb
	test -e ${FREIGHT_LIB}/apt/example/another/test_1.0_all.deb
	test $(stat -c '%i' ${FREIGHT_LIB}/apt/example/comp/*.deb) -eq $(stat -c '%i' ${FREIGHT_LIB}/apt/example/another/*.deb)
}

@test "freight-add detects duplicate package" {
	freight_add ${FIXTURES}/test_1.0_all.deb apt/example
	run freight_add ${FIXTURES}/test_1.0_all.deb apt/example
	assert_success
	assert_output "# [freight] apt/example already has ${FIXTURES}/test_1.0_all.deb"
}
