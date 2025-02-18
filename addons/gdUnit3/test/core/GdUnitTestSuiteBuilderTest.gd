# GdUnit generated TestSuite
#warning-ignore-all:unused_argument
#warning-ignore-all:return_value_discarded
class_name GdUnitTestSuiteBuilderTest
extends GdUnitTestSuite

# TestSuite generated from
const __source = 'res://addons/gdUnit3/src/core/GdUnitTestSuiteBuilder.gd'

var _test_suite_builder :GdUnitTestSuiteBuilder
var _example_source_gd :String
var _example_source_cs :String

func before_test():
	var temp := create_temp_dir("examples")
	var result := GdUnitTools.copy_file("res://addons/gdUnit3/test/core/resources/sources/test_person.gd", temp)
	assert_result(result).is_success()
	_example_source_gd = result.value() as String
	result = GdUnitTools.copy_file("res://addons/gdUnit3/test/core/resources/sources/TestPerson.cs", temp)
	assert_result(result).is_success()
	_example_source_cs = result.value() as String
	_test_suite_builder = GdUnitTestSuiteBuilder.new()

func after_test():
	clean_temp_dir()

func assert_tests(test_suite :Script) -> GdUnitArrayAssert:
	var methods := test_suite.get_script_method_list()
	var test_cases := Array()
	for method in methods:
		var name :String = method.name
		if name.begins_with("test_"):
			test_cases.append(name)
	return assert_array(test_cases)

func test_create_gd_success() -> void:
	var source := load(_example_source_gd)
	
	# create initial test suite based on function selected by line 9
	var result := _test_suite_builder.create(source, 9)
	
	assert_result(result).is_success()
	var info := result.value() as Dictionary
	assert_str(info.get("path")).is_equal("user://tmp/test/examples/test_person_test.gd")
	assert_int(info.get("line")).is_equal(10)
	assert_tests(load(info.get("path"))).contains_exactly(["test_first_name"])
	
	# create additional test on existing suite based on function selected by line 15
	result = _test_suite_builder.create(source, 15)
	
	assert_result(result).is_success()
	info = result.value() as Dictionary
	assert_str(info.get("path")).is_equal("user://tmp/test/examples/test_person_test.gd")
	assert_int(info.get("line")).is_equal(14)
	assert_tests(load(info.get("path"))).contains_exactly_in_any_order(["test_first_name", "test_fully_name"])

func test_create_gd_fail() -> void:
	var source := load(_example_source_gd)
	
	# attempt to create an initial test suite based on the function selected in line 8, which has no function definition
	var result := _test_suite_builder.create(source, 8)
	assert_result(result).is_error().contains_message("No function found at line: 8.")

func test_create_cs_success() -> void:
	if not GdUnitTools.is_mono_supported():
		# ignore this test on none mono installations
		return
	var source := load(_example_source_cs)
	
	# create initial test suite based on function selected by line 18
	var result := _test_suite_builder.create(source, 18)
	
	assert_result(result).is_success()
	var info := result.value() as Dictionary
	assert_str(info.get("path")).is_equal("user://tmp/test/examples/TestPersonTest.cs")
	assert_int(info.get("line")).is_equal(16)
