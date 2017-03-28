/* Query the review period */
/* Review period is the difference of t_reversion.rev_committedTime and t_change.ch_createdTime */
select t_change.id as changeID, 
    t_revision.id as revisionID, 
    to_days(t_revision.rev_committedTime) - to_days(t_change.ch_createdTime) as ecosystemTenure
from t_change, t_revision
where t_change.id = t_revision.rev_changeId
