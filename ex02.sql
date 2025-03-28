PROMPT 'Enter City ID:';
ACCEPT CITY_ID NUMBER
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
   V_CITY_ID CITY.CITY_ID%TYPE;
   TYPE PLANE_REC IS RECORD (
         PLA_ID        PLANE.PLA_ID%TYPE,
         PLA_DESC      PLANE.PLA_DESC%TYPE,
         MAX_PASSENGER PLANE.MAX_PASSENGER%TYPE,
         CITY_NAME     CITY.CITY_NAME%TYPE
   );
   TYPE PLANE_TABLE IS
      TABLE OF PLANE_REC;
   V_PLANES  PLANE_TABLE;
BEGIN
   V_CITY_ID := &CITY_ID;
   SELECT PL.PLA_ID,
          PL.PLA_DESC,
          PL.MAX_PASSENGER,
          C.CITY_NAME
   BULK COLLECT
     INTO V_PLANES
     FROM PLANE PL
     JOIN CITY C
   ON PL.CITY_ID = C.CITY_ID
    WHERE C.CITY_ID = V_CITY_ID;

   IF V_PLANES.COUNT > 0 THEN
      FOR I IN V_PLANES.FIRST..V_PLANES.LAST LOOP
         DBMS_OUTPUT.PUT_LINE('Plane ID: '
                              || V_PLANES(I).PLA_ID
                              || ', Description: '
                              || V_PLANES(I).PLA_DESC
                              || ', Max Passengers: '
                              || V_PLANES(I).MAX_PASSENGER
                              || ', City: '
                              || V_PLANES(I).CITY_NAME);
      END LOOP;
   ELSE
      DBMS_OUTPUT.PUT_LINE('No planes found for the given city ID.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No data found for the given city ID.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/