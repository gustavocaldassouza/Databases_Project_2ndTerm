CREATE OR REPLACE PACKAGE PACK_PILOT AS
   PROCEDURE UPDATE_SALARY (
      PIL_ID      IN PILOT.PILOT_ID%TYPE,
      AMOUNT      IN NUMBER,
      IS_INCREASE IN BOOLEAN
   );
   PROCEDURE UPDATE_SALARY (
      PIL_ID        IN PILOT.PILOT_ID%TYPE,
      PERCENTAGE    IN NUMBER,
      IS_PERCENTAGE IN BOOLEAN,
      IS_INCREASE   IN BOOLEAN
   );
   PROCEDURE LIST_OF_PILOTS (
      PLANE_ID IN PLANE.PLA_ID%TYPE
   );
   FUNCTION NB_PLANES (
      PIL_ID IN PILOT.PILOT_ID%TYPE
   ) RETURN NUMBER;
END PACK_PILOT;
/

CREATE OR REPLACE PACKAGE BODY PACK_PILOT AS
   PROCEDURE UPDATE_SALARY (
      PIL_ID      IN PILOT.PILOT_ID%TYPE,
      AMOUNT      IN NUMBER,
      IS_INCREASE IN BOOLEAN
   ) IS
      V_OLD_SALARY NUMBER;
      V_NEW_SALARY NUMBER;
      V_NAME       NVARCHAR2(100);
   BEGIN
      SELECT SALARY,
             LAST_NAME
             || ', '
             || FIRST_NAME
        INTO
         V_OLD_SALARY,
         V_NAME
        FROM PILOT
       WHERE PILOT_ID = PIL_ID;
      IF IS_INCREASE THEN
         V_NEW_SALARY := V_OLD_SALARY + AMOUNT;
      ELSE
         V_NEW_SALARY := V_OLD_SALARY - AMOUNT;
      END IF;
      UPDATE PILOT
         SET
         SALARY = V_NEW_SALARY
       WHERE PILOT_ID = PIL_ID;

      DBMS_OUTPUT.PUT_LINE('Pilot ID: '
                           || PIL_ID
                           || ', Old Salary: '
                           || V_OLD_SALARY
                           || ', New Salary: '
                           || V_NEW_SALARY
                           || ', Change Amount: '
                           || AMOUNT);

      COMMIT;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Pilot ID not found: ' || PIL_ID);
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
   END UPDATE_SALARY;

   PROCEDURE UPDATE_SALARY (
      PIL_ID        IN PILOT.PILOT_ID%TYPE,
      PERCENTAGE    IN NUMBER,
      IS_PERCENTAGE IN BOOLEAN,
      IS_INCREASE   IN BOOLEAN
   ) IS
      V_OLD_SALARY NUMBER;
      V_NEW_SALARY NUMBER;
      V_NAME       NVARCHAR2(100);
   BEGIN
      SELECT SALARY,
             LAST_NAME
             || ', '
             || FIRST_NAME
        INTO
         V_OLD_SALARY,
         V_NAME
        FROM PILOT
       WHERE PILOT_ID = PIL_ID;
      IF IS_PERCENTAGE THEN
         IF IS_INCREASE THEN
            V_NEW_SALARY := V_OLD_SALARY + V_OLD_SALARY * PERCENTAGE / 100;
         ELSE
            V_NEW_SALARY := V_OLD_SALARY - V_OLD_SALARY * PERCENTAGE / 100;
         END IF;
      END IF;
      UPDATE PILOT
         SET
         SALARY = V_NEW_SALARY
       WHERE PILOT_ID = PIL_ID;

      DBMS_OUTPUT.PUT_LINE('Pilot ID: '
                           || PIL_ID
                           || ', Name: '
                           || V_NAME
                           || ', Old Salary: '
                           || V_OLD_SALARY
                           || ', New Salary: '
                           || V_NEW_SALARY
                           || ', Change Percentage: '
                           || PERCENTAGE
                           || '%');
      COMMIT;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('Pilot ID not found: ' || PIL_ID);
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
   END UPDATE_SALARY;

   PROCEDURE LIST_OF_PILOTS (
      PLANE_ID IN PLANE.PLA_ID%TYPE
   ) IS
      CURSOR PILOT_CURSOR IS
      SELECT F.PILOT_ID,
             P.LAST_NAME,
             PL.PLA_DESC,
             C.CITY_NAME
        FROM FLIGHT F
        JOIN PILOT P
      ON P.PILOT_ID = F.PILOT_ID
        JOIN PLANE PL
      ON PL.PLA_ID = F.PLA_ID
        JOIN CITY C
      ON P.CITY_ID = C.CITY_ID
       WHERE PL.PLA_ID = PLANE_ID;
      V_PILOT PILOT_CURSOR%ROWTYPE;
   BEGIN
      FOR V_PILOT IN PILOT_CURSOR LOOP
         DBMS_OUTPUT.PUT_LINE('Pilot ID: '
                              || V_PILOT.PILOT_ID
                              || ', Last Name: '
                              || V_PILOT.LAST_NAME
                              || ', Plane: '
                              || V_PILOT.PLA_DESC
                              || ', City: '
                              || V_PILOT.CITY_NAME);
      END LOOP;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('No pilots found for plane ID: ' || PLANE_ID);
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
   END LIST_OF_PILOTS;

   FUNCTION NB_PLANES (
      PIL_ID IN PILOT.PILOT_ID%TYPE
   ) RETURN NUMBER IS
      V_NB_PLANES NUMBER;
   BEGIN
      SELECT COUNT(DISTINCT PLA_ID)
        INTO V_NB_PLANES
        FROM FLIGHT F
       WHERE F.PILOT_ID = PIL_ID;

      RETURN V_NB_PLANES;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         DBMS_OUTPUT.PUT_LINE('No planes found for pilot ID: ' || PIL_ID);
         RETURN 0;
      WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
         RETURN -1;
   END NB_PLANES;

END PACK_PILOT;
/

   SET SERVEROUTPUT ON;

-- Test Update_Salary by amount
-- INCREASE
BEGIN
   PACK_PILOT.UPDATE_SALARY(
      1,
      1000,
      TRUE
   );
END;
/
--DECREASE
BEGIN
   PACK_PILOT.UPDATE_SALARY(
      1,
      1000,
      FALSE
   );
END;

-- Test Update_Salary by percentage
-- INCREASE
BEGIN
   PACK_PILOT.UPDATE_SALARY(
      1,
      10,
      TRUE,
      TRUE
   );
END;
/
--DECREASE
BEGIN
   PACK_PILOT.UPDATE_SALARY(
      1,
      10,
      TRUE,
      FALSE
   );
END;

-- Test List_Of_Pilots for a given plane
BEGIN
   PACK_PILOT.LIST_OF_PILOTS(1);
END;
/

-- Test Nb_Planes for a given pilot
DECLARE
   V_NB_PLANES NUMBER;
BEGIN
   V_NB_PLANES := PACK_PILOT.NB_PLANES(1);
   DBMS_OUTPUT.PUT_LINE('Number of planes flown: ' || V_NB_PLANES);
END;
/