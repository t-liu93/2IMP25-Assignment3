/* Query predictor variables */
select t_people.id as authorID,
    min(t_change.ch_createdTime) as firstChangeCreatedTime, /* Ecosystem tenure */
    count(t_change.id) as numberOfChanges, /* change activity */
    min(h1.hist_createdTime) as firstReviewCreatedTime, /* review tenure */
    count(h1.hist_changeId) as numberOfComments, /* review activity */
    min(h2.hist_createdTime) as firstAppBloTime, /* approval/blocking tenure */
    count(h2.hist_changeId) as numberOfAppBlo /* approval/blocking activity */
from t_change, t_people, t_history as h1, t_history as h2
where t_change.ch_authorAccountId = t_people.p_accountId and
    t_change.ch_authorAccountId = h1.hist_authorAccountId and
    (h2.hist_message like '%Do not submit%' or
        h2.hist_message like '%Code-Review-2%' or
        h2.hist_message like '%Looks good to me, approved%' or
        h2.hist_message like '%Code-Review+2%')
group by t_people.id