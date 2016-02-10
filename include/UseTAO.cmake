
MACRO(TAO_ADD_IDL)
	FOREACH (_current_FILE ${ARGV})
		GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)
		GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
		SET(_output ${${_output}} "${_basename}C.cpp")
		MESSAGE(STATUS ${_tmp_FILE} " " ${_basename})
		MESSAGE(STATUS ${_output})
		ADD_CUSTOM_COMMAND(OUTPUT ${_output}
			COMMAND $ENV{ACE_ROOT}/TAO/TAO_IDL/tao_idl
			ARGS ${_tmp_FILE}
			WORKING_DIRECTORY "."
		)
		SET(generated ${_basename}C.cpp ${_basename}S.cpp)
	ENDFOREACH (_current_FILE)
ENDMACRO(TAO_ADD_IDL)
