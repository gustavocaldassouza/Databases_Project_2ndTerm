CREATE OR REPLACE PROCEDURE LISTOFFLIGHTS (
   P_CITY_NAME IN CITY.CITY_NAME%TYPE
) IS
   CURSOR C_FLIGHTS IS
   SELECT F.FLIGHT_ID,
          PL.LAST_NAME
          || ', '
          || PL.FIRST_NAME AS NAM,
          P.PLA_DESC,
          F.DEP_TIME,
          F.ARR_TIME,
          CARR.CITY_NAME
     FROM FLIGHT F
     JOIN PLANE P
   ON P.PLA_ID = F.PLA_ID
     JOIN CITY CDEP
   ON F.CITY_DEP = CDEP.CITY_ID
     JOIN CITY CARR
   ON F.CITY_ARR = CARR.CITY_ID
     JOIN PILOT PL
   ON PL.PILOT_ID = F.PILOT_ID
    WHERE CDEP.CITY_NAME = UPPER(P_CITY_NAME)
    ORDER BY F.DEP_TIME;
   CUR_FLIGHT C_FLIGHTS%ROWTYPE;
BEGIN
   DBMS_OUTPUT.PUT_LINE(UPPER(P_CITY_NAME));
   DBMS_OUTPUT.PUT_LINE(RPAD(
      'Flight ID',
      15
   )
                        || RPAD(
      'Pilot',
      20
   )
                        || RPAD(
      'Description',
      20
   )
                        || RPAD(
      'Departure time',
      20
   )
                        || RPAD(
      'Arrival time',
      20
   )
                        || RPAD(
      'Arrival City',
      20
   ));
   FOR CUR_FLIGHT IN C_FLIGHTS LOOP
      DBMS_OUTPUT.PUT_LINE(RPAD(
         CUR_FLIGHT.FLIGHT_ID,
         15
      )
                           || RPAD(
         CUR_FLIGHT.NAM,
         20
      )
                           || RPAD(
         CUR_FLIGHT.PLA_DESC,
         20
      )
                           || RPAD(
         CUR_FLIGHT.DEP_TIME,
         20
      )
                           || RPAD(
         CUR_FLIGHT.ARR_TIME,
         20
      )
                           || RPAD(
         CUR_FLIGHT.CITY_NAME,
         20
      ));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No data found for city: ' || P_CITY_NAME);
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/
PROMPT 'Enter a city name: '
ACCEPT city_name CHAR PROMPT 'Enter a city name: '

BEGIN
   LISTOFFLIGHTS('&city_name');
END;
/