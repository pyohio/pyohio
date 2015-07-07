alter table proposals_proposalbase
add column confirmed_after_first_pass timestamptz,
add column confirmed_accepted timestamptz;

create table speaker_available_times
(

    speaker_id integer not null
    references speakers_speaker (id)
    on delete cascade,

    available_time tstzrange not null

);

create table speaker_preferred_times
(

    speaker_id integer not null
    references speakers_speaker (id)
    on delete cascade,

    preferred_time tstzrange not null

);
