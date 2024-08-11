CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE "User";
CREATE TABLE "User"
            (
                "id"    uuid              NOT NULL DEFAULT uuid_generate_v4(),
                "email" character varying NOT NULL,
                "name"  character varying,
                CONSTRAINT "UQ_User_email" UNIQUE ("email"),
                CONSTRAINT "PK_User_id" PRIMARY KEY ("id")
            );
ALTER TABLE "User" REPLICA IDENTITY FULL;
			
INSERT INTO "User" (email, name)
VALUES ('anmol+1@apg.com', CONCAT('name_', (random() * 1000)::INTEGER::VARCHAR))
ON CONFLICT (email) DO UPDATE SET name = EXCLUDED.name
RETURNING *;

INSERT INTO "User" (email, name)
VALUES ('anmol+2@apg.com', 'name_2');

UPDATE "User"
SET name = 'name_20'
WHERE email = 'anmol+2@apg.com';

DELETE
FROM "User"
WHERE email = 'anmol+2@apg.com';

select * from "User";

