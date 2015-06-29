alter table proposals_proposalbase
add column preferred_date date,
add column preferred_time tstzrange,
add column preference_notes text,
add column confirmed_standby timestamptz,
add column confirmed_accepted timestamptz;

