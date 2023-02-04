-- 해당 숙소 후기 조회 프로시저

-- 후기조회 : 총리뷰수, 평균평점, 세부평균평점, 닉네임, 작성일, 회원이준총평점, 후기내용
   
-- 테스트
EXEC up_selReview('카푸치노호텔'); -- 유효한 숙소 이름
EXEC up_selReview('고고펜션'); -- 등록된 후기가 없을 경우
 
CREATE OR REPLACE PROCEDURE up_selReview
(   p_house_name VARCHAR2  ) -- 숙소이름 파라미터로 받음
IS
    vuser_name ya_user.user_name%type; -- 닉네임
    vrev_date ya_review.rev_date%type; -- 작성일
    vrev_avgrate NUMBER; -- 회원이준평점평균
    vrev_text ya_review.rev_text%type; -- 후기내용
    vhouse_name ya_house.house_name%type;
    vrev_avghouse NUMBER; -- 숙소평점평균
    vrev_conavg NUMBER; -- 숙소편의성평균
    vrev_kindavg NUMBER; -- 숙소친절도평균
    vrev_cleanavg NUMBER; -- 숙소청결도평균
    vrev_locateavg NUMBER; -- 위치만족도평균
    vrev_aroundavg NUMBER; -- 주변여행평균
    vroom_name ya_room.room_name%type; -- 객실명
    CURSOR hcur IS (   SELECT user_name, rev_date
                        , (rev_con + rev_kind + rev_clean + rev_locate + rev_around)/5
                        , house_name
                        , rev_text
                        FROM ya_review r JOIN ya_house h ON r.house_code = h.house_code
                                         JOIN ya_user u ON r.user_code = u.user_code
                                         LEFT JOIN ya_resinfo f ON r.rinfo_no = f.rinfo_no 
                        WHERE p_house_name = h.house_name);

BEGIN

        SELECT AVG((rev_con + rev_kind + rev_clean + rev_locate + rev_around)/5),
                AVG(rev_con), AVG(rev_kind), AVG(rev_clean), AVG(rev_locate), AVG(rev_around)
            INTO vrev_avghouse, vrev_conavg, vrev_kindavg, vrev_cleanavg, vrev_locateavg, vrev_aroundavg
        FROM ya_review r JOIN ya_house h ON r.house_code = h.house_code
        WHERE p_house_name = h.house_name;

        dbms_output.put_line('> ' || p_house_name || ' 후기');
        dbms_output.put_line(LPAD('최근 12개월 누적 평점: ',48,' ') || vrev_avghouse ||'/5');
        dbms_output.put_line(LPAD('편의성: ',48,' ')|| ROUND(vrev_conavg)||'/5'); 
        dbms_output.put_line(LPAD('친절도: ',48,' ')|| ROUND(vrev_kindavg)||'/5');
        dbms_output.put_line(LPAD('청결도: ',48,' ')|| ROUND(vrev_cleanavg)||'/5');
        dbms_output.put_line(LPAD('위치만족도: ',49,' ')|| ROUND(vrev_locateavg)||'/5');
        dbms_output.put_line(LPAD('주변여행: ',49,' ')|| ROUND(vrev_aroundavg)||'/5');
        dbms_output.put_line('---------------------------------------------------------');
        dbms_output.put_line(' ');
        OPEN hcur;  
        LOOP
        FETCH hcur 
        INTO vuser_name, vrev_date, vrev_avgrate, vhouse_name, vrev_text;       
        EXIT WHEN  hcur%NOTFOUND;
        dbms_output.put_line('작성자: ' || RPAD(vuser_name,30,' ') || '총평점: ' || ROUND(vrev_avgrate));
        dbms_output.put_line('작성일: ' || vrev_date);
        dbms_output.put_line('후기내용: ' || vrev_text);
        dbms_output.put_line(' ');
        END LOOP;
END;
