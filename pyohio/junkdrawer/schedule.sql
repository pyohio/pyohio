create extension if not exists "citext";

drop table if exists rooms cascade;

create table rooms
(
    title citext primary key,
    description text
);

insert into rooms (title) values
('Cartoon 1'),
('Cartoon 2'),
('Cartoon 1 and 2'),
('Barbie Tootle'),
('Hays Cape'),
('Rosa Aliabouni'),
('Suzanne Scharer'),
('Tanya Rutner')
;


-- Add constraints to prevent two talks in the same room for overlapping
-- amounts of time.

-- One talk can be in two rooms, as long as the start and stop times are
-- the same.

drop table if exists schedule cascade;

create table schedule
(
    room citext not null references rooms (title)
    on delete cascade on update cascade,

    start_time timestamptz,

    proposal_id integer not null
    references proposals_proposalbase (id)
    on delete cascade on update cascade

);

create or replace view unscheduled_proposals
as
select tp.*
from top_proposals tp

left join schedule sk
on tp.id = sk.proposal_id

where sk.room is NULL

order by rank;

insert into schedule
(room, start_time, proposal_id)

values

('Cartoon 1 and 2', '2015-08-02 11:30', 200),

('Cartoon 1', '2015-08-01 10:30', 277),
('Cartoon 1', '2015-08-01 11:30', 231),

('Cartoon 1', '2015-08-01 14:00', 285),
('Cartoon 1', '2015-08-01 14:30', 203),
('Cartoon 1', '2015-08-01 15:30', 280),
('Cartoon 1', '2015-08-01 16:30', 265),
('Cartoon 1', '2015-08-01 17:30', 221),

('Cartoon 1', '2015-08-02 13:00', 267),
('Cartoon 1', '2015-08-02 14:00', 303),

('Cartoon 1', '2015-08-02 15:00', 271),

-- Talk 208 would prefer to be on Saturday, not Sunday
('Cartoon 1', '2015-08-02 16:00', 208),

('Cartoon 2', '2015-08-01 10:30', 300),
('Cartoon 2', '2015-08-01 11:00', 227),
('Cartoon 2', '2015-08-01 11:30', 197),
('Cartoon 2', '2015-08-01 14:00', 274),
('Cartoon 2', '2015-08-01 15:00', 272),
('Cartoon 2', '2015-08-01 15:30', 259),
('Cartoon 2', '2015-08-01 16:30', 262),
('Cartoon 2', '2015-08-01 17:30', 291),

('Cartoon 2', '2015-08-02 13:00', 228),
('Cartoon 2', '2015-08-02 14:00', 219),
('Cartoon 2', '2015-08-02 15:00', 289),
('Cartoon 2', '2015-08-02 16:00', 282),

('Hays Cape', '2015-08-01 10:30', 264),
('Hays Cape', '2015-08-01 11:30', 220),
('Hays Cape', '2015-08-01 14:00', 233),
('Hays Cape', '2015-08-01 15:00', 205),
('Hays Cape', '2015-08-01 16:00', 269),
('Hays Cape', '2015-08-01 17:00', 292),

('Hays Cape', '2015-08-02 13:00', 245),
('Hays Cape', '2015-08-02 14:00', 239),
('Hays Cape', '2015-08-02 15:00', 209),
('Hays Cape', '2015-08-02 16:00', 266),
('Hays Cape', '2015-08-02 16:30', 284),

('Barbie Tootle', '2015-08-01 10:30', 294),
('Barbie Tootle', '2015-08-01 14:00', 211),
('Barbie Tootle', '2015-08-01 16:00', 244),
('Barbie Tootle', '2015-08-02 13:00', 297),
('Barbie Tootle', '2015-08-02 14:00', 217),
('Barbie Tootle', '2015-08-02 15:00', 261),
('Barbie Tootle', '2015-08-02 16:00', 258)

;

create or replace view pretty_schedule
as
select tp.*, sk.room, sk.start_time,
sk.start_time + interval '1 hour' * tp.proposal_length as end_time
from schedule sk
join top_proposals tp
on sk.proposal_id = tp.id
order by case when room = 'Cartoon 1' then 1 when room = 'Cartoon 2' then 2 when room = 'Hays Cape' then 3 else 4 end,
start_time;
