-- 숙소이름 입력받아 해당 숙소 정책 조회하는 프로시저

-- 테스트
EXEC up_selPolicy('카푸치노펜션');
EXEC up_selPolicy('고고펜션');

CREATE OR REPLACE PROCEDURE up_selPolicy
(   p_house_name VARCHAR2  ) -- 숙소이름 파라미터로 받음
IS
    vpolicy_no ya_policy.policy_no%type;
    vpolicy_info ya_policy.policy_info%type;
    vpolicy_kids ya_policy.policy_kids%type;
    vpolicy_smoke ya_policy.policy_smoke%type;
    vpolicy_pet ya_policy.policy_pet%type;
    vhouse_code ya_policy.house_code%type;
    vhouse_name ya_policy.house_code%type;
    CURSOR hcur IS (   SELECT policy_no, policy_info, policy_kids, policy_smoke, policy_pet, house_name
                        FROM ya_policy p JOIN ya_house h ON p.house_code = h.house_code 
                        WHERE house_name = p_house_name);
    -- EXCEPTION;
BEGIN
        
        OPEN hcur;  
        LOOP
        FETCH hcur 
        INTO vpolicy_no, vpolicy_info, vpolicy_kids,  vpolicy_smoke,  vpolicy_pet, vhouse_name;    
        EXIT WHEN  hcur%NOTFOUND;
        dbms_output.put_line('> ' || p_house_name || ' 숙소 정책 전체보기 ');
        dbms_output.put_line('---------------------------------------------------------');
        dbms_output.put_line('안내사항: '|| vpolicy_info); 
        dbms_output.put_line('아동입실: '|| REPLACE(REPLACE(vpolicy_kids, 'T', '가능'),'F', '불가')); 
        dbms_output.put_line('금연: '||  REPLACE(REPLACE(vpolicy_smoke, 'T', '가능'),'F', '불가')); 
        dbms_output.put_line('반려동물동반: '||  REPLACE(REPLACE(vpolicy_pet, 'T', '가능'),'F', '불가')); 
        dbms_output.put_line(' ');
        END LOOP;
-- EXCEPTION  
END;

