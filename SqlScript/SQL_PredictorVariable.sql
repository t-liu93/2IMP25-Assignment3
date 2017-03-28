/* Query predictor variables */
SELECT 
    p.id AS authorId,
    TO_DAYS(MAX(c.ch_createdTime)) - TO_DAYS(MIN(c.ch_createdTime)) AS ecosystemTenure,
    COUNT(c.id) AS changeAcitivity,
    TO_DAYS(MAX(r.rev_committedTime)) - TO_DAYS(MIN(c.ch_createdTime)) AS reviewTenure,
    COUNT(r.id) AS reviewActivity,
    TO_DAYS(MAX(h.hist_createdTime)) - TO_DAYS(MIN(h.hist_createdTime)) AS appBlockTenure,
    COUNT(h.id) AS appBlockActivity
FROM
    t_change AS c
        INNER JOIN
    t_people AS p ON c.ch_authorAccountId = p.p_accountId
        INNER JOIN
    t_revision AS r ON r.rev_changeId = c.id
        INNER JOIN
    (SELECT 
        *
    FROM
        t_history
    WHERE
        hist_message LIKE '%Do not submit%'
            OR hist_message LIKE '%Code-Review-2%'
            OR hist_message LIKE '%Looks good to me, approved%'
            OR hist_message LIKE '%Code-Review+2%') AS h ON h.hist_changeId = c.id
GROUP BY authorId
