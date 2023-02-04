-- 숙소코드 입력받아 숙소정책 수정하는 프로시저

-- 테스트
EXEC up_uppolicy('아동입실불가능/흡연가능/반려동물불가능','F','T','F');
EXEC up_uppolicy('house_3','아동입실가능/흡연가능/반려동물가능','B','T','T'); -- 입력 오류
        
        CREATE OR REPLACE PROCEDURE up_uppolicy
        (
            phouse_code ya_house.house_code%type   
            , ppolicy_info ya_policy.policy_info%type
            , ppolicy_kids ya_policy.policy_kids%type
            , ppolicy_smoke ya_policy.policy_smoke%type
            , ppolicy_pet ya_policy.policy_pet%type
        )
        IS   
            vhouse_code ya_policy.house_code%type;
            invaild_type exception;
            PRAGMA EXCEPTION_INIT(invaild_type, -29991);
        BEGIN               
              IF ppolicy_kids NOT IN ('T', 'F') OR ppolicy_smoke NOT IN ('T', 'F') OR ppolicy_pet NOT IN ('T', 'F') THEN
              RAISE invaild_type;
              ELSE
              UPDATE ya_policy                        
              SET policy_info = ppolicy_info,
                  policy_kids = ppolicy_kids,
                  policy_smoke = ppolicy_smoke,
                  policy_pet = ppolicy_pet
              WHERE house_code = phouse_code;
              dbms_output.put_line('> 숙소 안내사항 변경 완료' || LPAD('숙소코드: ',20) || phouse_code);
              END IF;
        EXCEPTION
        -- T,F 값 아닌 다른 값 입력했을 경우
            WHEN invaild_type then
            ROLLBACK;
            dbms_output.put_line('> 잘못된 값이 입력되었습니다. T, F으로 입력해주세요.');
        END;  
        
        