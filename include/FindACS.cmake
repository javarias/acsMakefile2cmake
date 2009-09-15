
IF (UNIX)
	FIND_PATH(ACS_INCLUDE_DIR acscommonC.h
			$ENV{ACSROOT}/include
	)
ENDIF(UNIX)

SET (ACS_FOUND FALSE)

IF(ACS_INCLUDE_DIR)
#Add libraries must be done manually
	SET(ACS_FOUND TRUE)
ENDIF(ACS_INCLUDE_DIR)

IF(ACS_FOUND)
	MESSAGE(STATUS "Found ACS: ${ACS_INCLUDE_DIR}")
ELSE(ACS_FOUND)
	MESSAGE(FATAL_ERROR "ACS was not found. ${ACS_INCLUDE_DIR}")
ENDIF(ACS_FOUND)
