/* Query predictor variables */
SELECT 
    t_people.id AS authorId,
    TO_DAYS(MAX(t_change.ch_createdTime)) - TO_DAYS(MIN(t_change.ch_createdTime)) AS ecosystemTenure,
    COUNT(t_change.id) AS changeActivity,
    TO_DAYS(MAX(h1.hist_createdTime)) - TO_DAYS(MIN(h1.hist_createdTime)) AS reviewTenure,
    COUNT(h1.id) AS reviewActivity,
    TO_DAYS(MAX(h2.hist_createdTime)) - TO_DAYS(MIN(h2.hist_createdTime)) AS appBlockTenure,
    COUNT(h2.id) AS appBlockActivity
FROM
    ((t_people
    INNER JOIN t_change ON t_change.ch_authorAccountId = t_people.p_accountId)
    INNER JOIN t_history AS h1 ON t_people.p_accountId = h1.hist_authorAccountId)
    INNER JOIN (SELECT 
        *
    FROM
        t_history
    WHERE
        hist_message LIKE '%Do not submit%'
            OR hist_message LIKE '%Code-Review-2%'
            OR hist_message LIKE '%Looks good to me, approved%'
            OR hist_message LIKE '%Code-Review+2%') AS h2 ON t_people.p_accountId = h2.hist_authorAccountId
GROUP BY t_people.id

