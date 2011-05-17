SET (CORE_LIBS ACE TAO TAO_DynamicAny TAO_IORTable TAO_PortableServer)

#TODO: It's necessary to add dependency resolution for IDLs file
MACRO(TAO_ADD_IDL)
	FOREACH (_current_FILE ${ARGV})
		GET_FILENAME_COMPONENT(_tmp_FILE idl/${_current_FILE} ABSOLUTE)
		GET_FILENAME_COMPONENT(_object_DIR ./object ABSOLUTE)
		GET_FILENAME_COMPONENT(_lib_DIR ./lib ABSOLUTE)
		GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
#		SET(_output ${${_output}} "${_basename}C.cpp ${_basename}C.h ${_basename}S.cpp ${_basename}S.h")
#		MESSAGE(STATUS ${_tmp_FILE} " " ${_basename})
#		MESSAGE(STATUS ${_output})

		file(MAKE_DIRECTORY ${_object_DIR})
		file(MAKE_DIRECTORY ${_lib_DIR})

		ADD_CUSTOM_COMMAND(OUTPUT ${_object_DIR}/${_basename}C.cpp ${_object_DIR}/${_basename}C.h ${_object_DIR}/${_basename}C.inl ${_object_DIR}/${_basename}S.cpp ${_object_DIR}/${_basename}S.h ${_object_DIR}/${_basename}S.inl
			COMMAND $ENV{ACE_ROOT}/TAO/TAO_IDL/tao_idl
			ARGS ${_tmp_FILE} -o ${_object_DIR}
			DEPENDS ${_tmp_FILE}
		)

		add_library(${_basename}Stubs SHARED ${_object_DIR}/${_basename}C.cpp ${_object_DIR}/${_basename}S.cpp)
		target_link_libraries(${_basename}Stubs ${CORE_LIBS})

	ENDFOREACH (_current_FILE)
ENDMACRO(TAO_ADD_IDL)
