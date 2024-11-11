SELECT *
FROM {{ source ('db_sources', 'source_table') }}
