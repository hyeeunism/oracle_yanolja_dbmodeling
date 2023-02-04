-- 숙소코드, 바꿀 숙소명 입력받아 숙소명 변경하는 프로시저

-- 테스트
        EXEC up_housename('house_2','모카라떼호텔');
        
        
        CREATE OR REPLACE PROCEDURE up_housename 
        (
            phouse_code ya_house.house_code%type
            ,phouse_name ya_house.house_name%type
             
        )
        IS   
            vhouse_name ya_house.house_name%type;
        BEGIN               

              UPDATE ya_house                         
                 SET house_name = phouse_name
              WHERE house_code = phouse_code;    
              
              dbms_output.put_line('>숙소 이름이 성공적으로 변경 되었습니다.' || ' 숙소코드(' || phouse_code || ')');
              dbms_output.put_line('변경된 숙소 이름: ' || phouse_name);
        -- EXCEPTION
        END;  
        
        