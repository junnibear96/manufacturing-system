-- Insert Production Processes if empty
MERGE INTO production_process p
USING (
    SELECT 1 as id, 'PROC-01' as code, '원자재 입고 및 검사' as name FROM DUAL UNION ALL
    SELECT 2, 'PROC-02', '1차 가공 (절단/성형)' FROM DUAL UNION ALL
    SELECT 3, 'PROC-03', '2차 가공 (열처리/도금)' FROM DUAL UNION ALL
    SELECT 4, 'PROC-04', '부품 조립' FROM DUAL UNION ALL
    SELECT 5, 'PROC-05', '최종 조립' FROM DUAL UNION ALL
    SELECT 6, 'PROC-06', '성능 테스트' FROM DUAL UNION ALL
    SELECT 7, 'PROC-07', '최종 검사 및 포장' FROM DUAL
) s
ON (p.process_code = s.code)
WHEN NOT MATCHED THEN
    INSERT (process_id, process_code, process_name)
    VALUES (s.id, s.code, s.name);

COMMIT;
