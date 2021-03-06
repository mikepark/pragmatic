FIND_PATH(METIS_INCLUDE_DIR metis.h
  /usr/local/include
  /usr/include
  /usr/include/metis
  $ENV{METIS_DIR}/include
  )
message( STATUS ${METIS_INCLUDE_DIR} )

FIND_LIBRARY(METIS_LIBRARY metis
  /usr/local/lib
  /usr/lib
  $ENV{METIS_DIR}/lib
  )

IF(METIS_INCLUDE_DIR)
  ADD_DEFINITIONS(-DHAVE_METIS)
  IF(METIS_LIBRARY)
    SET( METIS_LIBRARIES ${METIS_LIBRARY})
    SET( METIS_FOUND "YES" )
  ENDIF(METIS_LIBRARY)
ENDIF(METIS_INCLUDE_DIR)

MARK_AS_ADVANCED( METIS_INCLUDE_DIR METIS_LIBRARY )
