 -- 닉네임 입력하여 내가 작성한 후기 조회 프로시저
 -- 후기조회 : 작성일, 평점평균, 후기내용, 숙소이름
 
 -- 테스트
EXEC up_selMyReview('구의동산책코스'); -- user_1
EXEC up_selMyReview('송파동얼간이'); --
    
 
CREATE OR REPLACE PROCEDURE up_selMyReview
(
p_user_name VARCHAR2  
) -- 닉네임 파라미터로 받음
IS
    vrev_date ya_review.rev_date%type; -- 작성일
    vrev_avgrate NUMBER; -- 회원이준평점평균
    vrev_text ya_review.rev_text%type; -- 후기내용
    vhouse_name ya_house.house_name%type; -- 숙소이름
    CURSOR hcur IS (   SELECT 
                     rev_date
                        , (rev_con + rev_kind + rev_clean + rev_locate + rev_around)/5 평균
                        , rev_text
                        , house_name
                        FROM ya_review re JOIN ya_user us ON re.user_code = us.user_code
                                          JOIN  ya_house ho ON re.house_Code = ho.house_code
                        WHERE p_user_name = user_name);
 BEGIN                         
        dbms_output.put_line('> 나의 후기 보기 ');
        dbms_output.put_line(' ');
        dbms_output.put_line(' ');
        
        OPEN hcur;  
        LOOP
        FETCH hcur 
        INTO vrev_date, vrev_avgrate, vrev_text, vhouse_name;       
        EXIT WHEN  hcur%NOTFOUND;
        dbms_output.put_line(vhouse_name);
        dbms_output.put_line('작성일: ' || RPAD(vrev_date,30,' ') || '총평점: ' || ROUND(vrev_avgrate));  
        dbms_output.put_line('후기내용: ' || vrev_text);
        dbms_output.put_line(' ');
        END LOOP;
        CLOSE hcur;
END;

