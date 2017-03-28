/* Query control variables */
/* We do this per revision */
select t_revision.id as revisionId, 
    sum(t_file.f_linesInserted) as linesAdded, 
    sum(t_file.f_linesDeleted) as linesDeleted,
    count(t_file.id) as numberOfFilesModified
from t_file, t_revision
where t_file.f_revisionId = t_revision.id
group by t_revision.id