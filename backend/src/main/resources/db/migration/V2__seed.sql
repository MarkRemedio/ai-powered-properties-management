-- Seed data for the hiring exercise.
--
-- NOTE: arrivals are seeded RELATIVE TO current_date and anchored to each property's
-- local timezone, so "today" is always populated no matter when the exercise is run.
-- This is why the exercise never goes stale.

insert into property (id, code, name, timezone) values
  ('11111111-1111-1111-1111-111111111111', 'ZRH', 'Magic Hotel Zurich',  'Europe/Zurich'),
  ('22222222-2222-2222-2222-222222222222', 'LON', 'Magic Suites London', 'Europe/London'),
  ('33333333-3333-3333-3333-333333333333', 'SYD', 'Magic Stay Sydney',   'Australia/Sydney');

insert into unit (id, property_id, label, floor) values
  ('a1000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', '101', 1),
  ('a1000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', '102', 1),
  ('a1000000-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', '201', 2),
  ('a1000000-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', '202', 2),
  ('a1000000-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'PH1', 9),
  ('a2000000-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'A-1', 1),
  ('a2000000-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'A-2', 1),
  ('a2000000-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'B-1', 2),
  ('a2000000-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 'B-2', 2),
  ('a3000000-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', 'S-01', 1),
  ('a3000000-0000-0000-0000-000000000002', '33333333-3333-3333-3333-333333333333', 'S-02', 1),
  ('a3000000-0000-0000-0000-000000000003', '33333333-3333-3333-3333-333333333333', 'S-03', 2);

-- Helper expression used below:
--   (current_date + interval 'N hours') at time zone '<tz>'
-- reads as "today at N o'clock, property local time", stored as timestamptz.

insert into reservation (id, property_id, guest_name, arrival, departure, unit_id, status) values

  -- ===== ZURICH: today's arrivals =====
  ('b1000000-0000-0000-0000-000000000001', '11111111-1111-1111-1111-111111111111', 'Anna Weber',
   (current_date + interval '15 hours') at time zone 'Europe/Zurich',
   (current_date + interval '3 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000001', 'CONFIRMED'),

  ('b1000000-0000-0000-0000-000000000002', '11111111-1111-1111-1111-111111111111', 'Marc Dupont',
   (current_date + interval '16 hours 30 minutes') at time zone 'Europe/Zurich',
   (current_date + interval '2 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000002', 'CONFIRMED'),

  -- no unit assigned yet: what should the UI show?
  ('b1000000-0000-0000-0000-000000000003', '11111111-1111-1111-1111-111111111111', 'Priya Raman',
   (current_date + interval '17 hours') at time zone 'Europe/Zurich',
   (current_date + interval '4 days 11 hours') at time zone 'Europe/Zurich',
   null, 'CONFIRMED'),

  -- already checked in: still an "arrival"?
  ('b1000000-0000-0000-0000-000000000004', '11111111-1111-1111-1111-111111111111', 'Tom Fischer',
   (current_date + interval '13 hours') at time zone 'Europe/Zurich',
   (current_date + interval '2 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000003', 'IN_HOUSE'),

  -- cancelled: should not normally be listed
  ('b1000000-0000-0000-0000-000000000005', '11111111-1111-1111-1111-111111111111', 'Lena Hofer',
   (current_date + interval '18 hours') at time zone 'Europe/Zurich',
   (current_date + interval '3 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000004', 'CANCELLED'),

  -- 23:30 local: the timezone boundary case
  ('b1000000-0000-0000-0000-000000000006', '11111111-1111-1111-1111-111111111111', 'Yuki Tanaka',
   (current_date + interval '23 hours 30 minutes') at time zone 'Europe/Zurich',
   (current_date + interval '2 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000005', 'CONFIRMED'),

  -- 00:30 local TOMORROW: must NOT appear in today's list
  ('b1000000-0000-0000-0000-000000000007', '11111111-1111-1111-1111-111111111111', 'Oscar Lindqvist',
   (current_date + interval '1 day 30 minutes') at time zone 'Europe/Zurich',
   (current_date + interval '4 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000001', 'CONFIRMED'),

  -- yesterday: must NOT appear
  ('b1000000-0000-0000-0000-000000000008', '11111111-1111-1111-1111-111111111111', 'Sofia Rossi',
   (current_date - interval '1 day' + interval '15 hours') at time zone 'Europe/Zurich',
   (current_date + interval '1 day 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000002', 'IN_HOUSE'),

  ('b1000000-0000-0000-0000-000000000009', '11111111-1111-1111-1111-111111111111', 'Nadia Haddad',
   (current_date + interval '19 hours 15 minutes') at time zone 'Europe/Zurich',
   (current_date + interval '5 days 11 hours') at time zone 'Europe/Zurich',
   'a1000000-0000-0000-0000-000000000003', 'CONFIRMED'),

  ('b1000000-0000-0000-0000-000000000010', '11111111-1111-1111-1111-111111111111', 'Jonas Berg',
   (current_date + interval '14 hours 45 minutes') at time zone 'Europe/Zurich',
   (current_date + interval '2 days 11 hours') at time zone 'Europe/Zurich',
   null, 'CONFIRMED'),

  -- ===== LONDON =====
  ('b2000000-0000-0000-0000-000000000001', '22222222-2222-2222-2222-222222222222', 'Grace Okafor',
   (current_date + interval '15 hours') at time zone 'Europe/London',
   (current_date + interval '3 days 11 hours') at time zone 'Europe/London',
   'a2000000-0000-0000-0000-000000000001', 'CONFIRMED'),

  ('b2000000-0000-0000-0000-000000000002', '22222222-2222-2222-2222-222222222222', 'Liam O''Connor',
   (current_date + interval '16 hours') at time zone 'Europe/London',
   (current_date + interval '2 days 11 hours') at time zone 'Europe/London',
   'a2000000-0000-0000-0000-000000000002', 'CONFIRMED'),

  ('b2000000-0000-0000-0000-000000000003', '22222222-2222-2222-2222-222222222222', 'Mei Chen',
   (current_date + interval '20 hours') at time zone 'Europe/London',
   (current_date + interval '3 days 11 hours') at time zone 'Europe/London',
   null, 'CONFIRMED'),

  ('b2000000-0000-0000-0000-000000000004', '22222222-2222-2222-2222-222222222222', 'Ahmed Saleh',
   (current_date + interval '23 hours 45 minutes') at time zone 'Europe/London',
   (current_date + interval '2 days 11 hours') at time zone 'Europe/London',
   'a2000000-0000-0000-0000-000000000003', 'CONFIRMED'),

  ('b2000000-0000-0000-0000-000000000005', '22222222-2222-2222-2222-222222222222', 'Elena Petrova',
   (current_date + interval '12 hours') at time zone 'Europe/London',
   (current_date + interval '1 day 11 hours') at time zone 'Europe/London',
   'a2000000-0000-0000-0000-000000000004', 'NO_SHOW'),

  ('b2000000-0000-0000-0000-000000000006', '22222222-2222-2222-2222-222222222222', 'Pedro Alves',
   (current_date + interval '2 days 15 hours') at time zone 'Europe/London',
   (current_date + interval '5 days 11 hours') at time zone 'Europe/London',
   'a2000000-0000-0000-0000-000000000001', 'CONFIRMED'),

  -- ===== SYDNEY: far-offset property. Its "today" differs from Europe's for many hours. =====
  ('b3000000-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333', 'Chloe Martin',
   (current_date + interval '15 hours') at time zone 'Australia/Sydney',
   (current_date + interval '3 days 11 hours') at time zone 'Australia/Sydney',
   'a3000000-0000-0000-0000-000000000001', 'CONFIRMED'),

  ('b3000000-0000-0000-0000-000000000002', '33333333-3333-3333-3333-333333333333', 'Wiremu Ngata',
   (current_date + interval '9 hours') at time zone 'Australia/Sydney',
   (current_date + interval '2 days 11 hours') at time zone 'Australia/Sydney',
   'a3000000-0000-0000-0000-000000000002', 'CONFIRMED'),

  ('b3000000-0000-0000-0000-000000000003', '33333333-3333-3333-3333-333333333333', 'Isabella Silva',
   (current_date + interval '22 hours') at time zone 'Australia/Sydney',
   (current_date + interval '4 days 11 hours') at time zone 'Australia/Sydney',
   null, 'CONFIRMED'),

  ('b3000000-0000-0000-0000-000000000004', '33333333-3333-3333-3333-333333333333', 'Hiroshi Sato',
   (current_date + interval '17 hours 30 minutes') at time zone 'Australia/Sydney',
   (current_date + interval '2 days 11 hours') at time zone 'Australia/Sydney',
   'a3000000-0000-0000-0000-000000000003', 'IN_HOUSE'),

  ('b3000000-0000-0000-0000-000000000005', '33333333-3333-3333-3333-333333333333', 'Amara Diallo',
   (current_date + interval '1 day 10 hours') at time zone 'Australia/Sydney',
   (current_date + interval '3 days 11 hours') at time zone 'Australia/Sydney',
   'a3000000-0000-0000-0000-000000000001', 'CONFIRMED');
