/* Query the review period */
/* Review period is the difference of t_reversion.rev_committedTime and t_change.ch_createdTime */
SELECT 
    t_change.id AS changeID,
    t_revision.id AS revisionID,
    TO_DAYS(t_revision.rev_committedTime) - TO_DAYS(t_change.ch_createdTime) AS ecosystemTenure
FROM
    t_change,
    t_revision
WHERE
    t_change.id = t_revision.rev_changeId
