SELECT *
FROM {{ ref('model_a1') }}
UNION
SELECT *
FROM {{ ref('model_a2') }}
