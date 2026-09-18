# LIKE MAGIC: Full Stack Engineer Take-Home Exercise

**Timebox: 2 to 3 hours  •  AI encouraged  •  Return within one week**

Thanks for making it to this stage. This exercise is designed to show us how you
think and how you learn, not how much of our stack you already know.

Everything you need is in this file. There is no separate brief.

> **Run `./verify.sh` on the day you receive this repo, not the day you start
> work.** The first build downloads a few hundred megabytes. You should not spend
> your timebox waiting for Maven.

---

## Before you start

A word up front, because it matters: this exercise uses Spring WebFlux, R2DBC
and GraphQL. Most strong candidates have not worked with the reactive stack
before. That is intentional and it is not a trap. We want to see how you get
productive in unfamiliar territory, because that is what your first month here
would actually look like.

So please use AI freely. We do, every day. What we care about is whether you
understand what you shipped. We would much rather see 60% finished and fully
understood than 100% finished and not.

This is a fictional scenario. It is not live work, and we will not use your
output in our product.

---

## What you get

A running starter repository, so you spend your time on the feature and not on
setup. It contains:

- Spring Boot with WebFlux, R2DBC and Spring GraphQL, already wired up.
- PostgreSQL with migrations and seed data, started via Docker Compose.
- A React 18, TypeScript, Vite and MUI frontend with GraphQL codegen configured.
- One complete example query, end to end. Database through repository, GraphQL
  schema and resolver, to a rendered React component. Use it as your pattern.

If the repository does not start cleanly for you, tell us straight away. That is
our bug, not yours, and we do not want it eating your time.

---

## Requirements

| Tool   | Version |
| ------ | ------- |
| Docker | any recent |
| JDK    | 25 (Temurin 25 is what we run) |
| Node   | 22 (see `frontend/.nvmrc`), 20+ works |

## Getting started

```bash
./verify.sh                             # checks tooling, ports, starts the DB, builds both sides
```

Then, in two terminals:

```bash
cd backend  && ./mvnw spring-boot:run   # http://localhost:8080
cd frontend && npm run dev              # http://localhost:5173
```

| What | Where |
| ---- | ----- |
| App | http://localhost:5173 |
| GraphiQL (explore the schema, run queries) | http://localhost:8080/graphiql |
| Postgres | `localhost:55432`, db `magic`, user `magic`, password `magic` |

Port 55432 is deliberate, so it does not clash with a Postgres you may already
be running on 5432.

### Reset the database

```bash
docker compose down -v && docker compose up -d
```

Ten seconds, and you are back to clean seed data. Use it freely. Seed arrival
times are computed when the migration runs, so if you leave the database up
overnight, reset it before you continue or "today" will look empty.

---

## The stack

**Backend**: Java 25, Spring Boot 3.5, **Spring WebFlux (reactive)**, **R2DBC**,
Spring GraphQL, Flyway, PostgreSQL.

**Frontend**: React 18, TypeScript, Vite, MUI, Redux Toolkit + RTK Query,
GraphQL Codegen.

If the reactive stack is new to you, that is expected and fine. See the note in
"Before you start".

> Flyway does not speak R2DBC, so migrations run over a plain JDBC connection
> while the application itself uses R2DBC. That is why both drivers are on the
> classpath and why `application.yml` has two database URLs. This is normal for
> reactive Spring projects and is not something you need to change.

---

## What is already here: the worked example

A complete vertical slice you can use as your pattern. Follow it end to end:

| Layer | File |
| ----- | ---- |
| Schema | `backend/src/main/resources/graphql/schema.graphqls` (`properties` query) |
| Resolver | `backend/.../property/PropertyGraphqlController.java` |
| Repository | `backend/.../property/PropertyRepository.java` |
| Entity | `backend/.../property/Property.java` |
| Migrations | `backend/src/main/resources/db/migration/` |
| RTK Query endpoint | `frontend/src/features/properties/propertiesApi.ts` |
| Component | `frontend/src/features/properties/PropertyPicker.tsx` |
| Example test | `backend/src/test/.../PropertyGraphqlControllerTest.java` |

Also provided, in case you find them useful:

