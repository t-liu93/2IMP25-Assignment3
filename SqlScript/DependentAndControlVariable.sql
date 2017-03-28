SELECT 
    p.id AS authorId,
    c.id AS changeId,
    r.id AS revisionId,
    TO_DAYS(r.rev_committedTime) - TO_DAYS(c.ch_createdTime) AS reviewPeriod,
    SUM(f.f_linesInserted) AS linesAdded,
    SUM(f.f_linesDeleted) AS linesDeleted,
    COUNT(f.id) AS numberOfFilesModified
FROM
    t_people AS p
        INNER JOIN
    t_change AS c ON c.ch_authorAccountId = p.p_accountId
        INNER JOIN
    t_revision AS r ON r.rev_changeId = c.id
        INNER JOIN
    t_file AS f ON f.f_revisionId = r.id
GROUP BY authorId , changeId , revisionId
ORDER BY revisionId
