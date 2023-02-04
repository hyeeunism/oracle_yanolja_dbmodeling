-- 방등록 프로시저

-- 테스트
EXEC up_upRoom('house_3','펜션', '특특특방',2,1,50000, null);   -- 최대인원<최소인원  
EXEC up_upRoom('house_1','호텔', '재밌는방',2,2,50000, null);  -- 최대인원>최소인원
EXEC up_upRoom('house_4','모텔', '특특특방',2,2,50000,20000); -- 모텔인 경우
COMMIT;
ROLLBACK;
        
DELETE FROM ya_room
WHERE room_name IN( '특특특방', '재밌는방');
----------------------------------------------------------------------------------------------------------------------------------------
          
        
        CREATE OR REPLACE PROCEDURE up_upRoom
        (
            phouse_code ya_room.house_code%type
            ,Phouse_type ya_house.house_type%type
            ,proom_name ya_room.room_name%type
            ,proom_min ya_room.room_min%type
            ,proom_max ya_room.room_max%type
            ,proom_scost ya_room.room_scost%type
            ,proom_dcost ya_room.room_dcost%type   
        )
        IS
            vroom_code VARCHAR2(15);
            invaild_roommax exception;
            PRAGMA EXCEPTION_INIT(invaild_roommax, -20001);
        BEGIN
            SELECT MAX(SUBSTR(room_code,6))+1 INTO vroom_code 
            FROM ya_room;
            
            IF proom_max < proom_min THEN
            raise invaild_roommax;
            END IF;
           
            INSERT INTO ya_room (room_code, room_name, room_min, room_max, room_scost, room_dcost, house_code)
                    VALUES('room_'||vroom_code, proom_name, proom_min, proom_max, proom_scost, proom_dcost, phouse_code);
                    
            IF phouse_type IN ('호텔', '펜션') THEN
                dbms_output.put_line('> 객실이 정상적으로 등록되었습니다.');
                dbms_output.put_line('---------------------------------------------------------');
                dbms_output.put_line( '객실이름 : ' || proom_name);
                dbms_output.put_line( '기준인원 : ' || proom_min);
                dbms_output.put_line( '최대인원 : ' || proom_max );
                dbms_output.put_line( '숙박가격 : ' || proom_scost);
            ELSIF phouse_type IN ('모텔') THEN
                dbms_output.put_line('> 객실이 정상적으로 등록되었습니다.');
                dbms_output.put_line('---------------------------------------------------------');
                dbms_output.put_line( '객실이름 : ' || proom_name);
                dbms_output.put_line( '기준인원 : ' || proom_min);
                dbms_output.put_line( '최대인원 : ' || proom_max );
                dbms_output.put_line( '대실가격 : ' || proom_dcost);
                dbms_output.put_line( '숙박가격 : ' || proom_scost);
            END IF;
            COMMIT;
        EXCEPTION
        -- 최대인원<최소인원
            WHEN invaild_roommax then
            ROLLBACK;
            dbms_output.put_line('> 최대인원이 기준인원보다 적게 입력되었습니다.');
        END;
