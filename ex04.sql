CREATE OR REPLACE FUNCTION NBOFPLANESPERCITY (
   P_CITY_NAME IN VARCHAR2
) RETURN NUMBER IS
   V_COUNT NUMBER;
BEGIN
   SELECT COUNT(*)
     INTO V_COUNT
     FROM PLANE P
     JOIN CITY C
   ON P.CITY_ID = C.CITY_ID
    WHERE C.CITY_NAME = UPPER(P_CITY_NAME);
   RETURN V_COUNT;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No data found for city: ' || P_CITY_NAME);
      RETURN 0;
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
      RETURN -1;
END;
/

PROMPT 'Enter a city name: '
ACCEPT city_name CHAR PROMPT 'Enter a city name: '

DECLARE
   V_COUNT NUMBER;
BEGIN
   V_COUNT := NBOFPLANESPERCITY('&city_name');
   DBMS_OUTPUT.PUT_LINE('Number of planes in '
                        || '&city_name'
                        || ' is '
                        || V_COUNT);
END;
/