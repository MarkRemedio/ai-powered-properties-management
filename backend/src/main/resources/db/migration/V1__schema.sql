-- LIKE MAGIC hiring exercise: minimal slice of the reservation domain.

create table property (
    id       uuid primary key,
    code     text not null unique,
    name     text not null,
    timezone text not null            -- IANA zone, e.g. 'Europe/Zurich'
);

create table unit (
    id          uuid primary key,
    property_id uuid not null references property (id),
    label       text not null,
    floor       int
);

create table reservation (
    id          uuid primary key,
    property_id uuid        not null references property (id),
    guest_name  text        not null,
    arrival     timestamptz not null,
    departure   timestamptz not null,
    unit_id     uuid        references unit (id),   -- nullable: not every reservation has a unit yet
    status      text        not null                -- CONFIRMED | IN_HOUSE | CHECKED_OUT | CANCELLED | NO_SHOW
);

create index idx_reservation_property_arrival on reservation (property_id, arrival);
create index idx_unit_property on unit (property_id);
