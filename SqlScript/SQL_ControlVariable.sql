/* Query control variables */
/* We do this per revision */
SELECT 
    t_revision.id AS revisionId,
    SUM(t_file.f_linesInserted) AS linesAdded,
    SUM(t_file.f_linesDeleted) AS linesDeleted,
    COUNT(t_file.id) AS numberOfFilesModified
FROM
    t_file,
    t_revision
WHERE
    t_file.f_revisionId = t_revision.id
GROUP BY t_revision.id