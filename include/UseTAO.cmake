SET (CORE_LIBS ACE TAO TAO_DynamicAny TAO_IORTable TAO_PortableServer)

#TODO: It's necessary to add dependency resolution for IDLs file
MACRO(TAO_ADD_IDL)
	string(REPLACE ":" ";" _intlist_dir $ENV{INTLIST})
	FOREACH(_intlist ${_intlist_dir})
		list(APPEND INTLIST_INCLUDE_DIRS "${_intlist}/include")
		list(APPEND INTLIST_LIB_DIRS "${_intlist}/lib")
	ENDFOREACH(_intlist)

	list(APPEND INCLUDE_DIRS $ENV{INTROOT}/include
		   	${INTLIST_INCLUDE_DIRS} 
			$ENV{ACSROOT}/include
	)
	list(APPEND INCLUDE_DIRS $ENV{ACE_ROOT}/TAO/tao/IORTable
		   $ENV{ACE_ROOT}/TAO/tao/IFR_Client
		   $ENV{ACE_ROOT}/TAO/tao/PortableServer 
		   $ENV{ACE_ROOT}/TAO/tao/SmartProxies 
		   $ENV{ACE_ROOT}/TAO/tao/DynamicAny 
		   $ENV{ACE_ROOT}/TAO/tao/DynamicInterface 
		   $ENV{ACE_ROOT}/TAO/tao/Messaging 
		   $ENV{ACE_ROOT}/TAO/tao/Valuetype 
		   $ENV{ACE_ROOT}/TAO/orbsvcs/orbsvcs 
		   $ENV{ACE_ROOT}/TAO/orbsvcs  
		   $ENV{ACE_ROOT}/TAO/tao 
		   $ENV{ACE_ROOT}/ace
		   $ENV{ACE_ROOT}/TAO
		   $ENV{ACE_ROOT}
	)

	list(APPEND LIBRARY_DIRS $ENV{INTROOT}/lib
			${INTLIST_LIB_DIRS}
			$ENV{ACSROOT}/lib
			$ENV{ACE_ROOT}/lib
	)

	FOREACH (_current_FILE ${ARGV})
		GET_FILENAME_COMPONENT(_tmp_FILE idl/${_current_FILE} ABSOLUTE)
		GET_FILENAME_COMPONENT(_object_DIR ./object ABSOLUTE)
		GET_FILENAME_COMPONENT(_lib_DIR ./lib ABSOLUTE)
		GET_FILENAME_COMPONENT(_basename ${_tmp_FILE} NAME_WE)
		
		MESSAGE(STATUS "searchForIDLDeps ${_tmp_FILE}")
		execute_process (COMMAND searchForIDLDeps ${_tmp_FILE}
				OUTPUT_VARIABLE _idl_DEPS 
				RESULT_VARIABLE _idl_deps_res)
		MESSAGE(STATUS "${_idl_deps_res} ${_idl_DEPS}")
		
		string(REPLACE " " ";" _idl_dep_split ${_idl_DEPS})
		FOREACH (_idl_dep ${_idl_dep_split})
			MESSAGE(STATUS ${_idl_dep})
			GET_FILENAME_COMPONENT(_idl_dep_basename ${_idl_dep} NAME_WE)
			list(APPEND DEP_LIBS "${_idl_dep_basename}Stubs")
			list(APPEND DEP_IDLS "${_idl_dep}")
		ENDFOREACH (_idl_dep)

		string(REPLACE " " ";" _idl_dir_split $ENV{IDL_PATH})

		file(MAKE_DIRECTORY ${_object_DIR})
		file(MAKE_DIRECTORY ${_lib_DIR})
		
		ADD_CUSTOM_COMMAND(OUTPUT ${_object_DIR}/${_basename}C.cpp ${_object_DIR}/${_basename}C.h ${_object_DIR}/${_basename}C.inl ${_object_DIR}/${_basename}S.cpp ${_object_DIR}/${_basename}S.h ${_object_DIR}/${_basename}S.inl
			COMMAND $ENV{ACE_ROOT}/TAO/TAO_IDL/tao_idl
			ARGS ${_idl_dir_split} ${_tmp_FILE} -o ${_object_DIR}
			DEPENDS ${DEP_IDLS}
		)

		include_directories(${INCLUDE_DIRS})
		add_library(${_basename}Stubs SHARED ${_object_DIR}/${_basename}C.cpp ${_object_DIR}/${_basename}S.cpp)
		link_directories(${LIBRARY_DIRS})
		target_link_libraries(${_basename}Stubs ${CORE_LIBS} ${DEP_LIBS})

	ENDFOREACH (_current_FILE)
ENDMACRO(TAO_ADD_IDL)
