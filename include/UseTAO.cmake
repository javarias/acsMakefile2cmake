
MACRO(TAO_ADD_IDL)
	FOREACH (_current_FILE ${ARGV})
		
		GET_FILENAME_COMPONENT(_tmp_FILE ${_current_FILE} ABSOLUTE)
		GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)

		MESSAGE(STATUS ${_tmp_FILE})
		ADD_CUSTOM_COMMAND(OUTPUT ${_basename}C.h ${_basename}S.h ${_basename}C.cpp ${_basename}S.cpp
			COMMAND $ENV{ACE_ROOT}/TAO/TAO_IDL/tao_idl
			ARGS ${_tmp_FILE}
			DEPENDS ${_tmp_FILE}
		)

	ENDFOREACH (_current_FILE)

ENDMACRO(TAO_ADD_IDL)
