-- event_dictionary
CREATE DICTIONARY
lrunjic.event_dictionary
(
    id            Int32,
    sport_id      Int32,
    tournament_id Int32,
    season_id     Nullable(Int32),
    venue_id      Nullable(Int32),
    referee_id    Nullable(Int32),
    attendance    Nullable(Int32),
    startdate     DateTime64(6),
    hometeam_id   Int32,
    awayteam_id   Int32
)
PRIMARY KEY id
SOURCE (CLICKHOUSE(
        DB 'sports'
        TABLE 'event'
        USER 'lrunjic'
        PASSWORD 'frB210Ajo88Y8H9afHv5'
))
LAYOUT (HASHED()) -- because of many different ids
LIFETIME(MIN 0 MAX 1000);

-- sport_dictionary
CREATE DICTIONARY
lrunjic.sport_dictionary
(
    id   String,
    name String,
    slug String,
    externalid Nullable(Int32)
)
PRIMARY KEY id
SOURCE (CLICKHOUSE(
        DB 'sports'
        TABLE 'sport'
        USER 'lrunjic'
        PASSWORD 'frB210Ajo88Y8H9afHv5'
))
LAYOUT (FLAT()) -- because there are not many different ids
LIFETIME(MIN 0 MAX 1000);

-- tournament_dictionary
CREATE DICTIONARY
lrunjic.tournament_dictionary
(
    id       Int32,
    uniquetournament_id Nullable(Int32),
    name     String,
    slug     String,
    priority Int32,
    order    Int32,
    visible  UInt8,
    startdate Nullable(DateTime64(6)),
    enddate Nullable(DateTime64(6))
)
PRIMARY KEY id
SOURCE (CLICKHOUSE(
        DB 'sports'
        TABLE 'tournament'
        USER 'lrunjic'
        PASSWORD 'frB210Ajo88Y8H9afHv5'
))
LAYOUT (HASHED()) -- because of many different ids
LIFETIME(MIN 0 MAX 1000);

-- uniquetournament_dictionary
CREATE DICTIONARY
lrunjic.uniquetournament_dictionary
(
    id           Int32,
    name         String,
    slug         String,
    priority     Int32,
    order        Int32,
    externalid Nullable(Int32),
    externaltype Int16,
    createdat    DateTime64(6),
    updatedat    DateTime64(6),
    startdate Nullable(DateTime64(6)),
    enddate Nullable(DateTime64(6))
)
PRIMARY KEY id
SOURCE (CLICKHOUSE(
        DB 'sports'
        TABLE 'uniquetournament'
        USER 'lrunjic'
        PASSWORD 'frB210Ajo88Y8H9afHv5'
))
LAYOUT (FLAT()) -- because there are not many different ids
LIFETIME(MIN 0 MAX 1000);

-- team_dictionary
CREATE DICTIONARY
lrunjic.team_dictionary
(
    id          Int32,
    sport_id    Int32,
    category_id Int32,
    tournament_id Nullable(Int32),
    name        String,
    slug        String,
    shortname Nullable(String),
    gender Nullable(String)
)
PRIMARY KEY id
SOURCE (CLICKHOUSE(
        DB 'sports'
        TABLE 'team'
        USER 'lrunjic'
        PASSWORD 'frB210Ajo88Y8H9afHv5'
))
LAYOUT (HASHED()) -- because of many different ids
LIFETIME(MIN 0 MAX 1000);

-- player_dictionary
CREATE DICTIONARY
lrunjic.player_dictionary
(
    id      Int32,
    team_id Int32,
    name    String,
    position Nullable(String),
    weight Nullable(Int32),
    height Nullable(Int32),
    preferredfoot Nullable(String),
    marketvalue Nullable(Int32),
    retired Nullable(UInt8)
)
PRIMARY KEY id
SOURCE (CLICKHOUSE(
        DB 'sports'
        TABLE 'player'
        USER 'lrunjic'
        PASSWORD 'frB210Ajo88Y8H9afHv5'
))
LAYOUT (HASHED()) -- because of many different ids
LIFETIME(MIN 0 MAX 1000);

















