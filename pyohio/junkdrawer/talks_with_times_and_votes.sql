create or replace view all_proposals
as

with plus_1_votes as
(
    select proposal_id, count(*)
    from reviews_latestvote
    where vote = '+1'
    group by proposal_id
),

plus_0_votes as
(
    select proposal_id, count(*)
    from reviews_latestvote
    where vote = '+0'
    group by proposal_id
),

minus_0_votes as
(
    select proposal_id, count(*)
    from reviews_latestvote
    where vote = '−0'
    group by proposal_id
),

minus_1_votes as
(
    select proposal_id, count(*)
    from reviews_latestvote
    where vote = '−1'
    group by proposal_id
),

agg_score as
(
    select proposal_id,
    count(*) as total_votes,
    sum(
        case when vote = '+1' then 1
        when vote = '+0' then 0
        when vote = '−0' then 0
        when vote = '−1' then -1
        end) as agg_score
    from reviews_latestvote
    group by proposal_id
),

matt_vote as
(
    select rlv.proposal_id,

    case when rlv.vote = '+1' then 1
    when rlv.vote = '+0' then 0
    when rlv.vote = '−0' then 0
    when rlv.vote = '−1' then -1
    end as matt_vote

    from reviews_latestvote rlv
    join auth_user
    on rlv.user_id = auth_user.id
    where auth_user.email = 'matt@tplus1.com'
)

select

ppb.id, --1
ppb.title,  --2

coalesce(talks.audience_level, tutorials.audience_level) as aud_level_int, --3

case
when coalesce(talks.audience_level, tutorials.audience_level) = 1
then 'Novice (1)'

when coalesce(talks.audience_level, tutorials.audience_level) = 2
then 'Experienced (2)'

when coalesce(talks.audience_level, tutorials.audience_level) = 3
then 'Intermediate (3)'
end as audience_level, --4

spkr.name as speaker, --5
case
when ppk.name = 'Short Talk (20 minutes)' then 0.5
when ppk.name = 'Talk (40 minutes)' then 1.0
when ppk.name = 'Tutorial (110 minutes)' then 2.0
end as proposal_length, --6

coalesce(plus_1_votes.count, 0) as plus_1_votes, --7

100 * coalesce(plus_1_votes.count, 0) / agg_score.total_votes as approval_rating, --8

agg_score.total_votes, --9
agg_score.agg_score, --10
ppk.name as kind_of_talk,
coalesce(plus_0_votes.count, 0) as plus_0_votes,
coalesce(minus_0_votes.count, 0) as minus_0_votes,
coalesce(minus_1_votes.count, 0) as minus_1_votes,

coalesce(matt_vote.matt_vote, 0) as matt_vote,

rpr.status

from proposals_proposalbase ppb

left join proposals_talkproposal talks
on ppb.id = talks.proposalbase_ptr_id

left join proposals_tutorialproposal tutorials
on ppb.id = tutorials.proposalbase_ptr_id

join speakers_speaker spkr
on ppb.speaker_id = spkr.id

join proposals_proposalkind ppk
on ppb.kind_id = ppk.id

left join plus_1_votes
on ppb.id = plus_1_votes.proposal_id

left join plus_0_votes
on ppb.id = plus_0_votes.proposal_id

left join minus_0_votes
on ppb.id = minus_0_votes.proposal_id

left join minus_1_votes
on ppb.id = minus_1_votes.proposal_id

left join agg_score
on ppb.id = agg_score.proposal_id

left join reviews_proposalresult rpr
on ppb.id = rpr.proposal_id

left join matt_vote
on ppb.id = matt_vote.proposal_id

where ppk.name != 'Open Space'

and rpr.status != 'rejected'

and ppb.cancelled = false

order by 7 desc,  -- plus_1_votes
8 desc,  -- approval rating
matt_vote desc
;

create or replace view each_speakers_best_proposals

as

select distinct on (speaker) speaker, title, id

from all_proposals

order by speaker,
plus_1_votes desc,
approval_rating desc,
matt_vote desc
;

create or replace view top_proposals

as

select ap.*,
sum(proposal_length) over (order by plus_1_votes desc, approval_rating desc, matt_vote desc, ap.title)
as cumulative_proposal_length,

rank() over (order by plus_1_votes desc, approval_rating desc, matt_vote desc, ap.title)

from all_proposals ap

join each_speakers_best_proposals esbp
on ap.speaker = esbp.speaker
and ap.id = esbp.id

order by plus_1_votes desc, approval_rating desc, matt_vote desc, ap.title

;

