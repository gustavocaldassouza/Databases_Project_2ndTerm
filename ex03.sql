   SET VERIFY OFF
SET SERVEROUTPUT ON 
ACCEPT city_name CHAR PROMPT 'Enter a city name: '
ACCEPT max_pass NUMBER PROMPT 'Enter the max passanger: '

DECLARE
   V_CITY_NAME CITY.CITY_NAME%TYPE;
   CURSOR C_CITY IS
   SELECT P.PLA_ID,
          P.PLA_DESC,
          P.MAX_PASSENGER,
          C.CITY_NAME
     FROM PLANE P
     JOIN CITY C
   ON P.CITY_ID = C.CITY_ID
    WHERE UPPER(CITY_NAME) = V_CITY_NAME;
   V_CITY      C_CITY%ROWTYPE;
BEGIN
   V_CITY_NAME := UPPER('&city_name');
   DBMS_OUTPUT.PUT_LINE(RPAD(
      'Plane ID',
      20
   )
                        || RPAD(
      'Plane Description',
      20
   )
                        || RPAD(
      'Max Passenger',
      20
   )
                        || RPAD(
      'City Name',
      20
   )
                        || RPAD(
      'IS GREATER OR EQUAL THAN MAX PASSANGERS',
      50
   ));
   DBMS_OUTPUT.PUT_LINE('-----------------------------------------------------------------------------------------------------------------'
   );
   FOR V_CITY IN C_CITY LOOP
      DBMS_OUTPUT.PUT_LINE(RPAD(
         V_CITY.PLA_ID,
         20
      )
                           || RPAD(
         V_CITY.PLA_DESC,
         20
      )
                           || RPAD(
         V_CITY.MAX_PASSENGER,
         20
      )
                           || RPAD(
         V_CITY.CITY_NAME,
         20
      )
                           || RPAD(
         CASE
            WHEN V_CITY.MAX_PASSENGER > '&max_pass' THEN
               'YES'
            ELSE 'NO'
         END,
         50
      ));
   END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No data found for the given city name.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM(SQLCODE));
END;
/