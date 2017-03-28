/* Query the review period */
/* Review period is the difference of t_reversion.rev_committedTime and t_change.ch_createdTime */
SELECT 
    t_people.id AS authorID,
    t_change.id AS changeID,
    t_revision.id AS revisionID,
    TO_DAYS(t_revision.rev_committedTime) - TO_DAYS(t_change.ch_createdTime) AS reviewPeriod
FROM
    t_people,
    t_change,
    t_revision
WHERE
    t_change.id = t_revision.rev_changeId
        AND t_people.p_accountId = t_change.ch_authorAccountId
GROUP BY revisionID