-- �ش� ���� �ı� ��ȸ ���ν���

-- �ı���ȸ : �Ѹ����, �������, �����������, �г���, �ۼ���, ȸ������������, �ı⳻��
   
-- �׽�Ʈ
EXEC up_selReview('īǪġ��ȣ��'); -- ��ȿ�� ���� �̸�
EXEC up_selReview('������'); -- ��ϵ� �ıⰡ ���� ���
 
CREATE OR REPLACE PROCEDURE up_selReview
(   p_house_name VARCHAR2  ) -- �����̸� �Ķ���ͷ� ����
IS
    vuser_name ya_user.user_name%type; -- �г���
    vrev_date ya_review.rev_date%type; -- �ۼ���
    vrev_avgrate NUMBER; -- ȸ�������������
    vrev_text ya_review.rev_text%type; -- �ı⳻��
    vhouse_name ya_house.house_name%type;
    vrev_avghouse NUMBER; -- �����������
    vrev_conavg NUMBER; -- �������Ǽ����
    vrev_kindavg NUMBER; -- ����ģ�������
    vrev_cleanavg NUMBER; -- ����û�ᵵ���
    vrev_locateavg NUMBER; -- ��ġ���������
    vrev_aroundavg NUMBER; -- �ֺ��������
    vroom_name ya_room.room_name%type; -- ���Ǹ�
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

        dbms_output.put_line('> ' || p_house_name || ' �ı�');
        dbms_output.put_line(LPAD('�ֱ� 12���� ���� ����: ',48,' ') || vrev_avghouse ||'/5');
        dbms_output.put_line(LPAD('���Ǽ�: ',48,' ')|| ROUND(vrev_conavg)||'/5'); 
        dbms_output.put_line(LPAD('ģ����: ',48,' ')|| ROUND(vrev_kindavg)||'/5');
        dbms_output.put_line(LPAD('û�ᵵ: ',48,' ')|| ROUND(vrev_cleanavg)||'/5');
        dbms_output.put_line(LPAD('��ġ������: ',49,' ')|| ROUND(vrev_locateavg)||'/5');
        dbms_output.put_line(LPAD('�ֺ�����: ',49,' ')|| ROUND(vrev_aroundavg)||'/5');
        dbms_output.put_line('---------------------------------------------------------');
        dbms_output.put_line(' ');
        OPEN hcur;  
        LOOP
        FETCH hcur 
        INTO vuser_name, vrev_date, vrev_avgrate, vhouse_name, vrev_text;       
        EXIT WHEN  hcur%NOTFOUND;
        dbms_output.put_line('�ۼ���: ' || RPAD(vuser_name,30,' ') || '������: ' || ROUND(vrev_avgrate));
        dbms_output.put_line('�ۼ���: ' || vrev_date);
        dbms_output.put_line('�ı⳻��: ' || vrev_text);
        dbms_output.put_line(' ');
        END LOOP;
END;