- `ReservationRepository` with a starting-point arrivals query
- `UnitRepository` with both a per-property and an `findAllByIdIn` lookup

## Generating types

```bash
cd frontend && npm run codegen     # backend must be running
```

End-to-end type safety is a house rule here. Please do not hand-write types the
schema can generate for you.

---

## The task

Our hosts need a simple arrivals list in the backoffice: which guests are
arriving at a property today, and which unit each one is assigned to.

Build a thin vertical slice for it.

### Backend

- Add a GraphQL query that returns today's arrivals for a given property.
- Each arrival should include the guest name, the arrival date and the label of
  the assigned unit.
- Reservations and units live in separate tables. The seed data reflects that.

### Frontend

- Add a view that lists the arrivals for a selected property.
- Handle the loading and error states in whatever way you consider reasonable.
- Keep it plain. We are not assessing visual design.

### Anything else

If you have time left, spend it on whatever you think adds the most value: a
test, a refactor, better error handling. Tell us why you chose it. If you run
out of time, stop and tell us what you would have done next.

### The data model

```
property (id, code, name, timezone)
unit     (id, property_id, label, floor)
reservation (id, property_id, guest_name, arrival, departure, unit_id, status)
```

- `reservation.unit_id` is **nullable**. Not every reservation has a unit yet.
- `reservation.status` is one of `CONFIRMED`, `IN_HOUSE`, `CHECKED_OUT`,
  `CANCELLED`, `NO_SHOW`.
- `property.timezone` is an IANA zone. Our properties are in different ones.
- Arrival times in the seed data are relative to today, so there is always
  something to show.

---

## What to hand in

**1. Your code.** Your private copy of this repository, however far you got.
Open a pull request inside your own copy, from a `solution` branch into `main`,
and add `@gabac` as a read-only collaborator. That gives us a clean diff to read
and somewhere to leave questions before we talk.

Commit as you go rather than in one large paste at the end. We do look at the
history, and we would rather tell you that than have you find out afterwards.

If you cannot use GitHub, send us a bundle instead of a zip. It carries the
full history and clones like a normal repository:

```bash
git bundle create solution.bundle --all
```

**2. A short `NOTES.md`.** Half a page is plenty. What you built, what you did
not finish, and what you would do next. Please use a new file rather than
editing this README, so your notes do not get mixed up with the instructions.

**3. Your assumptions and open questions.** The task above is deliberately
underspecified in a few places. Write down what you assumed and what you would
have asked us.

**4. Your AI note.** Where AI helped you, and one specific place where you
overrode or corrected what it produced. If you did not override anything, say so
and tell us why.

Items 3 and 4 carry real weight in our evaluation. They are not paperwork.

---

## How we will evaluate this

We would rather be transparent than have you guess.

| Dimension | What we are looking for |
| --------- | ----------------------- |
| Reactive comprehension | You understand what the code you wrote actually does, including under load |
| Vertical slice | You got through every layer, even thinly, rather than polishing one |
| Code quality and type safety | Readable, typed end to end, consistent with the patterns in the repo |
| Handling ambiguity | You noticed what was underspecified and said so |
| AI judgment | You used AI well and you critically reviewed what it gave you |
| Learning velocity | How far you got in an unfamiliar stack in a short time |

Reactive comprehension and AI judgment carry the most weight. Note that
comprehension is not the same as getting it right first time. Understanding why
something is wrong counts for more than never having written it.

---

## Logistics and what happens next

- **Timebox**: 2 to 3 hours. Please do not go beyond it. If you hit the limit
  mid-feature, stop and write down where you got to.
- **Deadline**: please send it back within one week, so it fits around your
  current commitments.
- **Send to**: [insert email].
- **Next step**: a 60-minute conversation with two of our engineers. We will
  walk through your code, ask you to reason about how it behaves at scale, and
  change the requirements on you to see how you adapt. That is intentional and
  it is the most useful part for both of us.

If anything is unclear, just ask. Asking is a good sign, not a weak one.

## Something not working?

Tell us. If the repo does not start cleanly on a supported setup, that is our
bug and not yours, and we would rather fix it than have it cost you time.

---

*It's not imagination, it's likeMagic.*
